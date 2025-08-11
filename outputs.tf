output "cluster_name" {
  value = civo_kubernetes_cluster.this.name
}

output "kubeconfig" {
  value = local_file.kubeconfig.filename
}

output "traefik_lb" {
  value = {
    "public_ip" = data.civo_loadbalancer.traefik.public_ip
  }
}
