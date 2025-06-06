output "cloudwatch_ecs_redis_name" {
  value = aws_cloudwatch_log_group.cloudwatch_ecs_redis_name.name
}

output "cloudwatch_ecs_frontend_name" {
  value = aws_cloudwatch_log_group.cloudwatch_ecs_frontend_name.name
}

output "cloudwatch_ecs_master_ms_name" {
  value = aws_cloudwatch_log_group.cloudwatch_ecs_master_ms_name.name
}

output "cloudwatch_ecs_tasks_ms_name" {
  value = aws_cloudwatch_log_group.cloudwatch_ecs_tasks_ms_name.name
}

output "cloudwatch_ecs_cron_ms_name" {
  value = aws_cloudwatch_log_group.cloudwatch_ecs_cron_ms_name.name
}

output "cloudwatch_ecs_user_ms_name" {
  value = aws_cloudwatch_log_group.cloudwatch_ecs_user_ms_name.name
}

output "cloudwatch_ecs_organization_ms_name" {
  value = aws_cloudwatch_log_group.cloudwatch_ecs_organization_ms_name.name
}


output "cloudwatch_ecs_license_ms_name" {
  value = aws_cloudwatch_log_group.cloudwatch_ecs_license_ms_name.name
}
