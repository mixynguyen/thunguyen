provider "aws" {
  region  = "us-west-1"

}
module "vpc" {
    source = "./module/terraform-aws-vpc"
    cidr = "10.0.0.0/16"
    public_subnets = [ "10.0.1.0/24", "10.0.2.0/24" ]
    private_subnets = [ "10.0.3.0/24", "10.0.4.0/24" ]

    enable_dns_hostnames = true
    enable_dns_support = true
    single_nat_gateway = true
        
    azs = [ "us-west-1b", "us-west-1c" ]
    tags = {
      "Name" = "thunth15"
    }
}

module "sg" {
  source = "./module/terraform-aws-security-group"
  name = "thunth15-packer-sg"
  vpc_id = module.vpc.vpc_id
  ingress_rules = ["all-all"]
  ingress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules = ["all-all"]
     tags = {
      "Name" = "thunth15"
    } 
}