module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "${local.name}-vpc"
  cidr = "10.0.0.0/16"

  azs              = slice(data.aws_availability_zones.available.names, 0, 3)
  public_subnets   = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets = ["10.0.11.0/24", "10.0.12.0/24", "10.0.13.0/24"]


  enable_nat_gateway = false
  enable_vpn_gateway = false
  
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = local.tags
}