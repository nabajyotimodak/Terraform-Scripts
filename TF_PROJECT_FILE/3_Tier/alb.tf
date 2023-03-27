resource "aws_lb" "ALB" {

  security_groups    = [aws_security_group.pubSG1.id]
  load_balancer_type = "application"
  tags = {
    Name = " ALB-PUB-LB"
  }

  subnet_mapping {
    subnet_id = aws_subnet.pubsub1.id
  }
  subnet_mapping {
    subnet_id = aws_subnet.pubsub2.id
  }
}

#Target Group
resource "aws_lb_target_group" "ALB_Target" {

  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.myvpc.id
}
resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.ALB.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ALB_Target.arn
  }
}

resource "aws_lb_target_group_attachment" "ALB1" {
  target_group_arn = aws_lb_target_group.ALB_Target.arn
  target_id        = aws_instance.public1.id
}

resource "aws_lb_target_group_attachment" "ALB2" {
  target_group_arn = aws_lb_target_group.ALB_Target.arn
  target_id        = aws_instance.public2.id
}