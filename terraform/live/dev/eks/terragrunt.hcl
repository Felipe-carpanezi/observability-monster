terraform {
  source = "../../../modules/eks" 
}

dependency "vpc" {
  config_path = "../vpc"

  # ADICIONE ESTE BLOCO AQUI:
  mock_outputs = {
    vpc_id          = "vpc-fake-id"
    private_subnets = ["subnet-fake-1", "subnet-fake-2"]
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
}

inputs = {
  cluster_name = "monster-eks"
  vpc_id       = dependency.vpc.outputs.vpc_id
  subnet_ids   = dependency.vpc.outputs.private_subnets
}