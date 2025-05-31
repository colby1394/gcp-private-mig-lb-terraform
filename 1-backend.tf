# https://www.terraform.io/language/settings/backends/gcs
terraform {
  backend "gcs" {
    bucket = "terraform_buck_01_west"
    prefix = "terraform/state"
    credentials = "starfleetgcp.json"
  }
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.36.0"
    }

    # tls = {
    #   source  = "hashicorp/tls"
    #   version = "~> 4.0"
    # }
  }
}

