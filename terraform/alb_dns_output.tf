data "aws_lb" "flaskapp_alb" {} #Fetch the details of the Application Load Balancer 

output "alb_dns_name" {
  value = "Put this URL in the browser: http://${data.aws_lb.flaskapp_alb.dns_name}. You will see the Flask app running!"
}
