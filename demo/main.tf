provider "aws" {

  region = "ap-south-1"
  default_tags {
    tags = {
      ProjectName = "${var.project_name}"
      Environment = "${var.environment_name}"
    }
  }
}


terraform {
  backend "s3" {
    bucket = "fortcapital"
    key    = "fortcapital-tf/state_file"
    region = "ap-south-1"
  }
}



module "ecr" {
  source           = "../aws-modules/ecr"
  project_name     = var.project_name
  environment_name = var.environment_name
}

module "ecs" {
  source                                    = "../aws-modules/ecs"
  project_name                              = var.project_name
  environment_name                          = var.environment_name
  region                                    = var.region
  cloudwatch_ecs_redis_name                 = module.cloudwatch_logs.cloudwatch_ecs_redis_name
  cloudwatch_ecs_cron_ms_name               = module.cloudwatch_logs.cloudwatch_ecs_cron_ms_name
  cloudwatch_ecs_tasks_ms_name              = module.cloudwatch_logs.cloudwatch_ecs_tasks_ms_name
  cloudwatch_ecs_user_ms_name               = module.cloudwatch_logs.cloudwatch_ecs_user_ms_name
  cloudwatch_ecs_license_ms_name            = module.cloudwatch_logs.cloudwatch_ecs_license_ms_name
  cloudwatch_ecs_organisation_ms_name       = module.cloudwatch_logs.cloudwatch_ecs_organization_ms_name
  cloudwatch_ecs_master_ms_name             = module.cloudwatch_logs.cloudwatch_ecs_master_ms_name
  cloudwatch_ecs_frontend_name              = module.cloudwatch_logs.cloudwatch_ecs_frontend_name
  ecs_frontend_discovery_service_arn        = module.service_discovery.frontend_discovery_arn
  ecs_tasks_ms_discovery_service_arn        = module.service_discovery.tasks_ms_discovery_arn
  ecs_organization_ms_discovery_service_arn = module.service_discovery.ecs_organization_ms_discovery_arn
  ecs_cron_ms_discovery_service_arn         = module.service_discovery.cron_ms_discovery_arn
  ecs_users_ms_discovery_service_arn        = module.service_discovery.user_ms_discovery_arn
  ecs_license_ms_discovery_service_arn      = module.service_discovery.license_ms_discovery_arn
  ecs_redis_discovery_service_arn           = module.service_discovery.redis_discovery_arn
  ecs_master_ms_discovery_service_arn       = module.service_discovery.master_ms_discovery_arn
  ecs_sg_id                                 = module.security_groups.ecs_sg_id
  vpc_private_subnet_id                     = module.vpc.private_subnet_id
  cron_ms_tg_arn                            = module.alb.cron_ms_arn
  master_ms_tg_arn                          = module.alb.master_ms_arn
  users_ms_tg_arn                           = module.alb.users_ms_arn
  tasks_ms_tg_arn                           = module.alb.tasks_ms_arn
  frontend_tg_arn                           = module.alb.frontend_arn
  organization_tg_arn                       = module.alb.orgainzation_ms_arn
  license_ms_tg_arn                         = module.alb.license_ms_arn
  ecs_task_execution_role_arn               = module.iam.eks_execution_role_arn
  depends_on                                = [module.alb]

}

module "iam" {
  source           = "../aws-modules/iam"
  project_name     = var.project_name
  environment_name = var.environment_name
}

module "service_discovery" {
  source           = "../aws-modules/service-discovery"
  project_name     = var.project_name
  environment_name = var.environment_name
}

module "cloudwatch_logs" {
  source           = "../aws-modules/cloudwatch-logs"
  project_name     = var.project_name
  environment_name = var.environment_name
}


module "vpc" {
  source           = "../aws-modules/vpc"
  eni_nat          = module.ec2.nat_eni
  project_name     = var.project_name
  environment_name = var.environment_name
}

module "ec2" {
  source           = "../aws-modules/ec2"
  project_name     = var.project_name
  environment_name = var.environment_name
  nat_sg_id        = module.security_groups.nat_sg_id
  postgres_sg_id   = module.security_groups.postgres_sg_id
  bastion_sg_id    = module.security_groups.bastion_sg_id
  public_subnet    = module.vpc.public_subnet_id[*]
  private_subnet   = module.vpc.private_subnet_id[*]
}

module "security_groups" {
  source           = "../aws-modules/security-groups"
  project_name     = var.project_name
  environment_name = var.environment_name
  vpc_id           = module.vpc.vpc_id
}

module "alb" {
  project_name        = var.project_name
  environment_name    = var.environment_name
  source              = "../aws-modules/alb"
  certificate_arn_alb = var.certificate_arn
  alb_sg_id           = module.security_groups.alb_sg_id
  vpc_id              = module.vpc.vpc_id
  public_subnet       = module.vpc.public_subnet_id
}

module "s3" {
  source           = "../aws-modules/s3"
  project_name     = var.project_name
  environment_name = var.environment_name
}








# module "route53" {
#   source           = "../aws-modules/route53"
#   project_name     = var.project_name
#   environment_name = var.environment_name
#   region           = var.region
#   alb_dns_name     = module.alb.alb_dns
#   zone_id          = module.alb.alb_zone_id
#   vpc_id           = module.vpc.vpc_id
# }
