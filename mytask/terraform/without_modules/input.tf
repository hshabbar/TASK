variable "vpc_cidr" {
  description = "CIDR for VPC"
  type = string
  default = "172.32.0.0/16"
}

variable "public_subnet_one_cidr" {
  description = "CIDR for public subnet one"
  type = string
  default = "172.32.0.0/20"
}

variable "public_subnet_two_cidr" {
  description = "CIDR for public subnet two"
  type = string
  default = "172.32.16.0/20"
}

variable "public_subnet_one_availability_zone" {
  description = "availability zone for public subnet one"
  type = string
  default = "ap-south-1a"
}

variable "public_subnet_two_availability_zone" {
  description = "availability zone for public subnet two"
  type = string
  default = "ap-south-1b"
}

variable "private_subnet_one_cidr" {
  description = "CIDR for private subnet one"
  type = string
  default = "172.32.32.0/20"
}

variable "private_subnet_two_cidr" {
  description = "CIDR for private subnet two"
  type = string
  default = "172.32.64.0/20"
}

variable "private_subnet_one_availability_zone" {
  description = "availability zone for private subnet one"
  type = string
  default = "ap-south-1a"
}

variable "private_subnet_two_availability_zone" {
  description = "availability zone for private subnet two"
  type = string
  default = "ap-south-1b"
}

#variable "eks_cluster_name" {
#  description = "Name of EKS cluster"
#  type = string
#  default = "test-eks-cluster"
#}
#
#variable "nodegroup_name" {
#  description = "Name of EKS cluster's managed nodegroup"
#  type = string
#  default = "ng1"
#}
