terraform {
  backend "s3" {
    bucket = "terraform-state"
    key    = "terraform.tfstate"

    endpoint = ""

    access_key = ""
    secret_key = ""

    region                      = ""
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    force_path_style            = true
  }
}