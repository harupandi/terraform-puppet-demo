locals {

  prefix = "${local.project}-${var.environment}"

  resource_group_name = "${local.prefix}-rg"

  vnet_name = "${local.prefix}-vnet"

  workload_subnet_name = "${local.prefix}-workload-subnet"

  appgw_subnet_name = "${local.prefix}-appgw-subnet"

  appgw_name = "${local.prefix}-appgw"

  appgw_public_ip_name = "${local.prefix}-appgw-pip"

  bastion_subnet_name = "AzureBastionSubnet"

  bastion_name = "${local.prefix}-bastion"

  bastion_public_ip_name = "${local.prefix}-bastion-pip"

  nsg_name = "${local.prefix}-nsg"

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