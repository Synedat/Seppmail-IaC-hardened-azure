# Synedat Group GmbH — infra-securemail (PRD)

## Purpose

This repository/module provides **Terraform Infrastructure-as-Code (IaC)** for a **hardened SecureMail deployment** (SEPPmail) in **Production (PRD)** on Microsoft Azure.

The design follows a **“private-by-default”** operating model:

- **No public IPs** on SecureMail or internal components  
- **Azure Firewall** is the **only** public edge component and publishes **SMTP only** via DNAT  
- **Administrative access is private**, via **Azure Bastion (SSH)** and an optional **P2S VPN**  
- **S3 gateway (MinIO)** is private and reachable only from approved subnets (DMZ/Mgmt/VPN)

This module is intended to be a **repeatable, auditable, operations-ready PRD blueprint** for SecureMail within Synedat’s infrastructure portfolio.

---

## About Synedat Group GmbH

**Synedat Group GmbH** builds and operates **modern, secure, and compliant IT platforms** with a strong focus on:

- **Cloud & Platform Engineering** (Azure, Kubernetes, GitOps, Terraform IaC)
- **Security-by-Design** (segmentation, least privilege, private endpoints, hardened access paths)
- **Operational excellence** (repeatable deployments, traceability, logging/monitoring, controlled change & rollback)
- **Standardization & reuse** (modular infrastructure building blocks and environment separation)

`infra-securemail` reflects these principles by enforcing **minimal external exposure**, **strong network boundaries**, and **clean operational patterns** (Bastion/VPN access, centralized edge via Firewall, Terraform state bootstrap).

---

## Target Security Goals

1) **SecureMail VM is not directly reachable from the Internet**  
   - Private VM (no Public IP) in DMZ subnet.

2) **Only SMTP ingress is exposed — via Azure Firewall DNAT**  
   - Published ports:
     - **25 (SMTP)**
     - **465 (SMTPS)**
     - **587 (Submission)**

3) **Admin access remains private**  
   - **Azure Bastion + SSH** (default)
   - Optional **P2S VPN** for direct private web access (admin UI) if required.

4) **S3 gateway (MinIO) is private**  
   - Reachable only from DMZ/Mgmt/VPN networks (no public exposure).

---

## Default Network Topology

**VNet:** `10.60.0.0/16`

| Subnet | CIDR | Purpose |
|---|---:|---|
| DMZ | `10.60.10.0/24` | SecureMail VM(s) |
| Mgmt (reserved) | `10.60.20.0/24` | Management workloads / future tooling |
| S3 | `10.60.30.0/24` | MinIO gateway |
| AzureFirewallSubnet | `10.60.3.0/26` | Azure Firewall (public edge) |
| AzureBastionSubnet | `10.60.3.64/26` | Azure Bastion (admin access) |
| (Optional) GatewaySubnet | `10.60.3.128/27` | P2S VPN Gateway |

**Traffic model (high level)**  
- Internet → **Azure Firewall Public IP** → DNAT → **SecureMail private IP (DMZ)**  
- Admin → Bastion → SSH → SecureMail  
- Optional: Admin → P2S VPN → private access to admin UI and internal endpoints

---

## Operating Without Exposing the Admin UI (Recommended)

If `enable_https_admin=false` (recommended), the SecureMail admin UI is **not directly reachable** over network paths. You can still manage the system securely via Bastion and an SSH tunnel.

### Option A — Bastion + SSH + Tunnel (recommended)

1) Connect to the VM via **Azure Bastion** (SSH).  
2) Create a local tunnel (from a host that can reach the VM privately, e.g., via Bastion/VPN):

```bash
ssh -L 8443:localhost:443 <user>@<vm-private-ip>
```

3) Open in your browser:

- `https://localhost:8443`

**Why this approach:**  
- Avoids exposing administrative web ports  
- Minimizes attack surface  
- Provides strong auditability via Bastion access logs and network controls

### Option B — P2S VPN for direct private browser access

If you need direct browser access without tunneling:
- Enable the optional **P2S VPN**
- Add your client pool to `vpn_client_address_pool`
- Access the admin UI via private IP/FQDN from the VPN

---

## SMTP “Encrypted Only to the Outside” — What Network Can vs. Software Must Do

**Network controls** can restrict reachability to **25/465/587** only.  
**Encryption enforcement** is done by the SecureMail software (MTA/policy engine).

### Inbound

- Port 25 typically uses **STARTTLS** (cannot force all senders to support TLS).
- You can enforce “TLS required” per partner domain and improve posture via:
  - **MTA-STS**
  - **DANE (TLSA)** where applicable

### Outbound

- Configure outbound policies to **require TLS** and reject downgrade/fallback for domains where compliance requires strict transport security.

---

## Terraform Backend / State (PRD)

`environments/prd/backend.hcl` is configured for an **Azure Storage backend**.

**Important**
- `storage_account_name` must be **globally unique** across Azure.
- If the chosen name already exists elsewhere, update `backend.hcl`.

### PRD Pipeline Bootstrap

The PRD pipeline bootstraps backend resources if missing:
- Backend Resource Group
- Storage Account
- Container

This prevents common failures such as:
- **404 ResourceGroupNotFound** (backend RG not created yet)
- Backend created in the wrong subscription/context

---

## Deploy (PRD)

1) Fill `environments/prd/terraform.tfvars` (especially `admin_ssh_public_key`).  
2) Run the PRD pipeline:

- `pipelines/azure-pipelines-prd.yml`

---

## What Changed vs. Earlier Version (Implementation Notes)

- Fixed invalid Terraform syntax in variable blocks (no commas / no broken multiline strings)
- Removed accidental duplicate NSG rules
- Avoided the “Azure CLI auth only supported as User” issue by exporting `ARM_*` **OIDC** environment variables in the pipeline
- Avoided backend RG 404 by bootstrapping backend resources in the selected subscription

---

## Operational Recommendations (PRD Readiness)

For production readiness, the following is strongly recommended:

- **Logging & monitoring**
  - Azure Firewall logs, Bastion logs, VM logs (and SecureMail application logs) centralized to your logging stack
- **Secrets & key management**
  - Store secrets/keys in **Azure Key Vault**
  - Keep pipeline permissions minimal (least privilege)
- **Patching & lifecycle**
  - OS patch process + SecureMail software maintenance windows
  - Documented rollback procedure
- **Backup / restore**
  - VM disk backups / snapshots
  - Config backups
  - MinIO data/policy backups (if used)
- **Change & release governance**
  - PR-based changes, mandatory reviews, tagging/releases
  - “break-glass” process documented and controlled
