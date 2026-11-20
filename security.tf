resource "azurerm_network_security_group" "k8s" {

  name                = "nsg-k8s"
  location            = var.location
  resource_group_name = var.resource_group_name

  security_rule {
    name      = "Allow-SSH"
    priority  = 100
    direction = "Inbound"
    access    = "Allow"
    protocol  = "Tcp"

    source_port_range      = "*"
    destination_port_range = "22"

    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name      = "Allow-Kubernetes-API"
    priority  = 110
    direction = "Inbound"
    access    = "Allow"
    protocol  = "Tcp"

    source_port_range      = "*"
    destination_port_range = "6443"

    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name      = "Allow-Etcd"
    priority  = 120
    direction = "Inbound"
    access    = "Allow"
    protocol  = "Tcp"

    source_port_range      = "*"
    destination_port_range = "2379-2380"

    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name      = "Allow-Kubelet"
    priority  = 130
    direction = "Inbound"
    access    = "Allow"
    protocol  = "Tcp"

    source_port_range      = "*"
    destination_port_range = "10250"

    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name      = "Allow-Kube-Controller"
    priority  = 140
    direction = "Inbound"
    access    = "Allow"
    protocol  = "Tcp"

    source_port_range      = "*"
    destination_port_range = "10257"

    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name      = "Allow-Kube-Scheduler"
    priority  = 150
    direction = "Inbound"
    access    = "Allow"
    protocol  = "Tcp"

    source_port_range      = "*"
    destination_port_range = "10259"

    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name      = "Allow-Calico-BGP"
    priority  = 160
    direction = "Inbound"
    access    = "Allow"
    protocol  = "Tcp"

    source_port_range      = "*"
    destination_port_range = "179"

    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name      = "Allow-Calico-VXLAN"
    priority  = 170
    direction = "Inbound"
    access    = "Allow"
    protocol  = "Udp"

    source_port_range      = "*"
    destination_port_range = "4789"

    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name      = "Allow-NodePort"
    priority  = 180
    direction = "Inbound"
    access    = "Allow"
    protocol  = "Tcp"

    source_port_range      = "*"
    destination_port_range = "30000-32767"

    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}

resource "azurerm_subnet_network_security_group_association" "k8s" {

  subnet_id = azurerm_subnet.k8s.id

  network_security_group_id = azurerm_network_security_group.k8s.id
}