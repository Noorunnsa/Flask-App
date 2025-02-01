variable "private_subnets" {
  default = {
    "private_subnet_1" = 1
    "private_subnet_2" = 2
  }
}
variable "public_subnets" {
  default = {
    "public_subnet_1" = 1
    "public_subnet_2" = 2
   }
}
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}
variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
}
variable "ecs_container_image" {
  description = "Container Image for deploying the Flask Application"
  type        = string
}
variable "ecs_task_cpu" {
  description = "CPU allocation for ECS Task"
  type        = string
}
variable "ecs_task_memory" {
  description = "Memory allocation for ECS Task"
  type        = string
}
variable "region" {
  description = "AWS region for the deployment"
  type        = string
}
variable "alb_name" {
  description = "Name of the Application Load Balancer"
  type        = string
}