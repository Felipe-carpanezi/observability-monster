module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = "1.30" # Versão atual para evitar custos de suporte estendido

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  # Ponto crucial para acesso via terminal
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    monster_nodes = {
      instance_types = ["t3.medium"] # Equilíbrio entre custo e a RAM que o Zabbix/n8n exigem
      min_size     = 1
      max_size     = 3
      desired_size = 2
    }
  }

  tags = { Environment = "dev", Project = "monster" }
}