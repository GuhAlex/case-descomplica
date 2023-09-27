terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = ">= 4.47"
    }
    helm = {
      source = "hashicorp/helm"
      version = "2.7.1"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}



provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
}

data "aws_eks_cluster" "eks_prod" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "eks_prod" {
  name = var.cluster_name
}

provider "helm" {
  kubernetes {
    host        = data.aws_eks_cluster.eks_prod.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_prod.certificate_authority[0].data)
    token                  = data.aws_eks_cluster_auth.eks_prod.token
  }
}
