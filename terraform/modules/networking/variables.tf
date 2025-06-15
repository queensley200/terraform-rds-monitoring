# variable "public_subnets" {
#   description = "CIDR blocks for public subnets"
#   type        = list(string)
# }

variable "public_subnets" {
  description = "CIDR blocks for public subnets"
  type        = list(string)
}

variable "private_subnets" {
  description = "CIDR blocks for private subnets"
  type        = list(string)
} 

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}
variable "environment" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
}
