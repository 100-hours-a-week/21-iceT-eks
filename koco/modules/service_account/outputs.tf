output "sa-namespace"{
  value = kubernetes_service_account.sa.metadata[0].namespace
}
output "sa-name"{
  value = kubernetes_service_account.sa.metadata[0].name
}