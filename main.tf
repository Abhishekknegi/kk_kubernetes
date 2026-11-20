locals {
  common_name = "k8s"

  ubuntu_image = {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}

resource "azurerm_linux_virtual_machine" "k8s" {

  for_each = var.nodes

  name                = "${local.common_name}-${each.key}"
  resource_group_name = var.resource_group_name
  location            = var.location

  size = var.vm_size

  admin_username = var.admin_username

  network_interface_ids = [
    azurerm_network_interface.k8s[each.key].id
  ]

  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = var.ssh_public_key
  }

  os_disk {
    name                 = "${local.common_name}-${each.key}-osdisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb         = var.os_disk_size_gb
  }

  source_image_reference {
    publisher = local.ubuntu_image.publisher
    offer     = local.ubuntu_image.offer
    sku       = local.ubuntu_image.sku
    version   = local.ubuntu_image.version
  }

  custom_data = base64encode(
    templatefile("${path.module}/cloud-init.yaml", {
      hostname = "${local.common_name}-${each.key}"
      role     = each.value.role
    })
  )

  tags = merge(
    var.tags,
    {
      NodeRole = each.value.role
    }
  )
}