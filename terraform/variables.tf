variable "aws_region" {
  default = "us-east-2"
}

# vpc
variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "public_subnet_1" {
  default = "10.0.1.0/24"
}

variable "nsg-name" {
  default = "Nsg-strapi"
}

variable "key-name" {
  default = "Key-strapi"
}

variable "key-path" {
  default = "~/.ssh/id_rsa.pub"
}

variable "ami" {
  default = "ami-0d1b5a8c13042c939"
}

variable "instance-type" {
  default = "t2.medium" 
}