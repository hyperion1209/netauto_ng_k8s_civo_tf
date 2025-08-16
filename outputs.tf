output "cluster_name" {
  value = civo_kubernetes_cluster.this.name
}

output "lb_public_ip" {
  value = data.civo_loadbalancer.traefik.public_ip
}

output "kubeconfig" {
  value = local_file.kubeconfig.filename
}
