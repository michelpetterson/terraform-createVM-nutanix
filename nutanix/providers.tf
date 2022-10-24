# PROVIDERS CONFIG

terraform {
  required_providers {
    nutanix = {
      source  = "nutanix/nutanix"
      version = "1.7.1"
    }
    phpipam = {
      source  = "lord-kyron/phpipam"
      version = "1.3.6"
    }
    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "2.2.0"
    }
  }
}

# NUTANIX OPTIONS

provider "nutanix" {
  username            = var.nutanix_username
  password            = var.nutanix_password
  endpoint            = var.nutanix_endpoint
  port                = var.nutanix_port
  insecure            = var.nutanix_insecure
  wait_timeout        = 10
  foundation_endpoint = var.nutanix_endpoint
  foundation_port     = 8000
}

# PHPIPAM OPTIONS

provider "phpipam" {
  app_id   = var.phpipam_appid
  endpoint = var.phpipam_endpoint
  username = var.phpipam_username
  password = var.phpipam_password
  insecure = var.phpipam_insecure
}

# CLOUDINIT OPTIONS

provider "cloudinit" {}