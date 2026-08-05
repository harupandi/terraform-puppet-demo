resource "azurerm_network_security_group" "workload" {

  name = local.nsg_name

  location = azurerm_resource_group.main.location

  resource_group_name = azurerm_resource_group.main.name

  tags = local.tags
}

resource "azurerm_network_security_rule" "allow_http_from_appgw" {

  name = "Allow-AppGateway-HTTP"

  priority = 100

  direction = "Inbound"

  access = "Allow"

  protocol = "Tcp"

  source_port_range = "*"

  destination_port_range = "80"

  source_address_prefix = local.appgw_subnet_address_prefixes[0]

  destination_address_prefix = "*"

  resource_group_name = azurerm_resource_group.main.name

  network_security_group_name = azurerm_network_security_group.workload.name
}

resource "azurerm_network_security_rule" "allow_bastion_ssh" {

  name = "Allow-Bastion-SSH"

  priority = 110

  direction = "Inbound"

  access = "Allow"

  protocol = "Tcp"

  source_port_range = "*"

  destination_port_range = "22"

  source_address_prefix = local.bastion_subnet_address_prefixes[0]

  destination_address_prefix = "*"

  resource_group_name = azurerm_resource_group.main.name

  network_security_group_name = azurerm_network_security_group.workload.name
}

resource "azurerm_network_security_rule" "puppet" {
  name                   = "Allow-Puppet"
  priority               = "120"
  direction              = "Inbound"
  access                 = "Allow"
  protocol               = "Tcp"
  source_port_range      = "*"
  destination_port_range = "8140"

  source_address_prefix      = azurerm_subnet.workload.address_prefixes[0]
  destination_address_prefix = "*"

  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.workload.name
}

resource "azurerm_subnet_network_security_group_association" "workload" {

  subnet_id = azurerm_subnet.workload.id

  network_security_group_id = azurerm_network_security_group.workload.id
}