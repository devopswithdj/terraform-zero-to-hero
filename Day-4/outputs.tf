output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.my_vpc.id
}
output "vpc_name" {
  description = "The Name of the VPC"
  value       = aws_vpc.my_vpc.tags["Name"]
}
output "public_subnet_ids" {
  description = "The IDs of the public subnets"
  value       = aws_subnet.public_subnet[*].id
}
output "private_subnet_ids" {
  description = "The IDs of the private subnets"
  value       = aws_subnet.private_subnet[*].id 
}
output "igw_id" {
  description = "The ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}
output "public_route_table_id" {
  description = "The ID of the Public Route Table"
  value       = aws_route_table.public_rt.id
}
output "eip_ip" {
  description = "The Elastic IP address for the NAT Gateway"
  value       = aws_eip.nat_eip.public_ip
}
output "nat_gateway_id" {
  description = "The ID of the NAT Gateway"
  value       = aws_nat_gateway.nat_gw.id
}
output "private_route_table_id" {
  description = "The ID of the Private Route Table"
  value       = aws_route_table.private_rt.id
}