resource "azurerm_public_ip" "bastion" {

  name                = local.bastion_public_ip_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  allocation_method = "Static"

  sku = "Standard"

  tags = local.tags
}

resource "azurerm_bastion_host" "main" {

  name                = local.bastion_name
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  sku = "Basic"

  ip_configuration {

    name = "configuration"

    subnet_id = azurerm_subnet.bastion.id

    public_ip_address_id = azurerm_public_ip.bastion.id
  }

  tags = local.tags
}