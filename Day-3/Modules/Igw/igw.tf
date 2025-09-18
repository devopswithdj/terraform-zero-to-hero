data "aws_vpc" "vpc" {
  id = var.vpc_id
}

resource "aws_internet_gateway" "igw" {
  vpc_id = data.aws_vpc.vpc.id

  tags = merge(var.default_tags,{
    Name = "${var.default_tags["Project"]}-igw"
  })
}