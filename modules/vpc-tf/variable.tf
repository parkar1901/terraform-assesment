variable "vpc_name" {
  default = "my-vpc"
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "pub_subnet_1_cidr" {
  default = "10.0.1.0/24"
}
variable "pub_subnet_2_cidr" {
  default = "10.0.2.0/24"
}
variable "pri_subnet_1_cidr" {
  default = "10.0.3.0/24"
}
variable "pri_subnet_2_cidr" {
  default = "10.0.4.0/24"
}
