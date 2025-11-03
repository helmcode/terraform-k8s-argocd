resource "kubernetes_manifest" "bootstrap_applicationset" {
  count = var.bootstrap_applicationset_enabled ? 1 : 0
  for_each = var.bootstrap_destination

  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "ApplicationSet"
    metadata = {
      name      = "${var.bootstrap_applicationset_name}-${each.key}"
      namespace = var.namespace
    }
    spec = {
      generators = [
        {
          git = {
            repoURL  = var.bootstrap_repo_url
            revision = each.value.revision
            directories = [
              {
                path = each.value.path
              }
            ]
          }
        }
      ]
      template = {
        metadata = {
          name = "{{path.basenameNormalized}}-${each.key}"
          labels = {
            "appset.helmcode.com/source" = each.key
          }
        }
        spec = {
          project = each.value.project
          destination = {
            name      = each.value.server
            namespace = "{{path.basenameNormalized}}"
          }
          syncPolicy = merge(
            var.bootstrap_sync_automated ? {
              automated = {
                prune    = var.bootstrap_sync_prune
                selfHeal = var.bootstrap_sync_self_heal
              }
            } : {},
            {
              syncOptions = concat(
                var.bootstrap_create_namespace ? ["CreateNamespace=true"] : [],
                [
                  "ServerSideApply=true",
                  "ServerSideDiff=true"
                ]
              )
            }
          )
          sources = [
            {
              repoURL        = var.bootstrap_repo_url
              targetRevision = each.value.revision
              path           = "{{path}}"
            }
          ]
        }
      }
    }
  }

  depends_on = [helm_release.argocd]
}
