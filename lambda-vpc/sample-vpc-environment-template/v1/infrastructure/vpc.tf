module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.environment.inputs.vpc_name
  cidr = "10.0.0.0/16"

  azs             = ["${var.aws_region}a"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway                             = true
  enable_vpn_gateway                             = true
  enable_ipv6                                    = true
  assign_ipv6_address_on_creation                = true
  private_subnet_assign_ipv6_address_on_creation = false
  public_subnet_ipv6_prefixes                    = [0, 1]
  private_subnet_ipv6_prefixes                   = [2, 3]

  tags = {
    Terraform   = "true"
    Environment = var.environment.name
  }
}

