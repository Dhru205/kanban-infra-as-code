resource "aws_ecs_cluster" "ecs_cluster_9to5" {
  name = "${var.environment_name}-${var.project_name}-ecs-cluster"
  setting {
    name  = "containerInsights"
    value = "disabled"
  }
  tags = {
    Name = "${var.environment_name}-${var.project_name}-ecs-cluster"
  }
}

# Redis TD

resource "aws_ecs_task_definition" "ecs_task_definition_redis" {
  family                   = "${var.environment_name}-${var.project_name}-redis-ms-td"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_ms_cpu
  memory                   = var.ecs_ms_memory
  task_role_arn            = var.ecs_task_execution_role_arn
  execution_role_arn       = var.ecs_task_execution_role_arn
  tags = {
    Name = "${var.environment_name}-${var.project_name}-redis-ms-td"
  }
  container_definitions = <<DEFINITION
  [
    {
      "image": "${var.ecr_redis_url}:latest",
      "name": "${var.environment_name}-${var.project_name}-redis-ms",
      "portMappings": [
        {
          "containerPort": 6379,
          "hostPort": 6379
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${var.cloudwatch_ecs_redis_name}",
            "awslogs-region": "${var.region}",
            "awslogs-stream-prefix": "ecs-fargate"
        }
      }
    }
  ]
DEFINITION

}

# Redis service

resource "aws_ecs_service" "redis_service" {
  name                               = "${var.environment_name}-${var.project_name}-redis-ms-service"
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  cluster                            = aws_ecs_cluster.ecs_cluster_9to5.id
  task_definition                    = aws_ecs_task_definition.ecs_task_definition_redis.arn
  desired_count                      = 1

  service_registries {
    registry_arn = var.ecs_redis_discovery_service_arn
  }

  network_configuration {
    subnets         = [var.vpc_private_subnet_id[0]]
    security_groups = [var.ecs_sg_id]
    # assign_public_ip = false
  }

  tags = {
    AutoStartStop = "${var.environment_name}"
    Environment   = "${var.environment_name}"
    Project       = "${var.project_name}"
  }

}


## License-ms TD

resource "aws_ecs_task_definition" "ecs_task_definition_license_ms" {
  family                   = "${var.environment_name}-${var.project_name}-license-ms-td"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_ms_cpu
  memory                   = var.ecs_ms_memory
  task_role_arn            = var.ecs_task_execution_role_arn
  execution_role_arn       = var.ecs_task_execution_role_arn
  tags = {
    Name = "${var.environment_name}-${var.project_name}-license-ms-td"
  }
  container_definitions = <<DEFINITION
  [
    {
      "image": "${var.ecr_license_ms_url}",
      "name": "${var.environment_name}-${var.project_name}-license-ms",
      "portMappings": [
        {
          "containerPort": 8081,
          "hostPort": 8081
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${var.cloudwatch_ecs_license_ms_name}",
            "awslogs-region": "${var.region}",
            "awslogs-stream-prefix": "ecs-fargate"
        }
      }
    }
  ]
  DEFINITION
}

## License-ms service

resource "aws_ecs_service" "license_ms_service" {
  name                               = "${var.environment_name}-${var.project_name}-license-ms-service"
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  cluster                            = aws_ecs_cluster.ecs_cluster_9to5.id
  task_definition                    = aws_ecs_task_definition.ecs_task_definition_license_ms.arn
  desired_count                      = var.desired_count

  service_registries {
    registry_arn = var.ecs_license_ms_discovery_service_arn
  }

  network_configuration {
    subnets          = [var.vpc_private_subnet_id[0]]
    security_groups  = [var.ecs_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    # elb_name = "9to5-alb"
    target_group_arn = var.license_ms_tg_arn
    container_name   = "${var.environment_name}-${var.project_name}-license-ms"
    container_port   = 8081

  }

  tags = {
    AutoStartStop = "${var.environment_name}"
    Environment   = "${var.environment_name}"
    Project       = "${var.project_name}"
  }
}

## Frontend TD

resource "aws_ecs_task_definition" "ecs_task_definition_frontend" {
  family                   = "${var.environment_name}-${var.project_name}-frontend-ms-td"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_ms_cpu
  memory                   = var.ecs_ms_memory
  task_role_arn            = var.ecs_task_execution_role_arn
  execution_role_arn       = var.ecs_task_execution_role_arn
  tags = {
    Name = "${var.environment_name}-${var.project_name}-frontend-ms-td"
  }
  container_definitions = <<DEFINITION
  [
    {
      "image": "${var.ecr_frontend_url}",
      "name": "${var.environment_name}-${var.project_name}-frontend-ms",
      "portMappings": [
        {
          "containerPort": 3000,
          "hostPort": 3000
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${var.cloudwatch_ecs_frontend_name}",
            "awslogs-region": "${var.region}",
            "awslogs-stream-prefix": "ecs-fargate"
        }
      }
    }
  ]
  DEFINITION
}


# ## Frontend service

resource "aws_ecs_service" "frontend_service" {
  name                               = "${var.environment_name}-${var.project_name}-frontend-ms-service"
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  cluster                            = aws_ecs_cluster.ecs_cluster_9to5.id
  task_definition                    = aws_ecs_task_definition.ecs_task_definition_frontend.arn
  desired_count                      = 1

  service_registries {
    registry_arn = var.ecs_frontend_discovery_service_arn
  }

  network_configuration {
    subnets         = [var.vpc_private_subnet_id[0]]
    security_groups = [var.ecs_sg_id]
  }

  load_balancer {
    # elb_name         = "9to5-alb"
    target_group_arn = var.frontend_tg_arn
    container_name   = "${var.environment_name}-${var.project_name}-frontend-ms"
    container_port   = 3000

  }

  tags = {
    AutoStartStop = "${var.environment_name}"
    Environment   = "${var.environment_name}"
    Project       = "${var.project_name}"
  }

}



# ## master-ms TD

resource "aws_ecs_task_definition" "ecs_task_definition_master_ms" {
  family                   = "${var.environment_name}-${var.project_name}-master-ms-td"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_ms_cpu
  memory                   = var.ecs_ms_memory
  task_role_arn            = var.ecs_task_execution_role_arn
  execution_role_arn       = var.ecs_task_execution_role_arn
  tags = {
    Name = "${var.environment_name}-${var.project_name}-master-ms-td"
  }
  container_definitions = <<DEFINITION
  [
    {
      "image": "${var.ecr_master_ms_url}",
      "name": "${var.environment_name}-${var.project_name}-master-ms",
      "portMappings": [
        {
          "containerPort": 4500,
          "hostPort": 4500
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${var.cloudwatch_ecs_master_ms_name}",
            "awslogs-region": "${var.region}",
            "awslogs-stream-prefix": "ecs-fargate"
        }
      }
    }
  ]
  DEFINITION
}



# ## master-ms service

resource "aws_ecs_service" "master_ms_service" {
  name                               = "${var.environment_name}-${var.project_name}-master-ms-service"
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  cluster                            = aws_ecs_cluster.ecs_cluster_9to5.id
  task_definition                    = aws_ecs_task_definition.ecs_task_definition_master_ms.arn
  desired_count                      = var.desired_count

  service_registries {
    registry_arn = var.ecs_master_ms_discovery_service_arn
  }

  network_configuration {
    subnets          = [var.vpc_private_subnet_id[0]]
    security_groups  = [var.ecs_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    # elb_name = "9to5-alb"
    target_group_arn = var.master_ms_tg_arn
    container_name   = "${var.environment_name}-${var.project_name}-master-ms"
    container_port   = 4500

  }

  tags = {
    AutoStartStop = "${var.environment_name}"
    Environment   = "${var.environment_name}"
    Project       = "${var.project_name}"
  }
}




## tasks-ms TD

resource "aws_ecs_task_definition" "ecs_task_definition_tasks_ms" {
  family                   = "${var.environment_name}-${var.project_name}-tasks-ms-td"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_ms_cpu
  memory                   = var.ecs_ms_memory
  task_role_arn            = var.ecs_task_execution_role_arn
  execution_role_arn       = var.ecs_task_execution_role_arn
  tags = {
    Name = "${var.environment_name}-${var.project_name}-tasks-ms-td"
  }
  container_definitions = <<DEFINITION
  [
    {
      "image": "${var.ecr_tasks_ms_url}",
      "name": "${var.environment_name}-${var.project_name}-tasks-ms",
      "portMappings": [
        {
          "containerPort": 4500,
          "hostPort": 4500
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${var.cloudwatch_ecs_tasks_ms_name}",
            "awslogs-region": "${var.region}",
            "awslogs-stream-prefix": "ecs-fargate"
        }
      }
    }
  ]
  DEFINITION
}


# ## tasks-ms service

resource "aws_ecs_service" "tasks_ms_service" {
  name                               = "${var.environment_name}-${var.project_name}-tasks-ms-service"
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  cluster                            = aws_ecs_cluster.ecs_cluster_9to5.id
  task_definition                    = aws_ecs_task_definition.ecs_task_definition_tasks_ms.arn
  desired_count                      = var.desired_count

  service_registries {
    registry_arn = var.ecs_tasks_ms_discovery_service_arn
  }

  network_configuration {
    subnets          = [var.vpc_private_subnet_id[0]]
    security_groups  = [var.ecs_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    # elb_name = "9to5-alb"
    target_group_arn = var.tasks_ms_tg_arn
    container_name   = "${var.environment_name}-${var.project_name}-tasks-ms"
    container_port   = 4500

  }

  tags = {
    AutoStartStop = "${var.environment_name}"
    Environment   = "${var.environment_name}"
    Project       = "${var.project_name}"
  }
}




## cron-ms TD

resource "aws_ecs_task_definition" "ecs_task_definition_cron_ms" {
  family                   = "${var.environment_name}-${var.project_name}-cron-ms-td"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_ms_cpu
  memory                   = var.ecs_ms_memory
  task_role_arn            = var.ecs_task_execution_role_arn
  execution_role_arn       = var.ecs_task_execution_role_arn
  tags = {
    Name = "${var.environment_name}-${var.project_name}-cron-ms-td"
  }
  container_definitions = <<DEFINITION
  [
    {
      "image": "${var.ecr_cron_ms_url}",
      "name": "${var.environment_name}-${var.project_name}-cron-ms",
      "portMappings": [
        {
          "containerPort": 4500,
          "hostPort": 4500
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${var.cloudwatch_ecs_cron_ms_name}",
            "awslogs-region": "${var.region}",
            "awslogs-stream-prefix": "ecs-fargate"
        }
      }
    }
  ]
  DEFINITION
}



# ## cron-ms service

resource "aws_ecs_service" "cron_ms_service" {
  name                               = "${var.environment_name}-${var.project_name}-cron-ms-service"
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  cluster                            = aws_ecs_cluster.ecs_cluster_9to5.id
  task_definition                    = aws_ecs_task_definition.ecs_task_definition_cron_ms.arn
  desired_count                      = var.desired_count

  service_registries {
    registry_arn = var.ecs_cron_ms_discovery_service_arn
  }

  network_configuration {
    subnets          = [var.vpc_private_subnet_id[0]]
    security_groups  = [var.ecs_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    # elb_name = "9to5-alb"
    target_group_arn = var.cron_ms_tg_arn
    container_name   = "${var.environment_name}-${var.project_name}-cron-ms"
    container_port   = 4500

  }

  tags = {
    AutoStartStop = "${var.environment_name}"
    Environment   = "${var.environment_name}"
    Project       = "${var.project_name}"
  }
}





## user-ms TD

resource "aws_ecs_task_definition" "ecs_users_definition_user_ms" {
  family                   = "${var.environment_name}-${var.project_name}-users-ms-td"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_ms_cpu
  memory                   = var.ecs_ms_memory
  task_role_arn            = var.ecs_task_execution_role_arn
  execution_role_arn       = var.ecs_task_execution_role_arn
  tags = {
    Name = "${var.environment_name}-${var.project_name}-users-ms-td"
  }
  container_definitions = <<DEFINITION
  [
    {
      "image": "${var.ecr_user_ms_url}",
      "name": "${var.environment_name}-${var.project_name}-users-ms",
      "portMappings": [
        {
          "containerPort": 4500,
          "hostPort": 4500
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${var.cloudwatch_ecs_user_ms_name}",
            "awslogs-region": "${var.region}",
            "awslogs-stream-prefix": "ecs-fargate"
        }
      }
    }
  ]
  DEFINITION
}

# ## Users-ms service

resource "aws_ecs_service" "users-ms_service" {
  name                               = "${var.environment_name}-${var.project_name}-users-ms-service"
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  cluster                            = aws_ecs_cluster.ecs_cluster_9to5.id
  task_definition                    = aws_ecs_task_definition.ecs_users_definition_user_ms.arn
  desired_count                      = var.desired_count

  service_registries {
    registry_arn = var.ecs_users_ms_discovery_service_arn
  }

  network_configuration {
    subnets          = [var.vpc_private_subnet_id[0]]
    security_groups  = [var.ecs_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    # elb_name = "9to5-alb"
    target_group_arn = var.users_ms_tg_arn
    container_name   = "${var.environment_name}-${var.project_name}-users-ms"
    container_port   = 4500

  }

  tags = {
    AutoStartStop = "${var.environment_name}"
    Environment   = "${var.environment_name}"
    Project       = "${var.project_name}"
  }
}




# ## organization-ms TD

resource "aws_ecs_task_definition" "ecs_user_definition_organization_ms" {
  family                   = "${var.environment_name}-${var.project_name}-organizations-ms-td"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.ecs_ms_cpu
  memory                   = var.ecs_ms_memory
  task_role_arn            = var.ecs_task_execution_role_arn
  execution_role_arn       = var.ecs_task_execution_role_arn
  tags = {
    Name = "${var.environment_name}-${var.project_name}-organizations-ms-td"
  }
  container_definitions = <<DEFINITION
  [
    {
      "image": "${var.ecr_organisation_ms_url}",
      "name": "${var.environment_name}-${var.project_name}-organizations-ms",
      "portMappings": [
        {
          "containerPort": 4500,
          "hostPort": 4500
        }
      ],
      "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
            "awslogs-group": "${var.cloudwatch_ecs_organisation_ms_name}",
            "awslogs-region": "${var.region}",
            "awslogs-stream-prefix": "ecs-fargate"
        }
      }
    }
  ]
  DEFINITION
}

# ## Organization-ms service

resource "aws_ecs_service" "orgainzation-ms_service" {
  name                               = "${var.environment_name}-${var.project_name}-organizations-ms-service"
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"
  deployment_minimum_healthy_percent = 100
  deployment_maximum_percent         = 200
  cluster                            = aws_ecs_cluster.ecs_cluster_9to5.id
  task_definition                    = aws_ecs_task_definition.ecs_user_definition_organization_ms.arn
  desired_count                      = var.desired_count

  service_registries {
    registry_arn = var.ecs_organization_ms_discovery_service_arn
  }

  network_configuration {
    subnets          = [var.vpc_private_subnet_id[0]]
    security_groups  = [var.ecs_sg_id]
    assign_public_ip = false
  }

  load_balancer {
    # elb_name = "9to5-alb"
    target_group_arn = var.organization_tg_arn
    container_name   = "${var.environment_name}-${var.project_name}-organizations-ms"
    container_port   = 4500

  }
  tags = {
    AutoStartStop = "${var.environment_name}"
    Environment   = "${var.environment_name}"
    Project       = "${var.project_name}"
  }
}





# # ## ALB

# data "aws_lb" "existing_alb" {
#   name = "9to5-alb"
# }

# data "aws_lb_listener" "existing_listener" {
#   load_balancer_arn = data.aws_lb.existing_alb.arn
#   port              = 443 # Or 443 for HTTPS
# }

# ## user-ms

# resource "aws_lb_target_group" "user_ms_tg" {
#   name        = "${var.environment_name}-${var.project_name}-users-ms-srv-tg"
#   port        = 80
#   protocol    = "HTTP"
#   target_type = "ip"
#   vpc_id      = "vpc-08d6ac5df2b8cdc97"
#   health_check {
#     path = "/api/users/ms/health"
#   }
# }

# resource "aws_lb_listener_rule" "user_ms_rule" {
#   listener_arn = data.aws_lb_listener.existing_listener.arn
#   priority     = 43

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.user_ms_tg.arn
#   }

#   condition {
#     path_pattern {
#       values = ["/api/users", "/api/users/*"]
#     }
#   }

#   condition {
#     host_header {
#       values = ["example.9to5.world"]
#     }
#   }
#   tags = {
#     Name = "example-user-ms"
#   }
# }



# ## master-ms




# resource "aws_lb_target_group" "master_ms_tg" {
#   name        = "${var.environment_name}-${var.project_name}-master-ms-srv-tg"
#   port        = 80
#   protocol    = "HTTP"
#   target_type = "ip"
#   vpc_id      = "vpc-08d6ac5df2b8cdc97"
#   health_check {
#     path = "/api/master/health"
#   }
# }


# resource "aws_lb_listener_rule" "master_ms_rule" {
#   listener_arn = data.aws_lb_listener.existing_listener.arn
#   priority     = 44

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.master_ms_tg.arn
#   }

#   condition {
#     path_pattern {
#       values = ["/api/master", "/api/master/*"]
#     }
#   }

#   condition {
#     host_header {
#       values = ["example.9to5.world"]
#     }
#   }
#   tags = {
#     Name = "example-master-ms"
#   }
# }


# ## organization-ms



# resource "aws_lb_target_group" "organization_ms_tg" {
#   name        = "${var.environment_name}-${var.project_name}-organizations-sv-tg"
#   port        = 80
#   protocol    = "HTTP"
#   target_type = "ip"
#   vpc_id      = "vpc-08d6ac5df2b8cdc97"
#   health_check {
#     path = "/api/organizations/health"
#   }
# }


# resource "aws_lb_listener_rule" "organization_ms_rule" {
#   listener_arn = data.aws_lb_listener.existing_listener.arn
#   priority     = 45

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.organization_ms_tg.arn
#   }

#   condition {
#     path_pattern {
#       values = ["/api/organizations/", "/api/organizations/*"]
#     }
#   }

#   condition {
#     host_header {
#       values = ["example.9to5.world"]
#     }
#   }
#   tags = {
#     Name = "example-organizations-ms"
#   }
# }

# ## tasks-ms




# resource "aws_lb_target_group" "tasks_ms_tg" {
#   name        = "${var.environment_name}-${var.project_name}-tasks-ms-srv-tg"
#   port        = 80
#   protocol    = "HTTP"
#   target_type = "ip"
#   vpc_id      = "vpc-08d6ac5df2b8cdc97"
#   health_check {
#     path = "/api/tasks/health"
#   }
# }


# resource "aws_lb_listener_rule" "tasks_ms_rule" {
#   listener_arn = data.aws_lb_listener.existing_listener.arn
#   priority     = 46

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.tasks_ms_tg.arn
#   }

#   condition {
#     path_pattern {
#       values = ["/api/tasks/", "/api/tasks/*"]
#     }
#   }

#   condition {
#     host_header {
#       values = ["example.9to5.world"]
#     }
#   }
#   tags = {
#     Name = "example-tasks-ms"
#   }
# }

# ## socket.io

# resource "aws_lb_listener_rule" "socket_ms_rule" {
#   listener_arn = data.aws_lb_listener.existing_listener.arn
#   priority     = 47

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.tasks_ms_tg.arn
#   }

#   condition {
#     path_pattern {
#       values = ["/socket.io/", "/socket.io/*"]
#     }
#   }

#   condition {
#     host_header {
#       values = ["example.9to5.world"]
#     }
#   }
#   tags = {
#     Name = "example-websocket"
#   }
# }



# ## cron-ms

# resource "aws_lb_target_group" "cron_ms_tg" {
#   name        = "${var.environment_name}-${var.project_name}-cron-ms-services-tg"
#   port        = 80
#   protocol    = "HTTP"
#   target_type = "ip"
#   vpc_id      = "vpc-08d6ac5df2b8cdc97"
#   health_check {
#     path = "/api/crons/health"
#   }
# }


# resource "aws_lb_listener_rule" "cron_ms_rule" {
#   listener_arn = data.aws_lb_listener.existing_listener.arn
#   priority     = 48

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.cron_ms_tg.arn
#   }

#   condition {
#     path_pattern {
#       values = ["/api/crons/", "/api/crons/*"]
#     }
#   }

#   condition {
#     host_header {
#       values = ["example.9to5.world"]
#     }
#   }
#   tags = {
#     Name = "example-cron-ms"
#   }
# }




# ## frontend-ms


# resource "aws_lb_target_group" "frontend_ms_tg" {
#   name        = "${var.environment_name}-${var.project_name}-frontend-ms-srv-tg"
#   port        = 80
#   protocol    = "HTTP"
#   target_type = "ip"
#   vpc_id      = "vpc-08d6ac5df2b8cdc97"
#   health_check {
#     path = "/"
#   }
# }


# resource "aws_lb_listener_rule" "frontend_ms_rule" {
#   listener_arn = data.aws_lb_listener.existing_listener.arn
#   priority     = 49

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.frontend_ms_tg.arn
#   }


#   condition {
#     host_header {
#       values = ["example.9to5.world"]
#     }
#   }
#   tags = {
#     Name = "example-frontend"
#   }
# }













