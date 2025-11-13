variable "lab_role_arn" { default = "arn:aws:iam::169402690764:role/LabRole" }
variable "region" { default = "us-east-1" }
variable "cluster_name" { default = "eks-lab" }
variable "node_group_name" { default = "eks-lab-node-group" }
variable "desired_capacity" { default = 2 }
variable "subnet_ids" {
  type = list(string)
  default = [
    "subnet-0aa75e6702b7a8a03",
    "subnet-0174f653e149957e9",
    "subnet-083a433a12912667e"
  ]
}

