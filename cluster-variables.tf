variable "additional_clusters" {
  description = "Set of new cluster to track on argocd"
  type = map(object({
    server_endpoint = string
    token = string
    tls = object({
      ca = string
      cert = string
      key = string
    })
  }))

  default = {}
}
