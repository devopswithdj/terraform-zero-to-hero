resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr_block
  instance_tenancy = "default"
  tags = merge(var.default_tags,{
    Name = "${var.default_tags["Project"]}-vpc"
  })
}