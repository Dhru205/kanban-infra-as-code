# resource "aws_service_discovery_private_dns_namespace" "service_ms" {
#   name        = "${var.environment_name}-${var.project_name}-ecs-cluster-ns"
#   description = "demo ecs cluster ns"
#   vpc         = var.vpc_id
# }

## Redis SD
resource "aws_service_discovery_service" "redis_arn" {
  name = "redis-ms"

  dns_config {
    namespace_id = var.namespace_id

    dns_records {
      ttl  = 300
      type = "A"
    }

    routing_policy = "WEIGHTED"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}


## Frontend SD
resource "aws_service_discovery_service" "frontend_arn" {
  name = "frontend-ms"

  dns_config {
    namespace_id = var.namespace_id

    dns_records {
      ttl  = 300
      type = "A"
    }

    routing_policy = "WEIGHTED"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

## Users-ms SD
resource "aws_service_discovery_service" "users_ms_arn" {
  name = "users-ms"

  dns_config {
    namespace_id = var.namespace_id

    dns_records {
      ttl  = 300
      type = "A"
    }

    routing_policy = "WEIGHTED"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

## cron-ms SD
resource "aws_service_discovery_service" "cron_ms_arn" {
  name = "cron-ms"

  dns_config {
    namespace_id = var.namespace_id

    dns_records {
      ttl  = 300
      type = "A"
    }

    routing_policy = "WEIGHTED"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}


## tasks-ms SD
resource "aws_service_discovery_service" "tasks_ms_arn" {
  name = "tasks-ms"

  dns_config {
    namespace_id = var.namespace_id

    dns_records {
      ttl  = 300
      type = "A"
    }

    routing_policy = "WEIGHTED"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

## master-ms SD
resource "aws_service_discovery_service" "master_ms_arn" {
  name = "master-ms"

  dns_config {
    namespace_id = var.namespace_id

    dns_records {
      ttl  = 300
      type = "A"
    }

    routing_policy = "WEIGHTED"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

## organization-ms SD
resource "aws_service_discovery_service" "organization_ms_arn" {
  name = "organizations-ms"

  dns_config {
    namespace_id = var.namespace_id

    dns_records {
      ttl  = 300
      type = "A"
    }

    routing_policy = "WEIGHTED"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

## License-ms SD
resource "aws_service_discovery_service" "license_ms_arn" {
  name = "license-ms"

  dns_config {
    namespace_id = var.namespace_id

    dns_records {
      ttl  = 300
      type = "A"
    }

    routing_policy = "WEIGHTED"
  }

  health_check_custom_config {
    failure_threshold = 1
  }
}

