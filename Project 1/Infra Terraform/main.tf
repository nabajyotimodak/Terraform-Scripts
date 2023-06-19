##############################################################
# List of Locals / Define Local Values
##############################################################

locals {
  ami                     = var.custom_ami
  subnet-ec2              = var.subnet_private1b
  subnet-public1a-alb     = var.subnet_public1a
  subnet-public1b-alb     = var.subnet_public1b
  subnet-private1a-lambda = var.subnet_private1a
  instance-type           = "t3.2xlarge"
  security-group-ec2      = var.security_group_ec2
  security-group-alb      = var.security_group_alb
  availability-zone       = var.availability_zone
  key-pair-name           = "rasa-key"
  # iam-role-name     = "${var.iam_role_name}"
  # iam-role-arn      = "${var.iam_role_arn}"
  name-ec2               = "Rasa-Prod-new-vpc"
  environment            = "Production"
  access_log_bucket_name = "lp-cl-546140078785-us-east-1"
  vpc-id                 = var.vpc_id
}


##############################################################
# List of Data Sources
##############################################################

data "aws_subnet" "optum_public_1a_alb" {
  id = local.subnet-public1a-alb
}

data "aws_subnet" "optum_public_1b_alb" {
  id = local.subnet-public1b-alb
}

data "aws_subnet" "optum_private_1b_ec2" {
  id = local.subnet-ec2
}

data "aws_subnet" "optum_private_1a_lambda" {
  id = local.subnet-private1a-lambda
}

data "aws_security_group" "security_group_ec2" {
  id = local.security-group-ec2
}

data "aws_security_group" "security_group_alb" {
  id = local.security-group-alb
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
    Name      = local.name-ec2
    Env       = local.environment
    Terraform = "True"
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
    Name        = "alb-chatbot-prod"
    Environment = "production"
    Terraform   = "True"
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


####################################################################
#CREATION OF IAM POLICY FOR INDENTIFYING UNHEAKTHY TARGETS 
#####################################################################

resource "aws_iam_policy" "policy_for_lambda_role" {
  name        = "test_policy"
  path        = "/"
  description = "My test policy"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "LambdaLogging",
          "Effect" : "Allow",
          "Action" : [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ],
          "Resource" : "*"
        },
        {
          "Sid" : "SNS",
          "Action" : [
            "sns:Publish"
          ],
          "Effect" : "Allow",
          "Resource" : "*"
        },
        {
          "Sid" : "EC2",
          "Action" : [
            "ec2:CreateNetworkInterface",
            "ec2:Describe*",
            "ec2:AttachNetworkInterface",
            "ec2:DeleteNetworkInterface"
          ],
          "Effect" : "Allow",
          "Resource" : "*"
        },
        {
          "Sid" : "ELB",
          "Action" : [
            "elasticloadbalancing:Describe*"
          ],
          "Effect" : "Allow",
          "Resource" : "*"
        },
        {
          "Sid" : "CW",
          "Action" : [
            "cloudwatch:putMetricData"
          ],
          "Effect" : "Allow",
          "Resource" : "*"
        }
      ]
    }
  )
  tags = {
    Env       = "Prod"
    Terraform = "True"
    Name      = "Identifying_Unhealthy_ChatBot_Target_Policy"
  }
}


####################################################################
#CREATION OF IAM Role
####################################################################

resource "aws_iam_role" "iam_role_for_lambda" {
  name = "Identifying_Unhealthy_ChatBot_Targets"

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode(
    {
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Effect" : "Allow",
          "Principal" : {
            "Service" : "lambda.amazonaws.com"
          },
          "Action" : "sts:AssumeRole"
        }
      ]
    }
  )
  tags = {
    Env       = "Prod"
    Terraform = "True"
    Name      = "Identifying_Unhealthy_ChatBot_Targets"
  }
}


####################################################################
#ATTACHMENT OF THE IAM-POLICY WITH THE IAM-ROLE
####################################################################

resource "aws_iam_role_policy_attachment" "attach_IAMpolicy_to_IAMrole" {
  role       = aws_iam_role.iam_role_for_lambda.name
  policy_arn = aws_iam_policy.policy_for_lambda_role.arn
  depends_on = [aws_iam_policy.policy_for_lambda_role]
}


####################################################################
#CREATING THE 1ST SNS TOPIC
####################################################################

resource "aws_sns_topic" "sns_topic_trigger" {
  name            = "Identifying_Unhealthy_ChatBot_Targets_Lambda_Trigger"
  display_name    = "1st Topic - Identifying_Unhealthy_ChatBot_Targets_Lambda_Trigger"
  delivery_policy = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false,
    "defaultRequestPolicy": {
      "headerContentType": "text/plain; charset=UTF-8"
    }
  }
}
EOF
  tags = {
    Env  = "prod"
    Name = "Identifying_Unhealthy_ChatBot_Targets_Lambda_Trigger"

  }
}


####################################################################
#CREATING THE 2ND SNS TOPIC
####################################################################

resource "aws_sns_topic" "sns_topic_notification" {
  name            = "Identifying_Unhealthy_ChatBot_Targets_Lambda_Notification"
  display_name    = "Identifying_Unhealthy_ChatBot_Targets_Lambda_Notification"
  delivery_policy = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false,
    "defaultRequestPolicy": {
      "headerContentType": "text/plain; charset=UTF-8"
    }
  }
}
EOF
  tags = {
    Env  = "prod"
    Name = "Identifying_Unhealthy_ChatBot_Targets_Lambda_Trigger"

  }
}


######################################################################
#CREATING THE SUBSCRIPTION OF THE 2ND-SNS TOPIC (FOR NOTIFICATION)
######################################################################

resource "aws_sns_topic_subscription" "users_email_target_1" {
  topic_arn = aws_sns_topic.sns_topic_notification.arn
  protocol  = "email"
  endpoint  = "modakn@optum.com"
}

resource "aws_sns_topic_subscription" "users_email_target_2" {
  topic_arn = aws_sns_topic.sns_topic_notification.arn
  protocol  = "email"
  endpoint  = "rananth@optum.com"
}

resource "aws_sns_topic_subscription" "users_email_target_3" {
  topic_arn = aws_sns_topic.sns_topic_notification.arn
  protocol  = "email"
  endpoint  = "elangov@advisory.com"
}

resource "aws_sns_topic_subscription" "users_email_target_4" {
  topic_arn = aws_sns_topic.sns_topic_notification.arn
  protocol  = "email"
  endpoint  = "bonnettec@advisory.com"
}


######################################################################
#CREATING THE CLOUD WATCH ALARM
######################################################################

resource "aws_cloudwatch_metric_alarm" "alb_unhealthyhosts" {
  alarm_name          = "Identifying_Unhealthy_ChatBot_Targets"
  metric_name         = "UnHealthyHostCount"
  statistic           = "Maximum"
  period              = "60"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  threshold           = "3"
  evaluation_periods  = 1
  datapoints_to_alarm = "3"
  treat_missing_data  = "missing"
  namespace           = "AWS/ApplicationELB"
  alarm_description   = "Number of un-healthy nodes in Target Group"
  actions_enabled     = "true"
  alarm_actions       = [aws_sns_topic.sns_topic_trigger.arn]
  dimensions = {
    TargetGroup      = aws_lb_target_group.alb_tg.arn
    LoadBalancer     = aws_lb.alb_chatbot.arn
    AvailabilityZone = "us-east-1b"
  }
}


######################################################################
#CREATING THE LAMBDA FUNCTION
######################################################################

resource "aws_lambda_function" "test_lambda" {
  # If the file is not in the current working directory you will need to include a path.module in the filename.
  filename      = "identifying_unhealthy_targets.zip"
  function_name = "identitying_unhealthy_targets"
  role          = aws_iam_role.iam_role_for_lambda.arn
  handler       = "identitying_unhealthy_targets.lambda_handler"
  #source_code_hash = data.archive_file.lambda.output_base64sha256
  runtime = "python3.9"
  vpc_config {
    subnet_ids         = [data.aws_subnet.optum_public_1a_alb.id, data.aws_subnet.optum_public_1b_alb.id, data.aws_subnet.optum_private_1b_ec2.id, data.aws_subnet.optum_private_1a_lambda.id]
    security_group_ids = [data.aws_security_group.security_group_ec2.id]
  }
  environment {
    variables = {
      foo                  = "bar"
      NAMESPACE            = "AWS/ApplicationELB"
      ONDEMAND_HEALTHCHECK = "True"
      SNS_TOPIC            = aws_sns_topic.sns_topic_notification.arn
      TARGETGROUP_ARN      = aws_lb_target_group.alb_tg.arn
      TARGETGROUP_TYPE     = "Instance"
    }
  }
}

/*In the AWS console, after clicking a function name and selecting the configuration tab, you can create triggers.
  For example, as we need to add a SNS trigger (i.e., the 1st SNS Topic has to add as the trigger for the Lambda function),
We need to create an SNS-Topic Subscription in terraform. Similar actions can be also dome in AWS Consle orelse we have an
option to do the same in lambda function in console itself which will automatically update the SNS=Topic Subscription */

############ Creation of an SNS-Topic-Subscription for add the 1st SNS Topic as Trigger to the Lambda Function ################

resource "aws_sns_topic_subscription" "sns_trigger_to_lambda" {
  topic_arn  = aws_sns_topic.sns_topic_trigger.arn
  protocol   = "lambda"
  endpoint   = aws_lambda_function.test_lambda.arn # "lambda arn here"
  depends_on = [aws_lambda_function.test_lambda]
}