# Terraform quality gates

Recommended baseline before wider reuse:

- `terraform fmt -check`
- `terraform validate`
- static checks such as tflint or checkov where available
- peer review of variables, network exposure and diagnostics
