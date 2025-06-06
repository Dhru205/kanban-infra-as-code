#ECS

resource "aws_cloudwatch_log_group" "cloudwatch_ecs_redis_name" {
  name              = "/aws/ecs/${var.environment_name}-${var.project_name}-ecs"
  retention_in_days = var.retention_days

  tags = {
    Name = "/aws/ecs/${var.environment_name}-${var.project_name}-ecs"
  }
}

resource "aws_cloudwatch_log_group" "cloudwatch_ecs_frontend_name" {
  name              = "/aws/ecs/${var.environment_name}-${var.project_name}-ecs-frontend"
  retention_in_days = var.retention_days

  tags = {
    Name = "/aws/ecs/${var.environment_name}-${var.project_name}-ecs-frontend"
  }
}

resource "aws_cloudwatch_log_group" "cloudwatch_ecs_license_ms_name" {
  name              = "/aws/ecs/${var.environment_name}-${var.project_name}-ecs-license-ms"
  retention_in_days = var.retention_days

  tags = {
    Name = "/aws/ecs/${var.environment_name}-${var.project_name}-ecs-license-ms"
  }
}


resource "aws_cloudwatch_log_group" "cloudwatch_ecs_master_ms_name" {
  name              = "/aws/ecs/${var.environment_name}-${var.project_name}-ecs-master-ms"
  retention_in_days = var.retention_days

  tags = {
    Name = "/aws/ecs/${var.environment_name}-${var.project_name}-ecs-master-ms"
  }
}

resource "aws_cloudwatch_log_group" "cloudwatch_ecs_tasks_ms_name" {
  name              = "/aws/ecs/${var.environment_name}-${var.project_name}-ecs-tasks-ms"
  retention_in_days = var.retention_days

  tags = {
    Name = "/aws/ecs/${var.environment_name}-${var.project_name}-ecs-tasks-ms"
  }
}

resource "aws_cloudwatch_log_group" "cloudwatch_ecs_cron_ms_name" {
  name              = "/aws/ecs/${var.environment_name}-${var.project_name}-ecs-cron-ms"
  retention_in_days = var.retention_days

  tags = {
    Name = "/aws/ecs/${var.environment_name}-${var.project_name}-ecs-cron-ms"
  }
}

resource "aws_cloudwatch_log_group" "cloudwatch_ecs_user_ms_name" {
  name              = "/aws/ecs/${var.environment_name}-${var.project_name}-ecs-user-ms"
  retention_in_days = var.retention_days

  tags = {
    Name = "/aws/ecs/${var.environment_name}-${var.project_name}-ecs-user-ms"
  }
}


resource "aws_cloudwatch_log_group" "cloudwatch_ecs_organization_ms_name" {
  name              = "/aws/ecs/${var.environment_name}-${var.project_name}-ecs-orgainzation-ms"
  retention_in_days = var.retention_days

  tags = {
    Name = "/aws/ecs/${var.environment_name}-${var.project_name}-ecs-organization-ms"
  }
}
