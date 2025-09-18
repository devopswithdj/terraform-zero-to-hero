variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}
variable "default_tags" {
  description = "A map of tags"
  type        = map(string) 
}
