variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}
variable "default_tags" {
  description = "A map of tags"
  type        = map(string) 
}