provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

provider "kubernetes" {
  host        = module.eks_prod.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks_prod.cluster_certificate_authority_data)
  exec {
  api_version = "client.authentication.k8s.io/v1beta1"
  command     = "aws"
  args = ["eks", "get-token", "--cluster-name", module.eks_prod.cluster_name, "--profile", "terraform-meuchapa-dev" ]
 }
}
