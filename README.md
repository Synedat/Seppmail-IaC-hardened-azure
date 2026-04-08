# Seppmail-IaC-hardened-azure

> Terraform Infrastructure-as-Code for a hardened SecureMail deployment in Azure.

**Partner resource by Synedat for the SEPPmail ecosystem.**

## Why this repository exists

Starter repository for a hardened Azure landing zone and deployment blueprint for SEPPmail-related workloads.

This repository is structured for public consumption and easy discovery across topics such as SEPPmail, Exchange Online, Microsoft 365, Azure, API automation, PowerShell and operational runbooks.

## Included content

- `main.tf`
- `variables.tf`
- `outputs.tf`
- `terraform.tfvars.example`

## Quick start

1. Use the repository as a hardened starter, not as a drop-in production template.
2. Replace placeholder IP ranges, hostnames, secrets and RBAC scopes.
3. Add organization-specific policy, monitoring and backup controls before live usage.

## Official SEPPmail references

- [Exchange Online configuration](https://docs.seppmail.com/en/09_ht_mso365_06_exchange-online-configuration.html)
- [High availability and load balancing](https://docs.seppmail.com/en/03_wp_03_sa_06_ha__high-availability-loadbalancing.html)

## Publishing notes

- keep repository description and topics aligned with `.github/repository-profile.md`
- add a concise repository subtitle in GitHub
- use consistent Synedat branding across all public SEPPmail repositories
- keep customer-specific values out of the public repository

## About Synedat

Synedat publishes practical, reusable assets around software engineering, IT operations, cloud integration and automation.

- Website: https://www.synedat.com/
- Company profile: https://www.synedat.com/en/

## Partner note

This repository is published by Synedat as a partner-oriented resource for the SEPPmail ecosystem. Product ownership, roadmap and official support remain with SEPPmail.

