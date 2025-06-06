output "nat_eni" {
  value = aws_instance.ec2_nat.primary_network_interface_id
}
