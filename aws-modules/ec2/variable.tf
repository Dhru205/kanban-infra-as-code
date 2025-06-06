variable "ami_value" {
  default = "ami-09b0a86a2c84101e1"
}

variable "postgresql_key" {
  default = "postgresql-key-fortcapital"
}

variable "instance_type_value" {
  default = "t3a.small"
}

variable "postgres_sg_id" {
}

variable "environment_name" {}

variable "project_name" {}


variable "ami_value_nat" {
  default = "ami-0fe932cb431f5e326"
}

variable "instance_type_value_nat" {
  default = "t3a.nano"
}

variable "nat_sg_id" {}

variable "nat_key" {
  default = "nat-key-fortcapital"
}

variable "bastion_sg_id" {

}
variable "public_subnet" {

}

variable "private_subnet" {

}
