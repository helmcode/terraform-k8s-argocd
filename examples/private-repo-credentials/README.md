# Private Repository Credentials Example

This example demonstrates how to configure ArgoCD with private repository credentials using **individual variables** (perfect for Scalr or any remote backend).

## Important Security Notes

⚠️ **NEVER commit credentials to Git!**

## Configuration Methods

### Method 1: Scalr Variables (Recommended for Production)

Configure these variables in **Scalr UI** for your workspace:

| Variable Name | Value Example | Sensitive | Type |
|--------------|---------------|-----------|------|
| `repository_credentials_enabled` | `true` | No | Terraform |
| `repository_url` | `https://gitlab.helmcode.com` | No | Terraform |
| `repository_username` | `gitlab-ci-token` | No | Terraform |
| `repository_password` | `glpat-xxxxx` | **YES** ✅ | Terraform |
| `repository_name` | `gitlab-my-org` | No | Terraform |

**Benefits:**
- ✅ No files to manage locally
- ✅ Variables stored securely in Scalr
- ✅ Easy to rotate tokens
- ✅ No risk of committing secrets
- ✅ Centralized management

### Method 2: Environment Variables (for Local Development)

```bash
export TF_VAR_repository_credentials_enabled=true
export TF_VAR_repository_url="https://gitlab.helmcode.com"
export TF_VAR_repository_username="gitlab-ci-token"
export TF_VAR_repository_password="glpat-YOUR-TOKEN-HERE"
export TF_VAR_repository_name="gitlab-my-org"

terraform apply
```

### Method 3: CLI Variables

```bash
terraform apply \
  -var="repository_credentials_enabled=true" \
  -var="repository_url=https://gitlab.helmcode.com" \
  -var="repository_username=gitlab-ci-token" \
  -var="repository_password=glpat-YOUR-TOKEN-HERE" \
  -var="repository_name=gitlab-my-org"
```

## Creating Tokens

### GitLab Project Access Token (Recommended for Production)

1. Go to your project: `https://gitlab.com/your-org/your-project/-/settings/access_tokens`
2. Create token with:
   - **Name:** `ArgoCD Production`
   - **Role:** `Reporter` (read-only)
   - **Scopes:** ✅ `read_repository`
3. Copy the token → Set as `repository_password` in Scalr (marked as sensitive)

### GitLab Personal Access Token (for Development)

1. Go to: `https://gitlab.com/-/profile/personal_access_tokens`
2. Create token with:
   - **Name:** `ArgoCD Development`
   - **Scopes:** ✅ `read_repository`
3. Copy the token → Use with environment variable `TF_VAR_repository_password`

### GitHub Personal Access Token

1. Go to: `https://github.com/settings/tokens`
2. Create token with `repo` scope
3. Use `username = "oauth2"` and `password = "ghp_YOUR-TOKEN"`

## URL Matching

ArgoCD matches repository URLs using these patterns:

| URL Pattern | Matches |
|------------|---------|
| `https://gitlab.helmcode.com` | All repos under this GitLab instance |
| `https://gitlab.helmcode.com/helmcode` | All repos in `helmcode` group |
| `https://gitlab.helmcode.com/helmcode/customer-assets/foundspot.git` | Only this specific repo |

**Recommendation:** Use the base URL (e.g., `https://gitlab.helmcode.com`) for simplicity.

## Example Configuration

```hcl
module "argocd" {
  source  = "helmcode.scalr.io/environment-a/argocd/k8s"
  version = "1.0.5"

  domain    = "argocd.example.com"
  namespace = "argocd"

  # Repository credentials (configured in Scalr)
  repository_credentials_enabled = var.repository_credentials_enabled
  repository_url                 = var.repository_url
  repository_username            = var.repository_username
  repository_password            = var.repository_password
  repository_name                = var.repository_name

  # Bootstrap ApplicationSet
  bootstrap_applicationset_enabled = true
  bootstrap_repo_url               = "https://gitlab.helmcode.com/org/repo.git"
  bootstrap_repo_path              = "apps/*"
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5 |
| kubernetes | >= 2.0 |
| helm | >= 2.0 |
