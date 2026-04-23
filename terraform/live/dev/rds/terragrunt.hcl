terraform {
  source = "../../../modules/rds"
}
dependency "vpc" {
  config_path = "../vpc"
}

inputs = {
  vpc_id      = dependency.vpc.outputs.vpc_id
  vpc_cidr    = dependency.vpc.outputs.vpc_cidr_block
  subnet_ids  = dependency.vpc.outputs.private_subnets
  db_password = "MonsterPassword2026" # Em prod, usaríamos Secrets Manager
}