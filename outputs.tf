output "resource_group" {
  value = var.resource_group_name
}

output "vm_size" {
  value = var.vm_size
}

output "cluster_nodes" {
  value = {
    for node, vm in azurerm_linux_virtual_machine.k8s :
    node => {
      hostname  = vm.name
      private_ip = azurerm_network_interface.k8s[node].private_ip_address
      public_ip  = azurerm_public_ip.k8s[node].ip_address
      role       = var.nodes[node].role
    }
  }
}

output "control_plane_public_ip" {
  value = azurerm_public_ip.k8s["cp01"].ip_address
}

output "control_plane_private_ip" {
  value = azurerm_network_interface.k8s["cp01"].private_ip_address
}

output "worker_private_ips" {
  value = {
    for node in ["worker01", "worker02"] :
    node => azurerm_network_interface.k8s[node].private_ip_address
  }
}