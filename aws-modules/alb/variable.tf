variable "project_name" {}

variable "environment_name" {}

variable "alb_type" {
  default = "application"
}

variable "alb_sg_id" {}

variable "public_subnet" {}

variable "certificate_arn_alb" {}

variable "vpc_id" {}
