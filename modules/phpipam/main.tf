# PHPIPAM PROVIDER CONFIG

terraform {
  required_providers {
    phpipam = {
      source  = "lord-kyron/phpipam"
      version = "1.3.6"
    }
  }
}

# Look up the subnet parameters to main network
data "phpipam_subnet" "subnet" {
  section_id        = 3
  description_match = lookup(var.phpipam_subnet_description, var.vm_network, var.phpipam_subnet_description["default"])
}

# Look up the subnet parameters to backup network
data "phpipam_subnet" "bckpsubnet" {
  section_id        = 3
  description_match = ".*Backup"
}

# Determine Gateway IP by gateway_id
data "phpipam_address" "gateway" {
  address_id = data.phpipam_subnet.subnet.gateway_id
}

# Reserve IP address to main network in phpipam
resource "phpipam_address" "newip" {
  subnet_id   = data.phpipam_subnet.subnet.subnet_id
  hostname    = var.hostname
  description = "Managed by Terraform"

  lifecycle {
    ignore_changes = [
      subnet_id,
      ip_address,
    ]
  }
}

# Reserve IP address to backup network in phpipam
resource "phpipam_address" "bckpnewip" {
  subnet_id   = data.phpipam_subnet.bckpsubnet.subnet_id
  hostname    = var.hostname
  description = "Managed by Terraform"

  lifecycle {
    ignore_changes = [
      subnet_id,
      ip_address,
    ]
  }
}

output "phpipam_bckp_ipv4_reserved" {
  value = phpipam_address.bckpnewip.ip_address
}

output "phpipam_main_ipv4_reserved" {
  value = phpipam_address.newip.ip_address
}

output "phpipam_subnet_addr" {
  value = data.phpipam_subnet.subnet.subnet_address
}

output "phpipam_subnet_mask" {
  value = data.phpipam_subnet.subnet.subnet_mask
}

output "phpipam_subnet_gateway" {
  value = data.phpipam_address.gateway.ip_address
}

output "phpipam_subnet_name_servers" {
  value = replace(data.phpipam_subnet.subnet.nameservers["namesrv1"], ";", " ")
}