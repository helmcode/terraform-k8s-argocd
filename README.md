# Terraform Kubernetes ArgoCD Module

Terraform module to deploy ArgoCD on any Kubernetes cluster.

## Features

- Creates namespace (optional)
- Configurable replicas for all components
- Customizable resource limits and requests
- Support for LoadBalancer, ClusterIP, or NodePort service types
- Optional Ingress configuration
- Optional Dex (SSO) integration
- Optional notifications controller
- ApplicationSet controller support
- Insecure mode for testing
- Full values override support

## Usage

### Basic Example

```hcl
module "argocd" {
  source = "path/to/terraform-k8s-argocd"

  namespace = "argocd"
  domain    = "argocd.example.com"
}
```

### Complete Example

```hcl
module "argocd" {
  source = "path/to/terraform-k8s-argocd"

  namespace       = "argocd"
  chart_version   = "7.6.12"
  domain          = "argocd.example.com"
  service_type    = "LoadBalancer"
  insecure_mode   = false

  server_replicas     = 2
  controller_replicas = 1
  repo_server_replicas = 2

  server_resources = {
    limits = {
      cpu    = "1000m"
      memory = "1Gi"
    }
    requests = {
      cpu    = "500m"
      memory = "512Mi"
    }
  }

  ingress_enabled = true
  ingress_class_name = "nginx"
  ingress_annotations = {
    "cert-manager.io/cluster-issuer" = "letsencrypt-prod"
  }
  ingress_hosts = ["argocd.example.com"]
  ingress_tls = [
    {
      secretName = "argocd-tls"
      hosts      = ["argocd.example.com"]
    }
  ]

  dex_enabled          = true
  notifications_enabled = true
}
```

### With Custom Values

```hcl
module "argocd" {
  source = "path/to/terraform-k8s-argocd"

  namespace = "argocd"
  domain    = "argocd.example.com"

  extra_values = [
    yamlencode({
      configs = {
        repositories = {
          "my-repo" = {
            url = "https://github.com/myorg/myrepo"
          }
        }
      }
    })
  ]
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| kubernetes | >= 2.0 |
| helm | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| kubernetes | >= 2.0 |
| helm | >= 2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| namespace | Namespace where ArgoCD will be deployed | `string` | `"argocd"` | no |
| domain | Domain for ArgoCD | `string` | n/a | yes |
| chart_version | ArgoCD Helm chart version | `string` | `"7.6.12"` | no |
| service_type | Service type (LoadBalancer/ClusterIP/NodePort) | `string` | `"LoadBalancer"` | no |
| server_replicas | Number of server replicas | `number` | `2` | no |
| controller_replicas | Number of controller replicas | `number` | `1` | no |
| repo_server_replicas | Number of repo server replicas | `number` | `2` | no |
| insecure_mode | Run without TLS | `bool` | `true` | no |
| ingress_enabled | Enable ingress | `bool` | `false` | no |

See `variables.tf` for complete list of inputs.

## Outputs

| Name | Description |
|------|-------------|
| namespace | Namespace where ArgoCD is deployed |
| release_name | Helm release name |
| release_status | Status of the Helm release |
| chart_version | Chart version deployed |
| admin_password_command | Command to get admin password |
| server_url | ArgoCD server URL |

## Getting Started

After deployment, retrieve the admin password:

```bash
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

Access ArgoCD:
- If using LoadBalancer: `kubectl -n argocd get svc argocd-server`
- If using Ingress: Access via configured domain

## License

MIT
