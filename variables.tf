variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
  default     = "a2b28c85-1948-4263-90ca-bade2bac4df4"
}

variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "resource_group_name" {
  description = "Existing or target Azure Resource Group"
  type        = string
  default     = "kml_rg_main-1c291eb81ffe4c86"
}

variable "vm_size" {
  description = "Azure VM SKU"
  type        = string
  default     = "Standard_D2s_v3"
}

variable "admin_username" {
  description = "Linux administrator username"
  type        = string
  default     = "azureadmin"
}

variable "ssh_public_key" {
  description = "SSH public key"
  type        = string
}

variable "vnet_address_space" {
  description = "VNet CIDR"
  type        = list(string)
  default     = ["10.10.0.0/16"]
}

variable "subnet_address_prefix" {
  description = "Kubernetes subnet CIDR"
  type        = string
  default     = "10.10.1.0/24"
}

variable "os_disk_size_gb" {
  description = "OS disk size"
  type        = number
  default     = 30
}

variable "tags" {
  description = "Azure resource tags"
  type        = map(string)

  default = {
    Environment = "Lab"
    Project     = "Kubernetes"
    ManagedBy   = "Terraform"
  }
}

variable "nodes" {
  description = "Kubernetes cluster nodes"

  type = map(object({
    role = string
  }))

  default = {
    cp01 = {
      role = "control-plane"
    }

    worker01 = {
      role = "worker"
    }

    worker02 = {
      role = "worker"
    }
  }
}