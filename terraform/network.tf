resource "azurerm_virtual_network" "main" {

  name                = local.vnet_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  address_space = local.vnet_address_space

  tags = local.tags
}

resource "azurerm_subnet" "appgw" {
  name                 = local.appgw_subnet_name
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = local.appgw_subnet_address_prefixes
}

resource "azurerm_subnet" "workload" {
  name                 = local.workload_subnet_name
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = local.workload_subnet_address_prefixes
}

resource "azurerm_subnet" "bastion" {
  name                 = local.bastion_subnet_name
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = local.bastion_subnet_address_prefixes
}