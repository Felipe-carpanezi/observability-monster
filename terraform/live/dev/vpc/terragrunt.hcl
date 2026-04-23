terraform {
  source = "../../../modules/vpc" # 1:dev, 2:live, 3:terraform -> modules
}
inputs = { vpc_cidr = "10.0.0.0/16" }