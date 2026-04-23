variable "cluster_name" { default = "monster-cluster" }
variable "vpc_id" {}
variable "subnet_ids" { type = list(string) }