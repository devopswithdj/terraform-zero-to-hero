module "vpc" {
  source = "../Modules/Vpc"
  vpc_cidr_block = "10.0.0.0/16"
  default_tags = {
        Environment = "learning"
        Project     = "terraform-learning"
  }
}