provider "aws" {
  region = var.region
}

resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  role_arn = var.lab_role_arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  enabled_cluster_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]
}

resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.this.name
  node_group_name = var.node_group_name
  node_role_arn   = var.lab_role_arn
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = var.desired_capacity
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3.medium"]
  disk_size      = 20
}

data "aws_eks_cluster" "this" {
  name = aws_eks_cluster.this.name
}

data "aws_eks_cluster_auth" "this" {
  name = aws_eks_cluster.this.name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.this.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.this.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.this.token
}
