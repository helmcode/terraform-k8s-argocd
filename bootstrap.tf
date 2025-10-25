resource "kubernetes_manifest" "bootstrap_applicationset" {
  count = var.bootstrap_applicationset_enabled ? 1 : 0

  manifest = {
    apiVersion = "argoproj.io/v1alpha1"
    kind       = "ApplicationSet"
    metadata = {
      name      = var.bootstrap_applicationset_name
      namespace = var.namespace
    }
    spec = {
      generators = [
        {
          git = {
            repoURL  = var.bootstrap_repo_url
            revision = var.bootstrap_repo_revision
            directories = [
              {
                path = var.bootstrap_repo_path
              }
            ]
          }
        }
      ]
      template = {
        metadata = {
          name = "{{path.basenameNormalized}}"
        }
        spec = {
          project = var.bootstrap_project
          destination = {
            server    = var.bootstrap_destination_server
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
              targetRevision = var.bootstrap_repo_revision
              path           = "{{path}}"
            }
          ]
        }
      }
    }
  }

  depends_on = [helm_release.argocd]
}
