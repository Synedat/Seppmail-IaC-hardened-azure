# Seppmail-IaC-hardened-azure

**Public partner repository by Synedat for Terraform-based Azure infrastructure patterns around a hardened SEPPmail SecureMail deployment.**

This repository is intended to host **Terraform Infrastructure-as-Code (IaC)** for a hardened **SEPPmail Secure E-Mail Gateway / SecureMail** deployment in Microsoft Azure.

> [!IMPORTANT]
> This repository currently provides a **public-ready repository scaffold and documentation baseline**. It does **not** yet contain a production deployment module.

## Purpose

The goal of this repository is to provide a clean, partner-grade starting point for Azure deployments that follow security-first infrastructure patterns:

- restricted inbound exposure
- documented network security rules
- role-based access design
- reproducible Terraform structure
- separation of platform, network, and workload concerns
- alignment with official SEPPmail deployment guidance

## Intended scope

A future implementation can cover topics such as:

- Azure resource group layout
- virtual network and subnet design
- network security groups
- public and private IP handling
- hardened access to admin interfaces
- storage and disk configuration
- tagging, diagnostics, and monitoring hooks
- parameterisation for lab, project, and production stages

## Suggested repository structure

```text
.
├── .github/
├── docs/
│   ├── architecture.md
│   ├── references.md
│   └── security-baseline.md
├── examples/
│   └── synedat-partner-lab/
├── modules/
│   ├── network/
│   ├── security/
│   └── vm/
├── CONTRIBUTING.md
├── README.md
└── SECURITY.md
```

## Azure hardening themes

For public documentation and future Terraform modules, the following baseline themes are recommended:

### 1. Restrict inbound SMTP

Where SEPPmail is used with Exchange Online, port 25 should only be reachable from the expected Exchange Online relaying sources or other explicitly approved systems.

### 2. Protect administrative access

Administrative access should be deliberately constrained. Public exposure should be minimised, and management access paths should be documented separately from mail-flow paths.

### 3. Make mail flow explicit

Document which interfaces and security rules are used for:

- inbound mail
- outbound mail
- administrative access
- optional support access
- monitoring or diagnostics

### 4. Keep infrastructure reproducible

Use Terraform modules with clear variables, safe defaults, tagging standards, and environment separation.

## Example Synedat positioning

A concise public partner text for this repository can be:

> *Synedat develops secure, maintainable, and operationally transparent infrastructure patterns for SEPPmail-related Azure environments.*

## Official documentation references

Start with the official SEPPmail documentation before implementing Terraform modules:

- [Spin up a SEPPmail VM in the Azure Portal](https://docs.seppmail.com/en/09_ht_msazure_seppmail_vm_setup.html)
- [Exchange Online Configuration](https://docs.seppmail.com/en/09_ht_mso365_06_exchange-online-configuration.html)
- [Securing the SEPPmail Secure E-Mail Gateway](https://docs.seppmail.com/en/09_ht_tenant_securing-seppmail.html)
- [Network Settings Of The SEPPmail Secure E-Mail Gateway Appliance](https://docs.seppmail.com/en/04_com_06_bc_01_ns_03_network-settings-of-the-seppmail-appliance.html)

## Partner notice

This repository is structured as a **Synedat partner repository** in the SEPPmail ecosystem. It should be presented publicly as complementary implementation guidance, not as a replacement for official vendor product documentation.
