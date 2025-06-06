variable "project_name" {

}

variable "environment_name" {

}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  default     = "10.50.0.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR blocks for private subnets"
  default     = ["10.50.0.0/27", "10.50.0.32/27", "10.50.0.64/27"]  
}

variable "public_subnet_cidr" {
  description = "CIDR blocks for public subnets"
  default     = ["10.50.0.96/27", "10.50.0.128/27", "10.50.0.160/27"]
}


variable "availability_zones" {
  description = "aws az for infra environment"
  default     = ["ap-south-1a", "ap-south-1b"]
}

# variable "ecs_availability_Zones" {
#   description = "aws az for infra environment"
#   default     = ["ap-south-1a"]
# }

variable "eni_nat" {}
