# Azure Terraform Convention Modules and Resource Modules

This repository provides a cohesive, Azure‑focused set of Terraform modules and a small conventions library that standardizes naming and tagging across all Azure resources. It helps any Azure module author adopt consistent, policy‑friendly names and tags with minimal effort.

What you get:
- Conventions library for Azure
  - `conventions/modules/common`: Canonical maps for Azure regions and environments
  - `conventions/modules/resource`: Deterministic resource name builder for Azure resources
  - `conventions/modules/resource_group`: Opinionated Azure Resource Group naming
  - `conventions/modules/tags`: Consistent Azure tag generation from minimal metadata
- Azure modules ready to use
  - Networking (Virtual Network, VPN Gateway, Application Gateway, NAT Gateway, Load Balancers, Azure Firewall, peering)
  - Compute (Linux VM, Windows VM, VM Scale Set)
  - Containers (AKS cluster wrapper, Container Registry helper)
  - Database (Azure SQL Server)
  - Utilities (Azure cloud/location helpers, remote state bootstrap, resource ID parser)

Why it matters for Azure
- Predictable Azure resource names unlock easier governance (Azure Policies), cost allocation (tags), automation (role assignments, RG scoping), and operational consistency.
- Short, canonical Azure region codes and environment codes avoid drift from raw Azure strings, while allowing overrides for your tenant.
- Modules apply Azure‑ready naming and tagging by default and expose the normalized values for downstream use.

How to use
1. Add conventions once per stack:
   - Use `conventions/modules/tags` to generate a baseline Azure tag map.
   - Use `conventions/modules/resource_group` and `conventions/modules/resource` to produce Azure‑compliant names.
2. Plug the generated names/tags into the Azure resource modules in this repo or your own modules.
3. Use the examples under each module’s `examples/` (Terragrunt) to get started quickly.

Terragrunt examples
Each module includes `examples/basic/terragrunt.hcl` with minimal inputs. Point `terraform.source` to the module path and supply Azure‑specific inputs (location, namespace, environment, etc.).

Contributing Azure modules
- Keep inputs structured (objects for naming/metadata) and validate aggressively.
- Use the conventions modules for all Azure names and tags.
- Document Azure‑specific behavior (regions, SKU constraints, limits) in the module README.

