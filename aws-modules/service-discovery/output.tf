output "redis_discovery_arn" {
  value = aws_service_discovery_service.redis_arn.arn
}

output "frontend_discovery_arn" {
  value = aws_service_discovery_service.frontend_arn.arn
}

output "user_ms_discovery_arn" {
  value = aws_service_discovery_service.users_ms_arn.arn
}

output "cron_ms_discovery_arn" {
  value = aws_service_discovery_service.cron_ms_arn.arn
}

output "ecs_organization_ms_discovery_arn" {
  value = aws_service_discovery_service.organization_ms_arn.arn
}

output "tasks_ms_discovery_arn" {
  value = aws_service_discovery_service.tasks_ms_arn.arn
}

output "master_ms_discovery_arn" {
  value = aws_service_discovery_service.master_ms_arn.arn
}

output "license_ms_discovery_arn" {
  value = aws_service_discovery_service.license_ms_arn.arn
}
