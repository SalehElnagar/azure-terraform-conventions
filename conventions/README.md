# Terraform Infrastructure Conventions

Enterprise-ready Terraform modules that enforce consistent naming, tagging, and metadata conventions for Azure resources. The modules ship with curated mappings for Azure regions, friendly environment names, and baseline corporate tags while still allowing workload teams to extend or override the defaults as required.

## Modules

### `modules/resource`
Generates compliant resource names and tag sets for any Azure resource. Key capabilities include:

- **Deterministic naming** – opinionated label ordering with optional overrides, support for name splitting, and configurable delimiters.
- **Environment awareness** – maps human-readable environments (e.g. `production`, `dev`, `disasterrecovery`) to either full or short forms.
- **Global Azure coverage** – ships with location codes for every generally available Azure region and allows per-consumer overrides.
- **Enterprise tagging** – always emits the corporate baseline tags and can generate contextual tags (namespace, purpose, environment, instance, location).
- **Input validation** – guards against empty or malformed values and surfaces actionable error messages.

#### Input structure

- `naming` *(object, required)* – core identity attributes such as prefix, location, namespace, purpose, environment, optional instance, and attributes.
- `options` *(object, optional)* – behaviours for label ordering, delimiters, sanitisation, and environment handling.
- `overrides` *(object, optional)* – supplemental location and environment maps for bespoke deployments.
- `tags` *(object, optional)* – controls whether contextual tags are emitted and merges user-provided metadata.

Example:

```hcl
module "resource" {
  source = "../../modules/resource"

  naming = {
    prefix      = "kv"
    location    = "switzerland north"
    namespace   = "Example-Digital"
    purpose     = "PlatformVault"
    environment = "production"
    attributes  = ["primary"]
  }

  options = {
    use_short_environment = true
  }

  tags = {
    additional = {
      CostCenter = "12345"
      Owner      = "platform-team@example.org"
    }
  }
}

output "name" {
  value = module.resource.name
}

output "tags" {
  value = module.resource.tags
}
```

To extend the shipped mappings, provide structured overrides:

```hcl
module "resource" {
  # ...
  overrides = {
    locations = {
      "new azure region" = "NAR"
    }

    environments = {
      pilot = "Pilot"
    }

    short_environments = {
      pilot = "PIL"
    }
  }
}
```

### `modules/tags`
Produces a hardened tag map when naming is not required but consistent metadata still is. Supply a single `metadata` object containing the namespace, application, environment, and optional supplemental tags. The module sanitizes inputs, applies the corporate baseline tags, and merges user-provided extras.

```hcl
module "tags" {
  source = "../../modules/tags"

  metadata = {
    namespace   = "Core-Services"
    application = "Telemetry"
    environment = "quality"
    additional  = {
      Owner = "observability-team@example.org"
    }
  }
}
```

## Validation & Error Handling

- Invalid name components (for example, empty strings or symbols) are rejected before Terraform reaches Azure.
- Unsupported Azure regions produce a descriptive error suggesting the use of `overrides.locations`.
- Environments outside of the curated list require the caller to opt-in via `overrides.environments` or `overrides.short_environments`.

## Examples

Consumable examples covering common patterns are available in [`examples/`](./examples). Run `terraform init && terraform plan` inside an example directory to see the generated outputs.

## Development

Format Terraform code with `terraform fmt -recursive` before committing. Unit tests are not included, so prefer exercising a representative example when changing the naming logic.

### Housekeeping script

Use [`scripts/clean.sh`](./scripts/clean.sh) to purge generated Terraform artefacts when you want a fresh working directory:

- Removes all local `*.tfstate` files and their backups.
- Deletes any `*.tfplan` files.
- Recursively clears `.terraform` working directories.

The helper is written in portable Bash and only depends on standard Unix tooling (`find`, `xargs`, and `rm`). Windows engineers can run it via WSL or Git Bash.
