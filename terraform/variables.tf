variable "location" {
  description = "Azure region"
  type        = string
  default     = "East US"
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "dev"
}

variable "vm_size" {
  description = "Azure VM size"
  type        = string
  default     = "Standard_B2s"
}

variable "admin_username" {
  description = "Administrator username"
  type        = string
  default     = "azureadmin"
}

variable "ssh_public_key" {
  description = "SSH public key"
  type        = string
}

variable "vms" {
  description = "Virtual machine configuration"

  type = map(object({
    zone = number
    role = string
  }))
}

variable "puppet_server_fqdn" {
  description = "FQDN of the Puppet Server"
  type        = string
}