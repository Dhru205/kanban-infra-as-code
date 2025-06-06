output "vpc_id" {
  value = aws_vpc.prod_vpc.id
}

output "public_subnet_id" {
  value = aws_subnet.public_subnet[*].id
}

output "private_subnet_id" {
  value = aws_subnet.private_subnet[*].id
}

# output "ecs_private_subnet_id" {
#   value = aws_subnet.ecs_private_subnet[*].id
# }
