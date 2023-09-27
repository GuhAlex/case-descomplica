module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = var.sg_name
  description = "security group"
  vpc_id      = module.vpc.vpc_id

  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "PostgreSQL access from within VPC"
      cidr_blocks = module.vpc.vpc_cidr_block
    },
  ]
}
