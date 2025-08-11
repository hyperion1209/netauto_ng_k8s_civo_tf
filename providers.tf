provider "civo" {
  region = local.region
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}
