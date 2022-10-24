variable "nutanix_username" {
  description = "Usuário de conexão com a API do nutanix."
  default     = ""
}

variable "nutanix_password" {
  description = "Senha do usuário de conexão com a API do nutanix."
  default     = ""
}
variable "nutanix_endpoint" {
  description = "Endereço da API do nutanix."
  default     = ""
}

variable "nutanix_port" {
  description = "Porta usada para conexão a API do nutanix."
  default     = 9440
}

variable "nutanix_insecure" {
  description = "Verificação de certificado da API do nutanix."
  default     = "true"
}

variable "nutanix_vm_template" {
  description = "Imagem da VM usada como base para provisionar novas VMs."
  default     = ""
}

variable "nutanix_network_nic" {
  description = "IDs das redes criadas no nutanix."
  type        = map(any)

  default = {
    default = ""
    homolog = ""
    desenv  = ""
    dmz     = ""
    adm     = ""
    bckp    = ""
  }
}

variable "tf_ssh_cred" {
  description = "Credenciais ssh usada para TF testar o provisionamento da VM."
  type        = map(any)

  default = {
    "user" = ""
    "pass" = ""
    "port" = ""
  }
}

variable "phpipam_endpoint" {
  description = "Endereço da API do phpipam"
  default     = ""
}

variable "phpipam_insecure" {
  description = "Verificar certificado na conexão com a api."
  default     = "false"
}

variable "phpipam_appid" {
  description = "APP id para conexão na API do phpipam"
  default     = ""
}

variable "phpipam_username" {
  description = "Usuário para conexão na API do phpipam"
  default     = ""
}

variable "phpipam_password" {
  description = "Senha do usuário para conexão na API do phpipam"
  default     = ""
}

variable "vms" {
  type = map(object({
    name     = string
    n_socket = number
    n_vcpu   = number
    s_memory = number
    s_disk   = number
    network  = string 
  }))
}