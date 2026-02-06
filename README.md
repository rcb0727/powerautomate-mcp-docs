# Power Automate MCP Server

An MCP (Model Context Protocol) server for Microsoft Power Automate. Create, manage, and deploy Power Automate flows using natural language.

Works with any MCP-compatible AI client: **Claude Desktop**, **Claude Code**, **VS Code Copilot**, **Cursor**, **Google Gemini CLI**, and more.

## Features

- **Create Flows** - Build flows from natural language descriptions with guided wizard
- **Test & Debug** - Automatic testing with intelligent error diagnosis
- **Validate** - Pre-flight checks with best practices scoring (0-100)
- **Manage Flows** - List, update, clone, and delete flows
- **Power Apps** - Manage canvas and model-driven apps, permissions, versions
- **Environment Admin** - Create, copy, backup, restore environments
- **DLP Policies** - Create and manage data loss prevention policies
- **Solutions ALM** - Export, import, and manage Dataverse solutions
- **Dataverse CRUD** - Full table/row operations via OData Web API
- **SharePoint** - Sites, lists, items, and files via Microsoft Graph
- **Expression Help** - Interactive Power Automate expression reference
- **Connector Intelligence** - Full knowledge of 400+ connectors and schemas
- **Cross-Platform** - Works on Windows, macOS, and Linux

## Quick Start

```bash
npm install -g powerautomate-mcp
powerautomate-mcp --setup
```

The setup wizard handles everything automatically:
1. Creates the app registration via Azure CLI (or falls back to a shared app)
2. Opens your browser to sign in
3. Presents the admin consent URL (auto-opens in browser)
4. Discovers your environments and lets you select one
5. Saves your configuration

Then configure your AI client. See the **[Installation Guide](INSTALL.md)** for platform-specific setup:

| Client | Config |
|--------|--------|
| Claude Desktop | `claude_desktop_config.json` |
| Claude Code | `claude mcp add powerautomate` |
| VS Code Copilot | `.vscode/mcp.json` |
| Cursor | `~/.cursor/mcp.json` |
| Gemini CLI | `~/.gemini/settings.json` |
| ChatGPT | `--http` flag + tunnel (see [guide](INSTALL.md#chatgpt-openai)) |

---

## Microsoft Entra App Registration

The setup wizard (`--setup`) creates the app registration automatically if you have Azure CLI installed. No manual steps required for most users.

### Who Needs to Do What?

| Role | Action |
|------|--------|
| Entra ID admin with Azure CLI | Run `powerautomate-mcp --setup` — everything is automated |
| Entra ID admin without Azure CLI | Run `--setup`, it uses a shared app; grant admin consent when prompted |
| Non-admin user | Run `--setup`, then ask an admin (see roles below) to approve the consent URL shown |
| End users (after admin setup) | Just run `powerautomate-mcp --setup` |

### Admin Consent

The setup wizard presents the admin consent URL and auto-opens it in your browser. Any of these Entra ID roles can grant consent: **Global Administrator**, **Application Administrator**, **Cloud Application Administrator**, or **Privileged Role Administrator**. If you don't have one of these roles, share the URL with your admin:

```
https://login.microsoftonline.com/{tenant-id}/adminconsent?client_id=YOUR_CLIENT_ID
```

### Manual Setup (Optional)

If you prefer to create the app registration manually:

1. Go to [Azure Portal](https://portal.azure.com) > **Microsoft Entra ID** > **App registrations** > **New registration**

2. Configure basic settings:
   - **Name**: `Power Automate MCP`
   - **Supported account types**: Accounts in any organizational directory (multi-tenant)
   - **Redirect URI**: Select "Public client/native" and enter:
     ```
     https://login.microsoftonline.com/common/oauth2/nativeclient
     ```

3. After creation, go to **Authentication** and enable:
   - **Allow public client flows**: Yes

4. Go to **API permissions** > **Add a permission** and add:

   | API | Permission | Type | Used For |
   |-----|------------|------|----------|
   | Microsoft Graph | `User.Read` | Delegated | User profile |
   | Microsoft Graph | `Sites.ReadWrite.All` | Delegated | SharePoint sites, lists, files |
   | Microsoft Graph | `Files.ReadWrite.All` | Delegated | OneDrive/SharePoint file operations |
   | Power Automate (Flow Service) | `Flows.Read.All` | Delegated | Read flows |
   | Power Automate (Flow Service) | `Flows.Manage.All` | Delegated | Create/update/delete flows |
   | Dynamics CRM | `user_impersonation` | Delegated | Dataverse table/row CRUD |

5. Click **Grant admin consent for [Your Tenant]** (requires Global Admin, Application Admin, Cloud Application Admin, or Privileged Role Admin)

---

## Usage Examples

```
Create a flow that sends me an email every morning with the weather forecast
```

```
Test my "Daily Report" flow and tell me if there are any errors
```

```
What connectors are available for working with SharePoint?
```

```
Help me write an expression to format a date as "January 1, 2024"
```

## Available Tools (108 total)

### Core Flow Operations
| Tool | Description |
|------|-------------|
| `list_flows` | List flows in an environment |
| `get_flow` | Get full flow definition |
| `create_flow` | Create a new flow |
| `update_flow` | Modify an existing flow |
| `delete_flow` | Delete a flow |
| `toggle_flow` | Enable or disable a flow |
| `clone_flow` | Copy flow to another environment |

### Testing & Debugging
| Tool | Description |
|------|-------------|
| `test_flow` | Run flow with automatic diagnosis |
| `run_flow` | Trigger a manual flow |
| `get_runs` | Get flow run history |
| `diagnose_flow` | Analyze failures with fix suggestions |
| `validate_flow` | Validate with best practices score |

### Planning & Help
| Tool | Description |
|------|-------------|
| `plan_flow` | Interactive flow planning wizard |
| `build_flow` | Simple flow builder from description |
| `get_expression_help` | Expression syntax reference |
| `search_connectors` | Find connectors by name |
| `get_action_schema` | Get connector action parameters |

### Dataverse CRUD
| Tool | Description |
|------|-------------|
| `list_dataverse_tables` | List all tables (entities) in the environment |
| `get_dataverse_table` | Get table schema with column definitions |
| `query_dataverse_rows` | Query rows with OData filter/select/orderby |
| `get_dataverse_row` | Get a single row by ID |
| `create_dataverse_row` | Create a new row |
| `update_dataverse_row` | Update an existing row |
| `delete_dataverse_row` | Delete a row (with confirmation) |

### SharePoint
| Tool | Description |
|------|-------------|
| `search_sharepoint_sites` | Search for SharePoint sites |
| `get_sharepoint_site` | Get site by ID or URL |
| `list_sharepoint_lists` | List all lists in a site |
| `get_sharepoint_list_columns` | Get column definitions for a list |
| `list_sharepoint_items` | Get list items with filtering |
| `create_sharepoint_item` | Create a new list item |
| `update_sharepoint_item` | Update a list item |
| `delete_sharepoint_item` | Delete a list item (with confirmation) |
| `list_sharepoint_files` | List files in a document library |
| `upload_sharepoint_file` | Upload a file (up to 4MB) |
| `get_sharepoint_file_content` | Download file content |

### Power Apps
| Tool | Description |
|------|-------------|
| `list_canvas_apps` | List canvas apps |
| `get_canvas_app` | Get app details |
| `publish_canvas_app` | Publish an app |
| `list_model_driven_apps` | List model-driven apps |
| `get_model_driven_app` | Get model-driven app details |
| `list_app_versions` | List app version history |
| `get_app_permissions` | Get app permissions |
| `share_app` | Share an app with users/groups |
| `remove_app_permission` | Remove app access |
| `set_app_owner` | Transfer app ownership |

### Environment Administration
| Tool | Description |
|------|-------------|
| `list_environments` | List all environments |
| `get_environment` | Get environment details |
| `create_environment` | Create a new environment |
| `delete_environment` | Delete an environment |
| `copy_environment` | Copy an environment |
| `reset_environment` | Reset an environment |
| `backup_environment` | Create a backup |
| `restore_environment` | Restore from backup |

### DLP Policies
| Tool | Description |
|------|-------------|
| `list_dlp_policies` | List data loss prevention policies |
| `get_dlp_policy` | Get policy details |
| `create_dlp_policy` | Create a new DLP policy |
| `update_dlp_policy` | Update an existing policy |
| `delete_dlp_policy` | Delete a policy |
| `list_policy_connectors` | List connectors by policy group |

### Solutions ALM
| Tool | Description |
|------|-------------|
| `list_solutions` | List Dataverse solutions |
| `get_solution` | Get solution details |
| `export_solution` | Export a solution |
| `import_solution` | Import a solution |
| `list_solution_components` | List components in a solution |
| `add_solution_component` | Add a component to a solution |

### Managed Environments & Capacity
| Tool | Description |
|------|-------------|
| `enable_managed_environment` | Enable managed environment |
| `disable_managed_environment` | Disable managed environment |
| `get_governance_settings` | Get governance configuration |
| `get_tenant_capacity` | Get tenant-level capacity |
| `get_capacity_alerts` | Get capacity alert notifications |

## Security

This server implements defense-in-depth security hardened through 3 rounds of penetration testing:

- **Secure Token Storage**: DPAPI (Windows), Keychain (macOS), libsecret (Linux) — no plaintext fallback
- **SSRF Prevention**: Comprehensive private host detection covering IPv4, IPv6, IPv6-mapped/compatible IPv4, octal/hex/decimal notation, ULA, link-local ranges, domain allowlists
- **OData Injection Protection**: Tautology detection across all comparison operators, parenthesized forms, arithmetic/function-based bypasses, Unicode NFC normalization, ASCII-only enforcement
- **Path Traversal Prevention**: NFKC Unicode normalization, bidi control character stripping, zero-width character removal, null byte rejection, URL double-encoding defense
- **Input Validation**: GUID validation on all IDs, field list validation, environment ID format checks, SharePoint hostname allowlist
- **Injection Prevention**: Power Automate expression injection blocking (`@{`/`}@`), command injection prevention (`execFile` over `exec`), prototype pollution defense
- **Error Sanitization**: Recursive sensitive key redaction (tokens, passwords, secrets), PII removal, stack trace suppression
- **Log Redaction**: Deep wildcard Pino redaction for auth headers, tokens, API keys
- **HTTP Transport Security**: Localhost-only binding, session-based Streamable HTTP, timing-safe API key comparison
- **Resource Limits**: 2MB input size limit, 20-level depth limit, 50MB JSON response limit, 100MB binary download limit
- **Config Hardening**: File permissions (0o600), symlink rejection, world-readable warnings
- **Auth Safety**: Token refresh mutex, MSAL PII filtering, MSAL verbose/trace suppression, silent-only mode in server

## Architecture

```
AI Client <--stdio/http--> powerautomate-mcp
(Claude, VS Code,               |
 Cursor, Gemini)                 ├── Power Automate Flow Management API
                                 ├── Power Apps API (canvas/model-driven apps)
                                 ├── Power Platform Admin API (environments, DLP, capacity)
                                 ├── Microsoft Graph API (SharePoint, OneDrive, Excel)
                                 ├── Dataverse Web API (tables, rows, solutions)
                                 ├── MSAL Auth (browser popup / device code)
                                 ├── SQLite Schema Cache (400+ connectors)
                                 └── Secure Token Storage (OS keychain)
```

## License

MIT

## Support

For issues and feature requests, please open an issue in this repository.
