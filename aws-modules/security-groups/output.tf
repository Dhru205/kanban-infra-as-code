output "ecs_sg_id" {
  value = aws_security_group.ecs_sg.id
}

output "nat_sg_id" {
  value = aws_security_group.nat_sg.id
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "postgres_sg_id" {
  value = aws_security_group.postgres_sg.id
}

output "bastion_sg_id" {
  value = aws_security_group.bastion_sg.id
}
