variable "environment_name" {}

variable "project_name" {}

variable "retention_days" {
  description = "retention days for logs"
  default     = "1"
}
