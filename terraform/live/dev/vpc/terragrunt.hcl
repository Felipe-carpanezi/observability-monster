terraform {
  # O correto é apenas subir 3 níveis e entrar em modules
  source = "../../../modules/vpc" 
}
inputs = { vpc_cidr = "10.0.0.0/16" }