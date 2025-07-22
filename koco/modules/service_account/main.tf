resource "kubernetes_service_account" "sa"{
  metadata{
    name = var.sa-name
    namespace = var.sa-namespace
    annotations = var.sa-annotations
  }
}