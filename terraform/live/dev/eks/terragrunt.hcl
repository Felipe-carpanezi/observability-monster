terraform {
  source = "../../../modules/eks"
}

# O Terragrunt entende que o EKS precisa da VPC
dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  cluster_name = "monster-eks"
  vpc_id       = dependency.vpc.outputs.vpc_id
  subnet_ids   = dependency.vpc.outputs.private_subnets
}