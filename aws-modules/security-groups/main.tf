resource "aws_security_group" "ecs_sg" {
  name   = "${var.environment_name}-${var.project_name}-ecs-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["10.50.0.0/24"]
    description = "Redis"
  }

  ingress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["10.50.0.0/24"]
    description = "License"
  }

  ingress {
    from_port   = 4500
    to_port     = 4500
    protocol    = "tcp"
    cidr_blocks = ["10.50.0.0/24"]
    description = "Backend"
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["10.50.0.0/24"]
    description = "Frontend"
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.50.0.0/24"]
    description = "ECR Secure Connection"
  }


  # Outbound Rules
  egress {
    from_port   = 465
    to_port     = 465
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Email (SMTPS)"
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "ECR Secure Connection"
  }

  egress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.50.0.0/24"]
    description = "EC2 PostgreSQL"
  }

  tags = {
    Name = "${var.environment_name}-${var.project_name}-ecs-sg"
  }
}


## nat sg

resource "aws_security_group" "nat_sg" {
  name        = "${var.environment_name}-${var.project_name}-nat-sg"
  description = "Nat sg"
  vpc_id      = var.vpc_id

  # Inbound Rules
  ingress {
    from_port   = 5601
    to_port     = 5601
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Custom TCP for Port 5601"
  }

  ingress {
    from_port   = 9200
    to_port     = 9200
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Custom TCP for Port 9200"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH Access"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # "-1" means all protocols
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow All Traffic"
  }

  ingress {
    from_port   = 9300
    to_port     = 9300
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Custom TCP for Port 9300"
  }

  # Outbound Rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # "-1" means all protocols
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow All Outbound Traffic"
  }

  tags = {
    Name = "${var.environment_name}-${var.project_name}-nat-sg"
  }
}


## ALB sg

resource "aws_security_group" "alb_sg" {
  name        = "${var.environment_name}-${var.project_name}-alb-sg"
  description = "alb sg"
  vpc_id      = var.vpc_id

  # Inbound Rules
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTPS Application Access"
  }

  egress {
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["10.50.0.0/24"]
    description = "License"
  }


  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "HTTP Application Access"
  }

  # Outbound Rules
  egress {
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["10.50.0.0/24"]
    description = "Redis"
  }

  egress {
    from_port   = 4500
    to_port     = 4500
    protocol    = "tcp"
    cidr_blocks = ["10.50.0.0/24"]
    description = "Backend"
  }

  egress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["10.50.0.0/24"]
    description = "Frontend"
  }

  tags = {
    Name = "${var.environment_name}-${var.project_name}-alb-sg"
  }
}


## Postgres sg

resource "aws_security_group" "postgres_sg" {
  name        = "${var.environment_name}-${var.project_name}-postgres-sg"
  description = "postgres sg"
  vpc_id      = var.vpc_id

  # Inbound Rules
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["10.50.0.0/24"]
    description = "PostgreSQL"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.50.0.0/24"]
    description = "SSH for Bastion"
  }


  # Outbound Rules
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # "-1" means all protocols
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow All Outbound Traffic"
  }

  tags = {
    Name = "${var.environment_name}-${var.project_name}-postgres-sg"
  }
}


## Bastion sg

resource "aws_security_group" "bastion_sg" {
  name        = "${var.environment_name}-${var.project_name}-bastion-sg"
  description = "Security group allowing SSH and all traffic"
  vpc_id      = var.vpc_id

  # Inbound Rules
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "SSH Access"
  }

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # "-1" means all protocols
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow All Inbound Traffic"
  }

  # Outbound Rule (Allow All Traffic)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1" # "-1" means all protocols
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow All Outbound Traffic"
  }

  tags = {
    Name = "${var.environment_name}-${var.project_name}-bastion-sg"
  }
}
