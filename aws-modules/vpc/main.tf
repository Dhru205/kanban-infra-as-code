resource "aws_vpc" "prod_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.environment_name}-${var.project_name}-vpc"
    Project     = "${var.project_name}"
    Environment = "${var.environment_name}"
    Flowlog     = "No"

  }
}


# INTERNET GATEWAY

resource "aws_internet_gateway" "prod_igw" {
  vpc_id = aws_vpc.prod_vpc.id

  tags = {
    Name = "${var.environment_name}${var.project_name}-internet-gateway"
  }
}

##private subnet

resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.prod_vpc.id
  count                   = length(var.private_subnet_cidr)
  cidr_block              = element(var.private_subnet_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = "false"

  tags = {
    Name = "${var.environment_name}-${var.project_name}-private-subnet"
  }
}

# # ##ecs private subnet

# resource "aws_subnet" "ecs_private_subnet" {
#   vpc_id                  = aws_vpc.prod_vpc.id
#   count                   = length(var.private_subnet_cidr)
#   cidr_block              = element(var.private_subnet_cidr, count.index)
#   availability_zone       = element(var.ecs_availability_Zones, count.index)
#   map_public_ip_on_launch = "false"

#   tags = {
#     Name = "${var.environment_name}-${var.project_name}-ecs-private-subnet"
#   }
# }


# #PUBLIC SUBNET

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.prod_vpc.id
  count                   = length(var.public_subnet_cidr)
  cidr_block              = element(var.public_subnet_cidr, count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = "true"
  tags = {
    Name = "${var.environment_name}-${var.project_name}-public-subnet"
  }
}


# # Creating RT for Public Subnet for 

resource "aws_route_table" "ec2_public_routetable" {
  vpc_id = aws_vpc.prod_vpc.id

  tags = {
    Name = "${var.environment_name}-${var.project_name}-public-route-table"
  }
}

# ###### # Creating RT for Private Subnet 

resource "aws_route_table" "ec2_private_routetable" {
  vpc_id = aws_vpc.prod_vpc.id

  tags = {
    Name = "${var.environment_name}-${var.project_name}-private-route-table"
  }
}


# # # ###### # Creating RT for ecs Private Subnet 

# resource "aws_route_table" "ecs_private_routetable" {
#   vpc_id = aws_vpc.prod_vpc.id

#   tags = {
#     Name = "${var.environment_name}-${var.project_name}-ecs-private-route-table"
#   }
# }

# # Public route can acess internet gateway

resource "aws_route" "jainam_uat_public_igw_ec2" {
  route_table_id         = aws_route_table.ec2_public_routetable.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.prod_igw.id
}


resource "aws_route" "jainam_prod_private_nat_instance" {
  route_table_id         = aws_route_table.ec2_private_routetable.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id   = var.eni_nat
}

# Public route table association

resource "aws_route_table_association" "public_routetableassociation" {
  count          = length(var.public_subnet_cidr)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.ec2_public_routetable.id
}

# Private route table association

resource "aws_route_table_association" "jainam_prod_private_routetableassociation" {
  count          = length(var.private_subnet_cidr)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.ec2_private_routetable.id
}

# # ECS Private route table association

# resource "aws_route_table_association" "ecs_private_routetableassociation" {
#   count          = length(var.private_subnet_cidr)
#   subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
#   route_table_id = aws_route_table.ec2_private_routetable.id
# }
