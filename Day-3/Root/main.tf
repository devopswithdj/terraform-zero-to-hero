module "vpc" {
  source = "../Modules/Vpc"
  vpc_cidr_block = "10.0.0.0/16"
  default_tags = var.default_tags
}
module "igw" {
  source = "../Modules/Igw"
  vpc_id = module.vpc.vpc_id
  default_tags = var.default_tags
  depends_on = [ module.vpc ]
}