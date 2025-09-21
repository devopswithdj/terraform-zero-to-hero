# Create a VPC with Public and Private Subnets, Internet Gateway, NAT Gateway, Route Tables, and Associations
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name = "tf-learning-vpc"
  }
}

resource "aws_subnet" "public_subnet" {
  count      = length(var.public_subnet_cidrs)
  vpc_id     = aws_vpc.my_vpc.id
  cidr_block = var.public_subnet_cidrs[count.index]
  #   map_public_ip_on_launch = true
  availability_zone = element(var.azs, count.index)
  tags = {
    Name = "tf-learning-public-snet-${count.index + 1}"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.my_vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = element(var.azs, count.index)
  tags = {
    Name = "tf-learning-private-snet-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "tf-learning-igw"
  }
}

# resource "aws_eip" "nat_eip" {
#   domain = "vpc"
#   tags = {
#     Name = "tf-learning-nat-eip"
#   } 
# }

# resource "aws_nat_gateway" "nat_gw" {
#   allocation_id = aws_eip.nat_eip.id
#   subnet_id     = aws_subnet.public_subnet[0].id
#   tags = {
#     Name = "tf-learning-nat-gw"
#   }
#   depends_on = [aws_internet_gateway.igw]
# }

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.my_vpc.id
  tags = {
    Name = "tf-learning-public-rt"
  }
}

resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
  depends_on             = [aws_internet_gateway.igw]
}

resource "aws_route_table_association" "public_rt_assoc" {
  count          = length(aws_subnet.public_subnet)
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_rt.id
}

# resource "aws_route_table" "private_rt" {
#   vpc_id = aws_vpc.my_vpc.id
#   tags = {
#     Name = "tf-learning-private-rt"
#   }
# }

# resource "aws_route" "private_route" {
#   route_table_id         = aws_route_table.private_rt.id
#   destination_cidr_block = "0.0.0.0/0"
#   nat_gateway_id         = aws_nat_gateway.nat_gw.id
#   depends_on             = [aws_nat_gateway.nat_gw]
# }
# resource "aws_route_table_association" "private_rt_assoc" {
#   count          = length(aws_subnet.private_subnet)
#   subnet_id      = aws_subnet.private_subnet[count.index].id
#   route_table_id = aws_route_table.private_rt.id
# }

# NAT Gateway and related resources are commented out to avoid incurring costs during learning.
# Uncomment them when you want to create a complete setup with NAT Gateway.

resource "aws_security_group" "ec2_sg" {
  vpc_id      = aws_vpc.my_vpc.id
  name        = "tf-learning-ec2-sg"
  description = "Allow SSH and HTTP inbound traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "tf-learning-ec2-sg"
  }
}

# Lets create a EC2 instance in the public subnet to verify connectivity
resource "aws_instance" "web_server" {
  ami                         = "ami-06a974f9b8a97ecf2" # Amazon Linux 2 AMI (HVM), SSD Volume Type - us-west-2
  instance_type               = "t2.micro"
  subnet_id                   = aws_subnet.public_subnet[0].id
  vpc_security_group_ids      = [aws_security_group.ec2_sg.id]
  associate_public_ip_address = true
  key_name                    = "terraform-learning" # Replace with your key pair name

  tags = {
    Name = "tf-learning-web-server"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      "echo '<h1>Welcome to Terraform Learning</h1>' | sudo tee /var/www/html/index.html"
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file("D:/Dhanu/devopswithdj/terraform-zero-to-hero/aws_keys/terraform-learning.pem") # Replace with the path to your private key
      host        = self.public_ip
    }
  }
}