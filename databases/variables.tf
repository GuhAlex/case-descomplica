variable "cluster_name" {
  type    = string
  default = ""
}

variable "aws_profile" {
  type    = string
  default = ""
}

variable "account_id" {
  type    = string
  default = ""
}

variable "aws_region" {
  type    = string
  default = ""
}

variable "vpc_name" {
  type    = string
  default = ""
}

variable "vpc_cidr" {
  type    = string
  default = ""
}

variable "sg_name" {
  type    = string
  default = ""
}

variable "private_subnets" {
  type    = list(string)
  default = ["11.0.1.0/24", "11.0.2.0/24", "11.0.3.0/24"]
}

variable "public_subnets" {
  type    = list(string)
  default = ["11.0.4.0/24", "11.0.5.0/24", "11.0.6.0/24"]
}
