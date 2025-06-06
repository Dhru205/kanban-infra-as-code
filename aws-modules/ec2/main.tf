resource "aws_instance" "postgres_ec2" {
  ami                         = var.ami_value
  key_name                    = var.postgresql_key
  instance_type               = var.instance_type_value
  vpc_security_group_ids      = [var.postgres_sg_id]
  subnet_id                   = var.private_subnet[0]
  associate_public_ip_address = false
  disable_api_termination     = true
  tags = {
    Name          = "${var.environment_name}-${var.project_name}-postgres-server"
    AutoStartStop = "${var.environment_name}"
    Environment   = "${var.environment_name}"
    Project       = "${var.project_name}"
    Autoscaling   = "No"
    Public        = "No"
    Backup        = "No"

  }
  ebs_block_device {
    device_name           = "/dev/sda1"
    volume_size           = 20    # Specify the storage size in GB
    volume_type           = "gp3" # Use "gp3" for general-purpose SSD
    delete_on_termination = false # Prevent volume from being deleted on instance termination
  }

}


resource "aws_instance" "bastion_ec2" {
  ami                         = var.ami_value
  key_name                    = var.postgresql_key
  instance_type               = var.instance_type_value_nat
  vpc_security_group_ids      = [var.bastion_sg_id]
  subnet_id                   = var.public_subnet[0]
  associate_public_ip_address = true
  disable_api_termination     = true
  tags = {
    Name          = "${var.environment_name}-${var.project_name}-bastion"
    AutoStartStop = "${var.environment_name}"
    Environment   = "${var.environment_name}"
    Project       = "${var.project_name}"
    Autoscaling   = "No"
    Public        = "Yes"
    Backup        = "No"
  }

  ebs_block_device {
    device_name           = "/dev/sda1"
    volume_size           = 20    # Specify the storage size in GB
    volume_type           = "gp3" # Use "gp3" for general-purpose SSD
    delete_on_termination = false # Prevent volume from being deleted on instance termination
  }

}


resource "aws_instance" "ec2_nat" {
  ami                         = var.ami_value_nat
  key_name                    = var.nat_key
  instance_type               = var.instance_type_value_nat
  vpc_security_group_ids      = [var.nat_sg_id]
  subnet_id                   = var.public_subnet[0]
  source_dest_check           = false
  associate_public_ip_address = true
  disable_api_termination     = true
  tags = {

    Name            = "${var.environment_name}-${var.project_name}-nat-instance"
    "AutoStartStop" = "${var.environment_name}"
    Environment     = "${var.environment_name}"
    Project         = "${var.project_name}"
    Autoscaling     = "No"
    Public          = "Yes"
    Backup          = "No"

  }
  ebs_block_device {
    device_name           = "/dev/sda1"
    volume_size           = 20    # Specify the storage size in GB
    volume_type           = "gp3" # Use "gp3" for general-purpose SSD
    delete_on_termination = false # Prevent volume from being deleted on instance termination
  }

}

resource "aws_eip" "nat_eip" {
  vpc = true
  tags = {

    Name        = "nat-eip"
    Service     = "nat-ec2"
    Environment = "${var.environment_name}"
    Project     = "${var.project_name}"

  }
}

resource "aws_eip" "bastion_eip" {
  vpc = true
  tags = {

    Name        = "${var.environment_name}-eip"
    Service     = "nat-ec2"
    Environment = "${var.environment_name}"
    Project     = "${var.project_name}"

  }
}


resource "aws_eip_association" "nat_eip_assoc" {
  instance_id   = aws_instance.ec2_nat.id
  allocation_id = aws_eip.nat_eip.id
}

resource "aws_eip_association" "bastion_eip_assoc" {
  instance_id   = aws_instance.bastion_ec2.id
  allocation_id = aws_eip.bastion_eip.id
}
