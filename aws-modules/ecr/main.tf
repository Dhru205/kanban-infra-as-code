# ## cron-ms repo

resource "aws_ecr_repository" "cron_ms" {
  name                 = "${var.environment_name}-${var.project_name}-cron-ms"
  image_tag_mutability = "MUTABLE"
  force_delete         = var.ecr_force_delete

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name = "${var.environment_name}-${var.project_name}-cron-ms"
    ECR  = "DELETE"
  }
}

## frontend-ms repo


resource "aws_ecr_repository" "frontend_ms" {
  name                 = "${var.environment_name}-${var.project_name}-frontend-ms"
  image_tag_mutability = "MUTABLE"
  force_delete         = var.ecr_force_delete

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name = "${var.environment_name}-${var.project_name}-frontend-ms"
    ECR  = "DELETE"
  }
}

# ## master-ms repo


resource "aws_ecr_repository" "master_ms" {
  name                 = "${var.environment_name}-${var.project_name}-master-ms"
  image_tag_mutability = "MUTABLE"
  force_delete         = var.ecr_force_delete

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name = "${var.environment_name}-${var.project_name}-master-ms"
    ECR  = "DELETE"
  }
}

# ## organization-ms repo


resource "aws_ecr_repository" "organization_ms" {
  name                 = "${var.environment_name}-${var.project_name}-organizations-ms"
  image_tag_mutability = "MUTABLE"
  force_delete         = var.ecr_force_delete

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name = "${var.environment_name}-${var.project_name}-organizations-ms"
    ECR  = "DELETE"
  }
}

# ## tasks-ms repo


resource "aws_ecr_repository" "tasks_ms" {
  name                 = "${var.environment_name}-${var.project_name}-tasks-ms"
  image_tag_mutability = "MUTABLE"
  force_delete         = var.ecr_force_delete

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name = "${var.environment_name}-${var.project_name}-tasks-ms"
    ECR  = "DELETE"
  }
}

## users-ms repo


resource "aws_ecr_repository" "users_ms" {
  name                 = "${var.environment_name}-${var.project_name}-users-ms"
  image_tag_mutability = "MUTABLE"
  force_delete         = var.ecr_force_delete

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name = "${var.environment_name}-${var.project_name}-users-ms"
    ECR  = "DELETE"
  }
}


## redis repo


resource "aws_ecr_repository" "redis" {
  name                 = "${var.environment_name}-${var.project_name}-redis"
  image_tag_mutability = "MUTABLE"
  force_delete         = var.ecr_force_delete

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name = "${var.environment_name}-${var.project_name}-redis"
    ECR  = "DELETE"
  }
}


# ## license-ms repo


resource "aws_ecr_repository" "license_ms" {
  name                 = "${var.environment_name}-${var.project_name}-license-ms"
  image_tag_mutability = "MUTABLE"
  force_delete         = var.ecr_force_delete

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name = "${var.environment_name}-${var.project_name}-license-ms"
    ECR  = "DELETE"
  }
}
