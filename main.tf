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

data "civo_loadbalancer" "traefik" {
  name   = "netauto-ng-dev-cluster-kube-system-traefik"
  region = local.region
}

resource "civo_dns_domain_name" "this" {
  name = "netauto-ng-dev.org"
}

resource "civo_dns_domain_record" "this" {
  domain_id  = civo_dns_domain_name.this.id
  type       = "A"
  name       = "www"
  value      = data.civo_loadbalancer.traefik.public_ip
  ttl        = 600
  depends_on = [civo_dns_domain_name.this, data.civo_loadbalancer.traefik]
}

resource "local_file" "kubeconfig" {
  filename = "/tmp/${civo_kubernetes_cluster.this.name}-kubeconfig"
  content  = civo_kubernetes_cluster.this.kubeconfig
}

module "certificates" {
  source = "./modules/certificates"
  domain = civo_dns_domain_name.this.id
}
