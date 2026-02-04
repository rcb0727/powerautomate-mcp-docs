# Power Automate MCP Server

An MCP (Model Context Protocol) server that connects Claude to Microsoft Power Automate. Create, manage, and deploy Power Automate flows using natural language.

## Features

- **Create Flows** - Build flows from natural language descriptions with guided wizard
- **Test & Debug** - Automatic testing with intelligent error diagnosis
- **Validate** - Pre-flight checks with best practices scoring (0-100)
- **Manage Flows** - List, update, clone, and delete flows
- **Expression Help** - Interactive Power Automate expression reference
- **Connector Intelligence** - Full knowledge of 400+ connectors and schemas
- **Cross-Platform** - Works on Windows, macOS, and Linux

## Quick Start

### Prerequisites

- Node.js 20+
- Microsoft 365 work account with Power Automate access
- **Linux only**: libsecret for secure token storage
  ```bash
  # Ubuntu/Debian
  sudo apt-get install libsecret-1-dev gnome-keyring

  # Fedora/RHEL
  sudo dnf install libsecret-devel gnome-keyring
  ```

### Installation

```bash
npm install -g powerautomate-mcp
```

### First-Time Setup

```bash
powerautomate-mcp --setup
```

This interactive wizard will:
1. Sign you in via browser
2. Discover your Power Automate environments
3. Create the configuration file

### Register with Claude

Add to your Claude configuration:

**macOS**: `~/Library/Application Support/Claude/claude_desktop_config.json`
**Windows**: `%APPDATA%\Claude\claude_desktop_config.json`
**Linux**: `~/.config/Claude/claude_desktop_config.json`

```json
{
  "mcpServers": {
    "powerautomate": {
      "command": "powerautomate-mcp"
    }
  }
}
```

Restart Claude. The Power Automate tools will appear automatically.

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

## Available Tools (63 total)

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

## Microsoft Entra App Registration (Required)

Before using this MCP server, an Microsoft Entra app registration must be configured in your tenant. This requires **Global Administrator** or **Application Administrator** role.

### Who Needs to Do This?

| Role | Action Required |
|------|-----------------|
| IT Admin / Global Admin | Create app registration, grant admin consent |
| End Users | Just run `powerautomate-mcp --setup` after admin completes setup |

### Option 1: PowerShell Script (Recommended)

```powershell
# Requires: Azure CLI (https://aka.ms/installazurecli)
# Requires: Global Admin or Application Administrator role

az login
./scripts/Register-PublishedApp.ps1
```

The script will:
1. Create the app registration
2. Configure required permissions
3. Output the admin consent URL

### Option 2: Manual Setup

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

5. Click **Grant admin consent for [Your Tenant]** (requires admin role)

### Admin Consent

After creating the app, admin consent is required for users to authenticate:

```
https://login.microsoftonline.com/common/adminconsent?client_id=YOUR_CLIENT_ID
```

Replace `YOUR_CLIENT_ID` with the Application (client) ID from your app registration.

### Update the MCP Server

After creating your app registration, update `src/setup/published-app.ts` with your client ID and rebuild:

```bash
npm run build
```

## Security

This server implements security best practices:

- **Secure Token Storage**: DPAPI (Windows), Keychain (macOS), libsecret (Linux)
- **Input Validation**: OData injection protection, query sanitization
- **Error Sanitization**: PII redacted from logs and error messages
- **No Plaintext Secrets**: Tokens never stored in plaintext

## Development

```bash
# Clone and install
git clone https://github.com/rcb0727/powerautomate-mcp.git
cd powerautomate-mcp
npm install

# Build
npm run build

# Build in watch mode
npm run dev

# Test with MCP Inspector
npm run inspect
```

## Architecture

```
Claude <--stdio/http--> powerautomate-mcp
                            |
                            ├── Power Automate Flow Management API
                            ├── Microsoft Graph API (SharePoint, OneDrive, Excel)
                            ├── Dataverse Web API (tables, rows, solutions)
                            ├── MSAL Auth (browser popup / device code)
                            ├── SQLite Schema Cache (400+ connectors)
                            └── Secure Token Storage (OS keychain)
```

## License

MIT

## Contributing

PRs welcome! See [CLAUDE.md](./CLAUDE.md) for development workflow.
