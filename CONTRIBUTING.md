# Contributing

This repository is intended for public-safe infrastructure guidance and Terraform-ready structure.

## Expected contribution types

- architecture notes
- Terraform module structure
- example variable files with placeholders only
- hardening notes
- documentation improvements

## Public-safe rules

Do not commit:

- customer subscriptions or tenant IDs
- real public IPs, certificates, or secrets
- customer hostnames
- project-specific diagrams that should remain private

## Style

- prefer small, reusable modules
- document every exposed port and security rule
- keep examples generic
- explain production assumptions explicitly
