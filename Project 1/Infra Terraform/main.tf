##############################################################
# List of Locals / Define Local Values
##############################################################

locals {
  ami                = var.custom_ami
  subnet-ec2         = var.subnet
  instance-type      = "t3.2xlarge"
  security-group-ec2 = var.security_group_ec2
  security-group-alb = var.security_group_alb
  availability-zone  = var.availability_zone
  key-pair-name      = "rasa-key"
  # iam-role-name     = "${var.iam_role_name}"
  # iam-role-arn      = "${var.iam_role_arn}"
  name-ec2               = "Rasa-Prod-new-vpc"
  environment            = "Production"
  access_log_bucket_name = ""
  vpc-id                 = var.vpc_id
  subnet-public1a-alb    = var.subnet_public1a
  subnet-public1b-alb    = var.subnet_public1b
}


##############################################################
# List of Data Sources
##############################################################

data "aws_subnet" "optum_private_1b_ec2" {
  id = local.subnet-ec2
}

data "aws_security_group" "security_group_ec2" {
  id = local.security-group-ec2
}

data "aws_availability_zone" "availability_zone" {
  name = local.availability-zone
}

data "aws_key_pair" "key_pair_name" {
  key_name = local.key-pair-name
}

data "aws_vpc" "vpc_id" {
  id = local.vpc-id
}

data "aws_security_group" "security_group_alb" {
  id = local.security-group-alb
}

data "aws_subnet" "optum_public_1a_alb" {
  id = local.subnet-public1a-alb
}

data "aws_subnet" "optum_public_1b_alb" {
  id = local.subnet-public1b-alb
}

# data "aws_iam_role" "iam_role" {
#   name = var.iam_role_name
#   arn = var.iam_role_arn
# }


##############################################################
# EC2 Instance for Advisory-ChatBot-Prod
##############################################################

resource "aws_instance" "chatbot_ec2" {
  ami                         = local.ami
  instance_type               = local.instance-type
  associate_public_ip_address = false
  key_name                    = data.aws_key_pair.key_pair_name.key_name
  subnet_id                   = data.aws_subnet.optum_private_1b_ec2.id
  iam_instance_profile        = var.iam_role_arn
  vpc_security_group_ids      = [data.aws_security_group.security_group_ec2.id]
  availability_zone           = data.aws_availability_zone.availability_zone.name
  user_data                   = file("userdata.sh")
  tags = {
    "Name"      = local.name-ec2
    "Env"       = local.environment
    "Terraform" = "True"
  }
}


##############################################################
# Application Load Balancer for CharBot EC2
##############################################################

resource "aws_lb" "alb_chatbot" {
  name               = "alb-chatbot-prod"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [data.aws_security_group.security_group_alb.id]
  subnets            = [data.aws_subnet.optum_public_1a_alb.id, data.aws_subnet.optum_public_1b_alb.id]

  subnet_mapping {
    subnet_id = data.aws_subnet.optum_public_1a_alb.id
  }
  subnet_mapping {
    subnet_id = data.aws_subnet.optum_public_1b_alb.id
  }

  enable_deletion_protection = true

  access_logs {
    bucket  = local.access_log_bucket_name
    prefix  = "AdvisoryChatBotProd"
    enabled = true
  }

  tags = {
    "Name"        = "alb-chatbot-prod"
    "Environment" = "production"
    "Terraform"   = "True"
  }
}


##############################################################
# Listener for Application Load Balancer (alb_chatbot)
##############################################################

resource "aws_lb_listener" "https_listener" {
  load_balancer_arn = aws_lb.alb_chatbot.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = "arn:aws:acm:us-east-1:546140078785:certificate/b1387ae7-622c-45d2-9468-6c1ab1f62e5b"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Path not found"
      status_code  = "404"
    }
  }
}

##############################################################
# Target Group Creation
##############################################################

resource "aws_lb_target_group" "alb_tg" {
  name     = "EDM-rasa-chat-bot-TG"
  port     = 5005
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.vpc_id.id
  health_check {
    protocol            = "HTTP"
    path                = "/"
    port                = 5005
    healthy_threshold   = 5
    unhealthy_threshold = 4
    timeout             = 5
    interval            = 30
    matcher             = "200"
  }
  lifecycle {
    create_before_destroy = true
  }
  depends_on = [
    aws_lb.alb_chatbot
  ]
}


#####################################################################
# Target Group Attachment / Register Targets under Target group
#####################################################################

resource "aws_lb_target_group_attachment" "test" {
  target_group_arn = aws_lb_target_group.alb_tg.arn
  target_id        = aws_instance.chatbot_ec2.id
  port             = 5005
}


##############################################################
# Rules for Application Load Balancer Listener (Two Rules)
##############################################################

############ RULE - 1 ############

resource "aws_lb_listener_rule" "forward_rule_1" {
  listener_arn = aws_lb_listener.https_listener.arn
  priority     = 2

  condition {
    path_pattern {
      values = ["/webhooks/rest/webhook"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}

############ RULE - 2 ############

resource "aws_lb_listener_rule" "forward_rule_2" {
  listener_arn = aws_lb_listener.https_listener.arn
  priority     = 3

  condition {
    path_pattern {
      values = ["/conversations/*/tracker"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}