terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "hyperion_home"

    workspaces {
      prefix = "netauto-ng-civo-k8s-"
    }
  }
  required_providers {
    civo = {
      source  = "civo/civo"
      version = "1.1.5"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0.5"
    }

    cloudinit = {
      source  = "hashicorp/cloudinit"
      version = "~> 2.3.4"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
  }
  required_version = "~> 1.3"
}
