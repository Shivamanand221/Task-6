# output "ec2_public_ip" {
#   description = "Public IP of the EC2 instance"
#   value       = aws_instance.strapi_ec2.public_ip
# }


output "strapi_task_arn" {
  value = aws_ecs_task_definition.strapi.arn
}

output "strapi_service_name" {
  value = aws_ecs_service.strapi.name
}
