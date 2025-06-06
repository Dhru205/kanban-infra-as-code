variable "project_name" {}

variable "environment_name" {}

variable "region" {}


variable "ecs_task_execution_role_arn" {}

variable "iam_role_arn" {
  default = "arn:aws:iam::211125344835:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
}


## Redis
variable "ecs_ms_cpu" {
  description = "CPU size for liquibase"
  default     = "256"
}

variable "ecs_ms_memory" {
  description = "Memory size for liquibase"
  default     = "512"
}

variable "ecr_redis_url" {
  default = "700053616195.dkr.ecr.ap-south-1.amazonaws.com/fortcapital-9to5-redis"
}

variable "ecs_redis_discovery_service_arn" {}

variable "cloudwatch_ecs_redis_name" {}

## License

variable "ecr_license_ms_url" {
  default = "700053616195.dkr.ecr.ap-south-1.amazonaws.com/fortcapital-9to5-license-ms:20afaaec"
}

variable "cloudwatch_ecs_license_ms_name" {}

variable "ecs_license_ms_discovery_service_arn" {

}

## Frontend

variable "ecr_frontend_url" {
  default = "700053616195.dkr.ecr.ap-south-1.amazonaws.com/fortcapital-9to5-frontend-ms:ef12398f"
}

variable "cloudwatch_ecs_frontend_name" {}

variable "ecs_frontend_discovery_service_arn" {}

## master-ms

variable "ecr_master_ms_url" {
  default = "700053616195.dkr.ecr.ap-south-1.amazonaws.com/fortcapital-9to5-master-ms:fa2d2898"
}

variable "cloudwatch_ecs_master_ms_name" {}

variable "ecs_master_ms_discovery_service_arn" {}

## task-ms

variable "ecr_tasks_ms_url" {
  default = "700053616195.dkr.ecr.ap-south-1.amazonaws.com/fortcapital-9to5-tasks-ms:71963b69"
}

variable "cloudwatch_ecs_tasks_ms_name" {}

variable "ecs_tasks_ms_discovery_service_arn" {

}

## cron-ms

variable "ecr_cron_ms_url" {
  default = "700053616195.dkr.ecr.ap-south-1.amazonaws.com/fortcapital-9to5-cron-ms:90204d19"
}

variable "cloudwatch_ecs_cron_ms_name" {}

variable "ecs_cron_ms_discovery_service_arn" {

}

## user-ms

variable "ecr_user_ms_url" {
  default = "700053616195.dkr.ecr.ap-south-1.amazonaws.com/fortcapital-9to5-users-ms:bab6fa49"
}

variable "cloudwatch_ecs_user_ms_name" {}

variable "ecs_users_ms_discovery_service_arn" {

}
## organisation-ms

variable "ecr_organisation_ms_url" {
  default = "700053616195.dkr.ecr.ap-south-1.amazonaws.com/fortcapital-9to5-organizations-ms:c473f03a"
}

variable "cloudwatch_ecs_organisation_ms_name" {

}

variable "ecs_organization_ms_discovery_service_arn" {}



variable "ecs_sg_id" {}

variable "vpc_private_subnet_id" {}


## tg

variable "organization_tg_arn" {}

variable "users_ms_tg_arn" {}

variable "cron_ms_tg_arn" {}

variable "frontend_tg_arn" {}

variable "tasks_ms_tg_arn" {}

variable "master_ms_tg_arn" {}

variable "license_ms_tg_arn" {}


variable "desired_count" {
  default = "1"
}
