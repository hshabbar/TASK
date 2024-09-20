#resource "aws_iam_role" "eks_cluster_role" {
#  name = "eks_cluster_role_terraform"
#  assume_role_policy = <<POLICY
#{
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Effect": "Allow",
#      "Principal": {
#        "Service": "eks.amazonaws.com"
#      },
#      "Action": "sts:AssumeRole"
#    }
#  ]
#}
#POLICY
#}
#
#
#resource "aws_iam_role_policy_attachment" "my-AmazonEKSClusterPolicy" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
#  role       = aws_iam_role.eks_cluster_role.name
#}
#
#
#resource "aws_iam_role_policy_attachment" "my-AmazonEKSVPCResourceController" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
#  role       = aws_iam_role.eks_cluster_role.name
#}
#
#
#resource "aws_eks_cluster" "my_eks_cluster" {
#  name     = var.eks_cluster_name
#  role_arn = aws_iam_role.eks_cluster_role.arn
#  vpc_config { 
#    subnet_ids = [aws_subnet.my_private_subnet_one.id, aws_subnet.my_private_subnet_two.id]
#  }
#  depends_on = [
#    aws_iam_role_policy_attachment.my-AmazonEKSClusterPolicy,
#    aws_iam_role_policy_attachment.my-AmazonEKSVPCResourceController,
#  ]
#}
#
#
#resource "aws_eks_addon" "vpc_cni" {
#  cluster_name = aws_eks_cluster.my_eks_cluster.name
#  addon_name   = "vpc-cni"
#}
#
#
#resource "aws_eks_addon" "coredns" {
#  cluster_name = aws_eks_cluster.my_eks_cluster.name
#  addon_name   = "coredns"
#}
#
#
#resource "aws_eks_addon" "kube-proxy" {
#  cluster_name = aws_eks_cluster.my_eks_cluster.name
#  addon_name   = "kube-proxy"
#}
#
#
#resource "aws_iam_role" "eks_node_role" {
#  name = "eks-node-group-role"
#  assume_role_policy = jsonencode({
#    Statement = [{
#      Action = "sts:AssumeRole"
#      Effect = "Allow"
#      Principal = {
#        Service = "ec2.amazonaws.com"
#      }
#    }]
#    Version = "2012-10-17"
#  })
#}
#
#resource "aws_iam_role_policy_attachment" "noderole-AmazonEKSWorkerNodePolicy" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#  role       = aws_iam_role.eks_node_role.name
#}
#
#resource "aws_iam_role_policy_attachment" "noderole-AmazonEKS_CNI_Policy" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#  role       = aws_iam_role.eks_node_role.name
#}
#
#resource "aws_iam_role_policy_attachment" "noderole-AmazonEC2ContainerRegistryReadOnly" {
#  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#  role       = aws_iam_role.eks_node_role.name
#}
#
#
#resource "aws_eks_node_group" "managed_ng" {
#  cluster_name    = aws_eks_cluster.my_eks_cluster.name
#  node_group_name = var.nodegroup_name
#  node_role_arn   = aws_iam_role.eks_node_role.arn
#  subnet_ids = [aws_subnet.my_private_subnet_one.id, aws_subnet.my_private_subnet_two.id]
#  scaling_config {
#    desired_size = 1
#    max_size     = 5
#    min_size     = 0
#  }
#
#  update_config {
#    max_unavailable = 1
#  }
#
#  depends_on = [
#    aws_iam_role_policy_attachment.noderole-AmazonEKSWorkerNodePolicy,
#    aws_iam_role_policy_attachment.noderole-AmazonEKS_CNI_Policy,
#    aws_iam_role_policy_attachment.noderole-AmazonEC2ContainerRegistryReadOnly,
#  ]
#}
