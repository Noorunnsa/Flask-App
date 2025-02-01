resource "aws_lb" "flaskapp_alb" {
  name               = var.alb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.webapp_sg.id]
  subnets = [aws_subnet.public_subnets["public_subnet_1"].id, aws_subnet.public_subnets["public_subnet_2"].id,]
  enable_deletion_protection = true
}

#Target Group for the Application Load Balancer
resource "aws_lb_target_group" "flaskapp_tg" {
  port     = "5000" # Target group forwards the incoming traffic to ECS task on this port.
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
  tags = {
    Name        = "flaskapp-dev-tg"
    Environment = "Dev"
  }
}

#Listener for the ALB
resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.webapp_alb.arn
  port              = "80" # Users access webapp on port 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.webapp_tg.arn
  }
}
