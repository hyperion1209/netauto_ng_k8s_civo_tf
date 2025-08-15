locals {
  project_name = "netauto-ng"
  region       = "FRA1"
  namespace    = lower(join("-", [local.project_name, terraform.workspace]))
}
