locals {

  project = "nginx"

  tags = {
    Project     = "Terraform-Puppet"
    Environment = var.environment
    ManagedBy   = "Terraform"
  }

  vnet_address_space = [
    "10.0.0.0/16"
  ]

  workload_subnet_address_prefixes = [
    "10.0.1.0/24"
  ]
  appgw_subnet_address_prefixes = [
    "10.0.0.64/26"
  ]
  bastion_subnet_address_prefixes = [
    "10.0.0.0/26"
  ]

}