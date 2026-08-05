locals {

  project = "nginx"

  prefix = "${local.project}-${var.environment}"

  resource_group_name = "${local.prefix}-rg"

  vnet_name = "${local.prefix}-vnet"

  workload_subnet_name = "${local.prefix}-workload-subnet"

  appgw_subnet_name = "${local.prefix}-appgw-subnet"

  appgw_name = "${local.prefix}-appgw"

  appgw_public_ip_name = "${local.prefix}-appgw-pip"

  appgw_backend_pool_name = "backend-pool"

  appgw_http_settings_name = "http-settings"

  appgw_listener_name = "listener-http"

  appgw_probe_name = "nginx-probe"

  appgw_rule_name = "http-rule"

  appgw_frontend_ip_name = "frontend-ip"

  appgw_frontend_port_name = "http-port"

  appgw_gateway_ip_config_name = "gateway-ip-config"

  bastion_subnet_name = "AzureBastionSubnet"

  bastion_name = "${local.prefix}-bastion"

  bastion_public_ip_name = "${local.prefix}-bastion-pip"

  nsg_name = "${local.prefix}-nsg"

}