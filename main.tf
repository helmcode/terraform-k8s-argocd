resource "kubernetes_namespace" "argocd" {
  count = var.create_namespace ? 1 : 0

  metadata {
    name = var.namespace
    labels = merge(
      {
        name = var.namespace
      },
      var.namespace_labels
    )
    annotations = var.namespace_annotations
  }
}

resource "helm_release" "argocd" {
  name       = var.release_name
  repository = var.chart_repository
  chart      = "argo-cd"
  version    = var.chart_version
  namespace  = var.namespace

  timeout         = var.timeout
  wait            = var.wait
  force_update    = var.force_update
  cleanup_on_fail = var.cleanup_on_fail

  values = concat(
    [
      yamlencode({
        global = {
          domain = var.domain
        }

        server = {
          replicas = var.server_replicas

          service = {
            type        = var.service_type
            annotations = var.service_annotations
          }

          resources = var.server_resources

          extraArgs = var.insecure_mode ? ["--insecure"] : []

          ingress = var.ingress_enabled ? {
            enabled          = true
            ingressClassName = var.ingress_class_name
            annotations      = var.ingress_annotations
            hosts            = var.ingress_hosts
            tls              = var.ingress_tls
          } : { enabled = false }
        }

        controller = {
          replicas  = var.controller_replicas
          resources = var.controller_resources
        }

        repoServer = {
          replicas  = var.repo_server_replicas
          resources = var.repo_server_resources
        }

        redis = {
          enabled   = var.redis_enabled
          resources = var.redis_resources
        }

        dex = {
          enabled = var.dex_enabled
        }

        applicationSet = {
          enabled   = var.applicationset_enabled
          replicas  = var.applicationset_replicas
          resources = var.applicationset_resources
        }

        notifications = {
          enabled = var.notifications_enabled
        }

        configs = {
          params = merge(
            {
              "server.insecure" = var.insecure_mode
            },
            var.config_params
          )
        }
      })
    ],
    var.extra_values
  )

  dynamic "set" {
    for_each = var.helm_sets
    content {
      name  = set.value.name
      value = set.value.value
      type  = lookup(set.value, "type", null)
    }
  }

  dynamic "set_sensitive" {
    for_each = var.helm_sets_sensitive
    content {
      name  = set_sensitive.value.name
      value = set_sensitive.value.value
      type  = lookup(set_sensitive.value, "type", null)
    }
  }

  depends_on = [kubernetes_namespace.argocd]
}
