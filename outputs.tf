output "cluster_name" {
  value = civo_kubernetes_cluster.this.name
}

output "kubeconfig" {
  value = local_file.kubeconfig.filename
}
