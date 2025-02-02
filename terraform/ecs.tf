module "ecs" {
  source = "terraform-aws-modules/ecs/aws"
  cluster_name = var.ecs_cluster_name
  services = {
    ecs-frontend = {
      cpu    = var.ecs_task_cpu
      memory = var.ecs_task_memory

      container_definitions ={
        flaskapp = {
          essential = true
          image     = var.ecs_container_image
          port_mappings = [
            {
              name          = "flaskapp"
              containerPort = 5000
              protocol      = "tcp"
            }
          ]
        }
      }
    subnet_ids = [aws_subnet.private_subnets["private_subnet_1"].id, aws_subnet.private_subnets["private_subnet_2"].id]
    autoscaling_enabled = false
    security_group_rules = {
        alb_ingress_5000 = {
          type                     = "ingress"
          from_port                = 5000
          to_port                  = 5000
          protocol                 = "tcp"
          description              = "Flask App port"
          source_security_group_id = aws_security_group.webapp_sg.id
        }
        egress_all = {
          type        = "egress"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }
    load_balancer = {
        service = {
          target_group_arn = aws_lb_target_group.flaskapp_tg.arn
          container_name   = "flaskapp"
          container_port   = 5000
        }
      }
    }
      depends_on = [
    aws_lb_target_group.flaskapp_tg
  ]
  }
}
