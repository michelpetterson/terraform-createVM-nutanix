variable "hostname" {
  type = string
}

variable "vm_network" {
  type = string
}

variable "bckp_subnet" {
  type = string
}

variable "phpipam_network_subnet" {
  description = "Redes do phpipam."
  type        = map(any)
  default = {
    "default" = ""
    "homolog" = ""
    "desenv"  = ""
    "dmz"     = ""
    "adm"     = ""
    "bckp"    = ""
  }
}

variable "phpipam_subnet_description" {
  description = "Descrição de subnets no phpipam"
  type        = map(any)
  default = {
    "default" = ".*SRV-Desenvolvimento"
    "homolog" = ".*SRV-Homologação"
    "desenv"  = ".*SRV-Desenvolvimento"
    "dmz"     = ".*DMZ (NOVA)"
    "adm"     = ".*SRV-ADM"
    "bckp"    = ".*Backup"
  }
}
