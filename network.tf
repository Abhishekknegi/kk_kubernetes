resource "azurerm_virtual_network" "k8s" {

  name                = "k8s-vnet"
  address_space       = var.vnet_address_space
  location            = var.location
  resource_group_name = var.resource_group_name

  tags = var.tags
}

resource "azurerm_subnet" "k8s" {

  name                 = "k8s-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.k8s.name

  address_prefixes = [
    var.subnet_address_prefix
  ]
}

resource "azurerm_public_ip" "k8s" {

  for_each = var.nodes

  name                = "pip-${local.common_name}-${each.key}"
  resource_group_name = var.resource_group_name
  location            = var.location

  allocation_method = "Static"
  sku               = "Standard"

  tags = merge(
    var.tags,
    {
      NodeRole = each.value.role
    }
  )
}

resource "azurerm_network_interface" "k8s" {

  for_each = var.nodes

  name                = "nic-${local.common_name}-${each.key}"
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {

    name = "internal"

    subnet_id = azurerm_subnet.k8s.id

    private_ip_address_allocation = "Dynamic"

    public_ip_address_id = azurerm_public_ip.k8s[each.key].id
  }

  tags = merge(
    var.tags,
    {
      NodeRole = each.value.role
    }
  )
}