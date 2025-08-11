locals {
  project_name         = "netauto-ng"
  region               = "FRA1"
  permanent_workspaces = ["dev", "prod"]
  profile              = contains(local.permanent_workspaces, terraform.workspace) ? terraform.workspace : "dev"
  namespace            = lower(join("-", [local.project_name, terraform.workspace]))
  cluster_name         = local.namespace
}
