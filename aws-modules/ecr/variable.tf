variable "project_name" {}

variable "environment_name" {}


variable "ecr_force_delete" {
  description = "ecr repo force delete"
  default     = "true"
}
