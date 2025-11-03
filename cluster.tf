resource "kubernetes_manifest" "clusters" {
  for_each = var.additional_clusters
  manifest = {
    apiVersion = "v1"
    kind = "Secret"
    metadata = {
      name      = "${each.key}-cluster"
      namespace = var.namespace
      labels = {
        "argocd.argoproj.io/secret-type" = "cluster"
      }
    }
    data = {
      name = base64encode(each.key)
      server = base64encode(each.value.server_endpoint)
      config = base64encode(jsonencode({
        bearerToken = each.value.token
        tlsClientConfig = {
          caData = each.value.tls.ca
          certData = each.value.tls.cert
          keyData = each.value.tls.key
        }
      }))
    }
  }
}
