module "eks_prod {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  create_kms_key	= false
  cluster_encryption_config = {}

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  vpc_id     = module.vpc_eks.vpc_id
  subnet_ids = module.vpc_eks.private_subnets

  cluster_endpoint_private_access = var.cluster_endpoint_private_access
  cluster_endpoint_public_access  = var.cluster_endpoint_public_access

  manage_aws_auth_configmap = var.manage_aws_auth_configmap

  aws_auth_users = [
  {
    userarn  = "arn:aws:iam::${var.account_id}:user/terraform"
    username = "terraform-user"
    groups   = ["system:masters"]
  },
]

  tags = var.tags

eks_managed_node_groups = {
    node_group1 = {
      subnet_ids = module.vpc_eks.private_subnets
      name             = "default"
      desired_size = 3
      max_size     = 6
      min_size     = 3
      instance_types = ["t3.large"]

      tags = {
        "Environment" = "stage"
        "ExtraTag"    = "default"
        "Name"        = "default"
        "Terraform"   = "true"
      }
    }
   }

}
