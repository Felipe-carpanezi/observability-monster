terraform {
  source = "../../../modules/rds" 
}

dependency "vpc" {
  config_path = "../vpc"

  # ADICIONE ESTE BLOCO AQUI:
  mock_outputs = {
    vpc_id          = "vpc-fake-id"
    vpc_cidr_block  = "10.0.0.0/16"
    private_subnets = ["subnet-fake-1", "subnet-fake-2"]
  }
  mock_outputs_allowed_terraform_commands = ["plan", "validate"]
}

inputs = {
  vpc_id      = dependency.vpc.outputs.vpc_id
  vpc_cidr    = dependency.vpc.outputs.vpc_cidr_block
  subnet_ids  = dependency.vpc.outputs.private_subnets
  db_password = "MonsterPassword2026"
}