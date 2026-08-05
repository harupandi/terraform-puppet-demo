locals {

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

  appgw_sku_name = "Standard_v2"
  appgw_sku_tier = "Standard_v2"
  appgw_capacity = 2

  appgw_frontend_port = 80

  backend_port = 80

  probe_path = "/"

  probe_interval            = 30
  probe_timeout             = 30
  probe_unhealthy_threshold = 3

  vms = {
    for vm_name, config in var.vms :

    vm_name => merge(
      config,
      {
        vm_name  = "${local.prefix}-${vm_name}"
        nic_name = "${local.prefix}-${vm_name}-nic"
      }
    )
  }

}