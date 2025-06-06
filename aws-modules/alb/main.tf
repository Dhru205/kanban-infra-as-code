resource "aws_lb" "prod-alb" {
  name               = "${var.environment_name}-alb"
  internal           = false
  load_balancer_type = var.alb_type
  security_groups    = [var.alb_sg_id]
  subnets            = [var.public_subnet[0], var.public_subnet[1]]

  enable_deletion_protection = true

  #   access_logs {
  #     bucket  = aws_s3_bucket.lb_logs.id
  #     prefix  = "test-lb"
  #     enabled = true
  #   }

  tags = {
    environment_name = var.environment_name
  }

}


resource "aws_lb_listener" "prod-listener" {
  load_balancer_arn = aws_lb.prod-alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn_alb
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "Fixed response content"
      status_code  = "503"
    }
  }
}

## user-ms

resource "aws_lb_target_group" "users_ms_tg" {
  name        = "${var.environment_name}-${var.project_name}-users-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  health_check {
    path = "/api/users/ms/health"
  }
}

resource "aws_lb_listener_rule" "user_ms_rule" {
  listener_arn = aws_lb_listener.prod-listener.arn
  priority     = 1

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.users_ms_tg.arn
  }

  condition {
    path_pattern {
      values = ["/api/users", "/api/users/*"]
    }
  }

  condition {
    host_header {
      values = ["9to5.${var.environment_name}.in"]
    }
  }
  tags = {
    Name = "${var.environment_name}-user-ms"
  }
}

## master-ms

resource "aws_lb_target_group" "master_ms_tg" {
  name        = "${var.environment_name}-${var.project_name}-master-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  health_check {
    path = "/api/master/health"
  }
}


resource "aws_lb_listener_rule" "master_ms_rule" {
  listener_arn = aws_lb_listener.prod-listener.arn
  priority     = 2

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.master_ms_tg.arn
  }

  condition {
    path_pattern {
      values = ["/api/master", "/api/master/*"]
    }
  }

  condition {
    host_header {
      values = ["9to5.${var.environment_name}.in"]
    }
  }
  tags = {
    Name = "${var.environment_name}-master-ms"
  }
}


## organization-ms

resource "aws_lb_target_group" "organization_ms_tg" {
  name        = "${var.environment_name}-${var.project_name}-org-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  health_check {
    path = "/api/organizations/health"
  }
}


resource "aws_lb_listener_rule" "organization_ms_rule" {
  listener_arn = aws_lb_listener.prod-listener.arn
  priority     = 3

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.organization_ms_tg.arn
  }

  condition {
    path_pattern {
      values = ["/api/organizations", "/api/organizations/*"]
    }
  }

  condition {
    host_header {
      values = ["9to5.${var.environment_name}.in"]
    }
  }
  tags = {
    Name = "${var.environment_name}-organizations-ms"
  }
}


## tasks-ms

resource "aws_lb_target_group" "tasks_ms_tg" {
  name        = "${var.environment_name}-${var.project_name}-tasks-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  health_check {
    path = "/api/tasks/health"
  }
}


resource "aws_lb_listener_rule" "tasks_ms_rule" {
  listener_arn = aws_lb_listener.prod-listener.arn
  priority     = 4

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tasks_ms_tg.arn
  }

  condition {
    path_pattern {
      values = ["/api/tasks", "/api/tasks/*"]
    }
  }

  condition {
    host_header {
      values = ["9to5.${var.environment_name}.in"]
    }
  }
  tags = {
    Name = "${var.environment_name}-tasks-ms"
  }
}


## socket.io

resource "aws_lb_listener_rule" "socket_ms_rule" {
  listener_arn = aws_lb_listener.prod-listener.arn
  priority     = 5

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tasks_ms_tg.arn
  }

  condition {
    path_pattern {
      values = ["/socket.io", "/socket.io/*"]
    }
  }

  condition {
    host_header {
      values = ["9to5.${var.environment_name}.in"]
    }
  }
  tags = {
    Name = "${var.environment_name}-websocket"
  }
}

## cron-ms

resource "aws_lb_target_group" "cron_ms_tg" {
  name        = "${var.environment_name}-${var.project_name}-crons-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  health_check {
    path = "/api/crons/health"
  }
}


resource "aws_lb_listener_rule" "cron_ms_rule" {
  listener_arn = aws_lb_listener.prod-listener.arn
  priority     = 6

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.cron_ms_tg.arn
  }

  condition {
    path_pattern {
      values = ["/api/crons", "/api/crons/*"]
    }
  }

  condition {
    host_header {
      values = ["9to5.${var.environment_name}.in"]
    }
  }
  tags = {
    Name = "${var.environment_name}-cron-ms"
  }
}


## License-ms

resource "aws_lb_target_group" "license_ms_tg" {
  name        = "${var.environment_name}-${var.project_name}-license-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  health_check {
    path                = "/license/health"
    healthy_threshold   = 5
    interval            = 300
    unhealthy_threshold = 2
  }

}


resource "aws_lb_listener_rule" "license_ms_rule" {
  listener_arn = aws_lb_listener.prod-listener.arn
  priority     = 7

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.license_ms_tg.arn
  }

  condition {
    path_pattern {
      values = ["/license", "/license/*"]
    }
  }

  condition {
    host_header {
      values = ["9to5.${var.environment_name}.in"]
    }
  }
  tags = {
    Name = "${var.environment_name}-license-ms"
  }
}


## frontend-ms


resource "aws_lb_target_group" "frontend_ms_tg" {
  name        = "${var.environment_name}-${var.project_name}-frontend-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id
  health_check {
    path = "/"
  }
}


resource "aws_lb_listener_rule" "frontend_ms_rule" {
  listener_arn = aws_lb_listener.prod-listener.arn
  priority     = 8

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.frontend_ms_tg.arn
  }


  condition {
    host_header {
      values = ["9to5.${var.environment_name}.in"]
    }
  }
  tags = {
    Name = "${var.environment_name}-frontend"
  }
}
