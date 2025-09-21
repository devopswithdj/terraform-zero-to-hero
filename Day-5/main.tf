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
    type        = map(string)
    default     = {
        "dev"= "t2.micro"
        "stage" = "t2.medium"
        "prod" = "t2.large"
    }
}



resource "aws_instance" "example" {
    ami           = "ami-06a974f9b8a97ecf2" # Amazon Linux 3 AMI (HVM), SSD Volume Type
    instance_type = lookup(var.instance_type, terraform.workspace, "t3.micro")

    tags = {
        Name = "tf-learning-instance"
    }
}