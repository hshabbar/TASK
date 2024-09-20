output "my_vpc_id" {
  description = "VPC ID"
  value = aws_vpc.my_vpc.id
}

output "public_subnet_one_id" {
  description = "Public subnet one ID"
  value = aws_subnet.my_public_subnet_one.id
}

output "public_subnet_two_id" {
  description = "Public subnet two ID"
  value = aws_subnet.my_public_subnet_two.id
}

output "private_subnet_one_id" {
  description = "Private subnet one ID"
  value = aws_subnet.my_private_subnet_one.id
}

output "private_subnet_two_id" {
  description = "Private subnet two ID"
  value = aws_subnet.my_private_subnet_two.id
}
