terraform {
    required_providers {
        aws = {
        source  = "hashicorp/aws"
        version = "~> 4.0"
        }
    }
    required_version = ">= 1.0.0"
}

provider "aws" {
    region = "us-west-2"
}

variable "instance_type" {
    description = "Type of instance to create"
    type        = string
    default     = "t2.micro"
}



resource "aws_instance" "example" {
    ami           = "ami-06a974f9b8a97ecf2" # Amazon Linux 3 AMI (HVM), SSD Volume Type
    instance_type = var.instance_type

    tags = {
        Name = "tf-learning-instance"
    }
}