variable "eks_cluster_name" {
  description = "Name of EKS cluster"
  type = string
  default = "test-eks-cluster"
}

variable "nodegroup_name" {
  description = "Name of EKS cluster's managed nodegroup"
  type = string
  default = "ng1"
}

variable "subnet_one" {
  description = "ID of first subnet for cluster and worker nodes"
  type = string
}

variable "subnet_two" {
  description = "ID of second subnet for cluster and worker nodes"
  type = string
}
