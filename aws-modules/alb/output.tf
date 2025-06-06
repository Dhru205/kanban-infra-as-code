output "frontend_arn" {
  value = aws_lb_target_group.frontend_ms_tg.arn
}

output "master_ms_arn" {
  value = aws_lb_target_group.master_ms_tg.arn
}

output "cron_ms_arn" {
  value = aws_lb_target_group.cron_ms_tg.arn
}

output "tasks_ms_arn" {
  value = aws_lb_target_group.tasks_ms_tg.arn
}

output "orgainzation_ms_arn" {
  value = aws_lb_target_group.organization_ms_tg.arn
}

output "users_ms_arn" {
  value = aws_lb_target_group.users_ms_tg.arn
}

output "license_ms_arn" {
  value = aws_lb_target_group.license_ms_tg.arn
}

output "alb_dns" {
  value = aws_lb.prod-alb.dns_name
}

output "alb_zone_id" {
  value = aws_lb.prod-alb.zone_id
}
