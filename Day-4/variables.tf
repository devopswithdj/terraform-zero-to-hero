variable "access_key" {
  description = "AWS Access Key"
  type = string
}
variable "secret_key" {
  description = "AWS Secret Key"
  type = string 
}
variable "public_subnet_cidrs" {
 type        = list(string)
 description = "Public Subnet CIDR values"
 default     = ["10.0.0.0/20", "10.0.32.0/20"]
}
 
variable "private_subnet_cidrs" {
 type        = list(string)
 description = "Private Subnet CIDR values"
 default     = ["10.0.16.0/20", "10.0.48.0/20"]
}

variable "azs" {
  description = "List of Availability Zones"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b"]
}
