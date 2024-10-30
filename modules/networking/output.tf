output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = aws_subnet.public_subnets[*].id
}

output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = aws_subnet.private_subnets[*].id
}

output "public_subnet_cidrs_blocks" {
  description = "The CIDR blocks of the public subnets"
  value       = aws_subnet.public_subnets[*].cidr_block
}

output "private_subnet_cidrs_blocks" {
  description = "The CIDR blocks of the private subnets"
  value       = aws_subnet.private_subnets[*].cidr_block
}

output "public_route_table_id" {
  description = "The ID of the public route table"
  value       = aws_route_table.public_route_table.id
}

output "private_route_table_ids" {
  description = "The IDs of the private route table"
  value       = aws_route_table.private_route_tables[*].id
}

output "internet_gateway_id" {
  description = "The ID of the internet gateway"
  value       = aws_internet_gateway.gateway.id
}

output "nat_gateways_id" {
  description = "The IDs of the NAT gateways"
  value       = aws_nat_gateway.nat_gateways[*].id
}