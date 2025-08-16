resource "civo_network" "this" {
  label = "${local.namespace}-net"
}

resource "civo_firewall" "this" {
  name                 = "${local.namespace}-fw"
  network_id           = civo_network.this.id
  create_default_rules = true
  depends_on           = [civo_network.this]
}

resource "civo_kubernetes_cluster" "this" {
  name               = "${local.namespace}-cluster"
  write_kubeconfig   = true
  network_id         = civo_network.this.id
  firewall_id        = civo_firewall.this.id
  kubernetes_version = "1.31.6-k3s1"
  pools {
    label      = "one"
    size       = "g4s.kube.medium"
    node_count = 1
  }
  applications = "-traefik2-nodeport,traefik2-loadbalancer,cert-manager"
  depends_on   = [civo_firewall.this, civo_network.this]
}

resource "time_sleep" "this" {
  depends_on = [ civo_kubernetes_cluster.this ]

  create_duration = "30s"
}

data "civo_loadbalancer" "traefik" {
  name   = "${civo_kubernetes_cluster.this.name}-kube-system-traefik"
  region = local.region
  depends_on = [ time_sleep.this ]
}

resource "local_file" "kubeconfig" {
  filename = "/tmp/${civo_kubernetes_cluster.this.name}-kubeconfig"
  content  = civo_kubernetes_cluster.this.kubeconfig
}
