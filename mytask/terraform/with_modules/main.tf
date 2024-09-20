module "vpc_and_subnets" { 
  source = "./modules/vpc_and_subnets"
  vpc_cidr = "172.31.0.0/16"
  public_subnet_one_cidr = "172.31.0.0/20"
  public_subnet_two_cidr = "172.31.16.0/20"
  public_subnet_one_availability_zone = "ap-south-1a"
  public_subnet_two_availability_zone = "ap-south-1b"
  private_subnet_one_cidr = "172.31.32.0/20"
  private_subnet_two_cidr = "172.31.64.0/20"
  private_subnet_one_availability_zone = "ap-south-1a"
  private_subnet_two_availability_zone = "ap-south-1b"
}

#module "eks" {
#  source = "./modules/eks"
#  subnet_one = module.vpc_and_subnets.private_subnet_one_id
#  subnet_two = module.vpc_and_subnets.private_subnet_two_id
#  eks_cluster_name="task-eks"
#  nodegroup_name="task-nodegroup"
#}
