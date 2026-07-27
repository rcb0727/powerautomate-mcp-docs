---
name: govern-tenant
description: Administer environments, DLP policies, and tenant capacity. Use for tenant administration, environment lifecycle, DLP policies, capacity, billing, or governance questions.
---

# Tenant governance

## Tools
`list_environments` · `get_environment` · `create/delete/copy/reset/backup/restore_environment` · `list_environment_backups` · `get_environment_capacity` · `get_tenant_capacity` · DLP policy tools · managed environment tools · `list_billing_policies` · `get_api_request_summary`

## Rules for this surface
These tools change tenant-wide state. Before any of them:
1. **Say exactly what will happen and to which environment, by name and ID.** "Reset the dev environment" is not enough — confirm the GUID.
2. `reset_environment` wipes an environment back to factory state. `restore_environment` and `copy_environment` overwrite the target. All three are irreversible from here. Get explicit confirmation.
3. Take a backup first where one is possible (`backup_environment`), and say you did.

## DLP
`list_dlp_policies` then `get_dlp_policy` to read the current state before changing anything. A DLP change can break flows across the tenant immediately — enumerate which connectors move classification and warn about it before writing.

## Capacity
`get_tenant_capacity` and `get_environment_capacity` for storage and API limits; `get_api_request_summary` for consumption against the daily allocation.
