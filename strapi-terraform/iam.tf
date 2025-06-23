# # Reference existing IAM role instead of creating it
# data "aws_iam_role" "ecs_task_execution" {
#   name = "ecsTaskExecutionRolePersonal"
# }

# resource "aws_iam_role_policy_attachment" "ecs_task_policy_attach" {
#   role       = data.aws_iam_role.ecs_task_execution.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
# }
