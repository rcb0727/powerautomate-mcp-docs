# Power Platform MCP Server

**Docs:** **Overview** · [Installation & Upgrading](https://github.com/rcb0727/powerautomate-mcp-docs/blob/main/INSTALL.md) · [Changelog](https://github.com/rcb0727/powerautomate-mcp-docs/blob/main/CHANGELOG.md) · [Report an issue](https://github.com/rcb0727/powerautomate-mcp-docs/issues)

An MCP (Model Context Protocol) server for Microsoft Power Platform — **188 tools** spanning Power Automate flows, canvas app authoring, model-driven apps, SharePoint, Excel, Dataverse/Dynamics 365, Power Pages, and tenant administration. Build, run, diagnose, and govern automations in natural language.


Works with any MCP-compatible AI client: **Claude Desktop**, **Claude Code**, **VS Code Copilot**, **Cursor**, **Google Gemini CLI**, and more.

## Documentation Map

| Page | What you'll find |
|------|------------------|
| **README** (this page) | [Features](#features) · [Quick Start](#quick-start) · [App Registration](#microsoft-entra-app-registration) · [CLI Reference](#cli-reference) · [How It Works](#how-it-works) · [All 188 Tools](#available-tools-188-total) · [Security](#security) · [Architecture](#architecture) |
| [Installation Guide](https://github.com/rcb0727/powerautomate-mcp-docs/blob/main/INSTALL.md) | [Choose your path](https://github.com/rcb0727/powerautomate-mcp-docs/blob/main/INSTALL.md#choose-your-path) · [Easy Path](https://github.com/rcb0727/powerautomate-mcp-docs/blob/main/INSTALL.md#easy-path-3-steps) · [Fast Path](https://github.com/rcb0727/powerautomate-mcp-docs/blob/main/INSTALL.md#fast-path-developers) · [Connect your AI app](https://github.com/rcb0727/powerautomate-mcp-docs/blob/main/INSTALL.md#connecting-your-ai-app) · [**Updating**](https://github.com/rcb0727/powerautomate-mcp-docs/blob/main/INSTALL.md#updating) · [Troubleshooting](https://github.com/rcb0727/powerautomate-mcp-docs/blob/main/INSTALL.md#troubleshooting) · [Glossary](https://github.com/rcb0727/powerautomate-mcp-docs/blob/main/INSTALL.md#glossary) · [Admin & enterprise](https://github.com/rcb0727/powerautomate-mcp-docs/blob/main/INSTALL.md#admin--enterprise-setup) |
| [Changelog](https://github.com/rcb0727/powerautomate-mcp-docs/blob/main/CHANGELOG.md) | Release history with per-version upgrade notes |
| [Privacy Policy](https://github.com/rcb0727/powerautomate-mcp-docs/blob/main/PRIVACY.md) | What runs locally, what talks to Microsoft, what we collect (nothing) |
| [Issues](https://github.com/rcb0727/powerautomate-mcp-docs/issues) | Bug reports and feature requests — every one gets read |

## Features

**188 tools, 22 groups — everything at a glance** (full list with descriptions: [Available Tools](#available-tools-188-total)):

| | | |
|---|---|---|
| **Setup & Authentication** (1) | **Core Flow Operations** (11) | **Testing & Debugging** (9) |
| **Planning & Help** (5) | **Connections & Custom Connectors** (8) | **Approvals** (3) |
| **Dataverse CRUD** (7) | **SharePoint** (11) | **Excel** (2) |
| **Power Apps** (12) | **Canvas App Authoring (Preview)** (13) | **Model-driven Apps** (13) |
| **Power Apps Administration** (4) | **Power Pages Configuration** (9) | **Power Pages Management** (36) |
| **Power Pages PAC CLI** (8) | **Environment Administration** (10) | **DLP Policies** (6) |
| **Solutions ALM** (8) | **Managed Environments & Capacity** (6) | **Desktop Flows / RPA** (3) |
| **Billing & AI Builder** (3) | | |


Beyond the tool count:

- **Natural-language flow building** — describe the automation; `plan_flow` gathers the specifics, `build_flow` creates it (even before its connections are configured), and pre-flight validation scores it against best practices (0–100)
- **Real diagnosis, not error dumps** — failed runs are drilled to the failing step with the actual API error and a proposed fix
- **Complete model-driven app lifecycle** — create AppModules, add or remove components, validate, publish, and manage security-role access through documented Dataverse operations
- **Canvas source authoring (preview)** — create and edit supported `.pa.yaml` source, discover live controls/APIs/data sources, synchronize from Studio, and compile back through Microsoft's official Canvas Authoring MCP server
- **Power Pages from content to hosting** — edit Dataverse configuration, provision and poll websites, manage domains/certificates/WAF/security, and run supported `pac pages` deployment workflows
- **Real Solution ALM** — asynchronous solution export/import, component add/remove, clone, and publish-all operations use documented Dataverse actions instead of placeholders
- **Sign in from the chat** — the `sign_in` tool completes Microsoft device-code auth without a terminal; every action runs under your own work account
- **Everything annotated** — all 188 tools declare read-only/destructive hints, so AI hosts can apply the right guardrails
- **Cross-platform** — Windows, macOS, and Linux

## Quick Start

Three commands — run them in a terminal:

```bash
npm install -g powerautomate-mcp   # 1. install
powerautomate-mcp --setup          # 2. sign in + connect your AI app
powerautomate-mcp --doctor         # 3. confirm everything works
```

The `--setup` wizard does it all: lets you choose a least-privilege permission set, creates the Entra app registration (or takes one you provide), signs you in, handles admin consent, picks your environment, **and wires the server into your AI app for you** — no hand-editing JSON. Then restart your app and ask it to build a flow.

**Not very technical?** Follow the step-by-step **[Easy Path](https://github.com/rcb0727/powerautomate-mcp-docs/blob/main/INSTALL.md#easy-path-3-steps)** with checkpoints.

| Want to… | Do this |
|----------|---------|
| Connect a specific app during setup | `powerautomate-mcp --setup --client claude` |
| Connect an app later (or a second one) | `powerautomate-mcp --client cursor` |
| Skip the global install | `npx -y powerautomate-mcp@latest --setup` (add `--npx` so your app uses npx too) |
| Configure your app by hand | [Manual client configs](https://github.com/rcb0727/powerautomate-mcp-docs/blob/main/INSTALL.md#connect-your-ai-app-manually) |

Supported apps: **Claude Desktop**, **Claude Code**, **Cursor**, **VS Code (Copilot)**, **Gemini CLI**, **Windsurf**, **ChatGPT** (via `--http`).

---

## Microsoft Entra App Registration

The setup wizard (`--setup`) creates the app registration automatically if you have Azure CLI installed. No manual steps required for most users.

> **New tenants work too** (v0.13.0+): if your tenant has never used Power Platform, setup creates the missing first-party service principals and resolves the permission ids your tenant actually publishes — the old `AADSTS650052` / `AADSTS65006` sign-in failures repair themselves on a re-run of `--setup`.

### Who Needs to Do What?

| Role | Action |
|------|--------|
| Entra ID admin with Azure CLI | Run `powerautomate-mcp --setup` — everything is automated |
| Entra ID admin without Azure CLI | Run `--setup`, paste your app's Client ID when prompted, grant admin consent |
| Non-admin user | Run `--setup`, then ask an admin (see roles below) to approve the consent URL shown |
| End users (after admin setup) | Just run `powerautomate-mcp --setup` |

> **Tip:** You can also set `PA_MCP_CLIENT_ID` as an environment variable to skip the prompt entirely.

### Admin Consent

When the Azure CLI is signed in as an admin, the wizard offers to grant tenant-wide consent directly (v0.13.0+) — no browser round-trip. Otherwise it presents the admin consent URL and auto-opens it in your browser. Any of these Entra ID roles can grant consent: **Global Administrator**, **Application Administrator**, **Cloud Application Administrator**, or **Privileged Role Administrator**. If you don't have one of these roles, share the URL with your admin:

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

4. Go to **API permissions** > **Add a permission** and add only the permissions for the tool surfaces you want to enable. The setup wizard offers presets for **All tool surfaces**, **Power Automate only**, **Power Automate + connectors**, **Dataverse**, **Power Pages**, and **Custom**.

   | API | Permission | Type | Used For |
   |-----|------------|------|----------|
   | Power Automate (Flow Service) | `Flows.Read.All` | Delegated | Read flows |
   | Power Automate (Flow Service) | `Flows.Manage.All` | Delegated | Create/update/delete flows |
   | Power Automate (Flow Service) | `Activity.Read.All` | Delegated | Flow run history |
   | Power Automate (Flow Service) | `Approvals.Manage.All` | Delegated | Approval management |
   | Microsoft Graph | `User.Read`, `Sites.ReadWrite.All`, `Files.ReadWrite.All` | Delegated | Optional: SharePoint, OneDrive, and Excel helpers |
   | PowerApps Service | `User` | Delegated | Optional: connections, connector metadata, custom connectors, and Power Apps maker APIs |
   | BAP Admin API | `user_impersonation` | Delegated | Optional: admin tools, Dataverse URL discovery, and Power Pages configuration |
   | Dynamics CRM | `user_impersonation` | Delegated | Optional: Dataverse table/row CRUD and Power Pages configuration |
   | Power Platform API | delegated permission | Delegated | Optional: Power Pages **site management** (Tier 2 — see note below) |

   > **Least privilege:** Power Automate-only setups need only the Flow Service permissions. Skipped feature scopes are saved in `features.enabled`, hidden from the advertised MCP tool list, and skipped by `--doctor` / `--validate`.

   > **Dataverse and admin tools** require the BAP Admin API delegated permission (appId `0e0bf3cc-3078-4fd4-9ef3-cb6dc0245b10`). Without it, the server cannot resolve the real Dataverse org URL and falls back to a guessed `*.crm.dynamics.com` hostname that often fails DNS.

   > **Power Pages site-management tools (Tier 2)** call `https://api.powerplatform.com` and need the "Power Platform API" delegated permission (appId `8578e004-a5c6-46e7-913e-12f58912df43`). It is **not** added by the automatic `--setup` app creation because that API exposes only feature-scoped permissions and the auto-creator can't safely guess the scope. Add it manually here if you want Tier 2; the Power Pages **config** tools (Dataverse) work without it. After adding, re-run `--setup` — the wizard reports whether the Power Platform API authorized.

5. Click **Grant admin consent for [Your Tenant]** (requires Global Admin, Application Admin, Cloud Application Admin, or Privileged Role Admin)

---

## CLI Reference

```
powerautomate-mcp [options]
```

| Flag | Description |
|------|-------------|
| `--setup`, `-s` | Run the interactive setup wizard (signs in + connects your AI app) |
| `--login` | Sign in again using your existing setup — no wizard (expired tokens, MFA/policy changes) |
| `--doctor` | Check your setup and print exactly what to fix, then exit |
| `--validate` | Verify config, auth, and API connectivity then exit |
| `--client <name>` | Wire an AI app's config to this server, then exit (`claude`, `claude-code`, `codex`/`chatgpt`, `cursor`, `vscode`, `gemini`, `windsurf`) |
| `--npx` | With `--setup`/`--client`, configure the app to run via `npx` (no global install) |
| `--update` | Check for updates and install the latest version |
| `--version`, `-v` | Print version and exit |
| `--http` | Start with Streamable HTTP transport |
| `--port <N>` | Port for HTTP transport (default: 3000) |
| `--env <name>` | Override the default environment (alias or GUID) |
| `--config <path>` | Use an alternate config file |
| `--debug` | Enable debug-level logging |
| `--help`, `-h` | Show help message |

**Environment Variables:**
| Variable | Description |
|----------|-------------|
| `PA_MCP_CLIENT_ID` | Microsoft Entra app client ID (overrides config file; with `PA_MCP_ENVIRONMENT_ID`, bootstraps a full config when no config.json exists — lets a host application supply configuration without a config file) |
| `PA_MCP_TENANT_ID` | Microsoft Entra tenant ID or domain (overrides config file) |
| `PA_MCP_ENVIRONMENT_ID` | Power Platform environment ID for the env-var config bootstrap |
| `PA_MCP_ENVIRONMENT_REGION` | Azure region for the bootstrapped environment (default `unitedstates`) |
| `PA_CONFIG_PATH` | Custom path to config.json |
| `PA_MCP_HTTP_TOKEN` | With `--http`: require `Authorization: Bearer <token>` on every MCP request. Protects the HTTP endpoint itself (the tools run with *your* signed-in account) — required whenever the server is exposed beyond your own machine. See [Installation → ChatGPT](INSTALL.md) |

---

## How It Works

<p align="center">
  <img src="images/how-it-works.svg?v=188b" alt="PowerPlatform MCP — architecture flow, three example scenarios (simple, moderate, complex), and execution phases" width="700" />
</p>

---

### Canvas source authoring (preview)

Canvas source authoring uses Microsoft's official prerelease Canvas Authoring MCP as an isolated child process. Install the [.NET 10 SDK](https://dotnet.microsoft.com/download/dotnet/10.0), open an existing blank or editable canvas app in Power Apps Studio, enable **Settings → Updates → Coauthoring**, and keep that Studio tab open. Then call `connect_canvas_authoring` with the Studio Designer URL before using discovery, sync, or compile tools.

The AI assistant creates or edits `App.pa.yaml` and one `.pa.yaml` file per screen, using live control/API/data-source metadata and `compile_canvas_source` for supported validation and live synchronization. Compilation changes the open draft, so it requires `confirm=true`. `sync_canvas_source` can overwrite local source and also requires confirmation. The preview does **not** provision the initial cloud app shell, add Studio data connections, save, or publish; those remain Power Apps Studio steps. See Microsoft's [external-tools preview guide](https://learn.microsoft.com/en-us/power-apps/maker/canvas-apps/create-canvas-external-tools) and [Power Apps YAML reference](https://learn.microsoft.com/en-us/power-apps/maker/canvas-apps/power-apps-yaml).

### More Example Prompts

<details>
<summary>Flows</summary>

```
Create a flow that sends me an email every morning with the weather forecast
```
```
Test my "Daily Report" flow and tell me if there are any errors
```
```
Help me write an expression to format a date as "January 1, 2024"
```
```
Show me all the flows that have been shared with me
```
```
Patch the "Compose" action inside the Default case of "If_Recognized_Form" — only that one node, leave the rest alone
```

</details>

<details>
<summary>SharePoint</summary>

```
List all items in the "Projects" list on our Marketing site
```
```
Upload this month's report to the Shared Documents library
```

</details>

<details>
<summary>Dataverse</summary>

```
Show me all active accounts in Dataverse with revenue over $1M
```
```
Create a new contact row for John Smith in the contacts table
```

</details>

<details>
<summary>Power Apps</summary>

```
List all canvas apps in my environment and who owns them
```
```
Share the "Expense Tracker" app with the Finance team
```

</details>

<details>
<summary>Administration (requires Power Platform Admin, Dynamics 365 Admin, or Global Admin)</summary>

```
Create a new sandbox environment called "Dev Testing"
```
```
What DLP policies are applied to my default environment?
```
```
Export the "Sales Solution" as a managed solution for deployment
```

</details>

<details>
<summary>Connectors & Expressions</summary>

```
What connectors are available for working with SharePoint?
```
```
What parameters does the "Send an email (V2)" action need?
```

</details>

<p align="right"><a href="#power-automate-mcp-server">↑ Back to top</a></p>

---

## Available Tools (188 total)

> Every tool the server exposes, grouped by service. All 188 are listed here.

<details>
<summary><strong>Setup & Authentication</strong> (1 tools)</summary>

| Tool | Description |
|------|-------------|
| `sign_in` | Sign in to Microsoft Power Platform when other tools report missing credentials. Starts Microsoft's… |

</details>

<details>
<summary><strong>Core Flow Operations</strong> (11 tools)</summary>

| Tool | Description |
|------|-------------|
| `list_flows` | List Power Automate flows in an environment. Returns flow names, IDs, state (Started/Stopped), last… |
| `get_flow` | Get the complete definition of a Power Automate flow including triggers, actions, connection referen… |
| `create_flow` | Create a new Power Automate flow. Provide a trigger, actions, and connection references. Use search_… |
| `update_flow` | Update an existing Power Automate flow. Three update modes: (1) full replace — pass 'actions' to rep… |
| `delete_flow` | Delete a Power Automate flow permanently. This action cannot be undone. You must set confirm=true to… |
| `toggle_flow` | Enable or disable a Power Automate flow. Use 'start' to enable a stopped flow or 'stop' to disable a… |
| `clone_flow` | Clone an existing Power Automate flow to create a copy with a new name. Optionally update connection… |
| `export_flow` | Export a flow as a package. Returns the flow definition and metadata that can be used to import into… |
| `share_flow` | Share a flow with users, groups, or service principals. Grant them either 'CanEdit' (can modify the… |
| `get_flow_permissions` | Get the list of users, groups, and service principals that have access to a flow. Shows their role (… |
| `list_flow_versions` | List all versions of a flow. Each version represents a saved state of the flow definition. Use this… |

</details>

<details>
<summary><strong>Testing & Debugging</strong> (9 tools)</summary>

| Tool | Description |
|------|-------------|
| `test_flow` | Test a Power Automate flow with guided feedback. This tool: 1. Gets the flow's expected input schema… |
| `run_flow` | Trigger a Power Automate flow to run immediately. Works with any trigger type (manual, scheduled, ev… |
| `get_runs` | Get the execution history of a Power Automate flow. Shows run times, status (Succeeded/Failed/Runnin… |
| `get_run_actions` | Get detailed action-level information for a flow run. Shows each action's status, timing, inputs/out… |
| `get_run_action_repetitions` | Get iteration-level details for a for_each or do_until loop action in a flow run. Shows which iterat… |
| `diagnose_flow` | Diagnose issues with a Power Automate flow. Analyzes recent runs, identifies failures, and provides… |
| `validate_flow` | Validate a Power Automate flow definition for errors. Can validate either an existing flow by ID or… |
| `resubmit_run` | Resubmit a failed or cancelled flow run. This will re-execute the flow with the same trigger inputs.… |
| `cancel_run` | Cancel a currently running flow execution. Use this to stop a flow that is taking too long or runnin… |

</details>

<details>
<summary><strong>Planning & Help</strong> (5 tools)</summary>

| Tool | Description |
|------|-------------|
| `plan_flow` | Interactive flow planning wizard. Call this FIRST when user wants to create or build a flow. IMPORTA… |
| `build_flow` | Build a Power Automate flow from a description. RECOMMENDED: Use plan_flow FIRST to gather requireme… |
| `get_expression_help` | Get help with Power Automate expressions. Provides: - Common functions reference by category - Conte… |
| `search_connectors` | Search for Power Automate connectors by name, description, or category. Returns matching connectors… |
| `get_action_schema` | Get the schema and parameters for a connector's actions/triggers. Use search_connectors first to fin… |

</details>

<details>
<summary><strong>Connections & Custom Connectors</strong> (8 tools)</summary>

| Tool | Description |
|------|-------------|
| `list_connections` | List all connections in an environment. Shows connection names, statuses (Connected/Error), connecto… |
| `list_custom_connectors` | List all custom connectors in the environment. Shows connector names, IDs, and operation counts. |
| `get_custom_connector` | Get detailed information about a custom connector including its OpenAPI definition and all operation… |
| `create_custom_connector` | Create a custom connector for any REST API. Define the base URL, authentication, and operations. Eac… |
| `update_custom_connector` | Update a custom connector. Add or remove operations, or change the display name and description. |
| `delete_custom_connector` | Delete a custom connector. Requires confirm=true to proceed. |
| `plan_custom_connector` | Get guidance on creating a custom connector. Describes what information you need to gather about you… |
| `import_openapi_connector` | Create a custom connector by importing an OpenAPI/Swagger specification. Provide the full spec and a… |

</details>

<details>
<summary><strong>Approvals</strong> (3 tools)</summary>

| Tool | Description |
|------|-------------|
| `list_approvals` | List pending approvals in the environment. Shows approval requests that are waiting for a response. |
| `list_approvals_dataverse` | List pending approval requests from Dataverse. More reliable than the Flow API for approvals. Shows… |
| `respond_approval` | Respond to a pending approval request. Use 'Approve' to approve or 'Reject' to reject the request. |

</details>

<details>
<summary><strong>Dataverse CRUD</strong> (7 tools)</summary>

| Tool | Description |
|------|-------------|
| `list_dataverse_tables` | List Dataverse tables (entities) in the environment. Returns table names, entity set names, and whet… |
| `get_dataverse_table` | Get detailed metadata for a Dataverse table including all column definitions. Provide the table's lo… |
| `query_dataverse_rows` | Query rows from a Dataverse table with OData filtering, selecting, and ordering. Use list_dataverse_… |
| `get_dataverse_row` | Get a single Dataverse row by its ID. Returns all fields or selected fields for the specified row. |
| `create_dataverse_row` | Create a new row in a Dataverse table. Use get_dataverse_table first to see available columns and re… |
| `update_dataverse_row` | Update an existing Dataverse row. Only include fields you want to change. The row must exist. |
| `delete_dataverse_row` | Delete a Dataverse row permanently. This action cannot be undone. You must set confirm=true to proce… |

</details>

<details>
<summary><strong>SharePoint</strong> (11 tools)</summary>

| Tool | Description |
|------|-------------|
| `search_sharepoint_sites` | Search for SharePoint sites by name or keyword. Returns site IDs, names, and URLs. Use the site ID i… |
| `get_sharepoint_site` | Get a SharePoint site by its ID or by hostname and path. Returns site details including name, URL, a… |
| `list_sharepoint_lists` | List all lists and libraries in a SharePoint site. Returns list IDs, names, and types. Use the list… |
| `get_sharepoint_list_columns` | Get column definitions for a SharePoint list. Shows column names, types, and whether they are requir… |
| `list_sharepoint_items` | Get items from a SharePoint list with optional filtering and sorting. Returns item IDs, field values… |
| `create_sharepoint_item` | Create a new item in a SharePoint list. Use get_sharepoint_list_columns first to see available field… |
| `update_sharepoint_item` | Update an existing SharePoint list item. Only include fields you want to change. |
| `delete_sharepoint_item` | Delete a SharePoint list item permanently. This action cannot be undone. You must set confirm=true t… |
| `list_sharepoint_files` | List files in a SharePoint document library. Use list_sharepoint_lists first to find document librar… |
| `upload_sharepoint_file` | Upload a file to a SharePoint document library. Simple upload supports files up to 4MB. Provide the… |
| `get_sharepoint_file_content` | Download a file's content from a SharePoint document library. Returns base64-encoded content for tex… |

</details>

<details>
<summary><strong>Excel (OneDrive)</strong> (2 tools)</summary>

| Tool | Description |
|------|-------------|
| `search_excel_files` | Search for Excel files in OneDrive by name. Returns matching files with their IDs and paths. |
| `inspect_excel_file` | Inspect an Excel file to find tables and columns. Use search_excel_files first to find the file ID. |

</details>

<details>
<summary><strong>Power Apps</strong> (12 tools)</summary>

| Tool | Description |
|------|-------------|
| `list_powerapps` | List Power Apps canvas apps in an environment. Returns app names, IDs, owners, and last modified dat… |
| `list_canvas_apps` | List Power Apps canvas apps stored in Dataverse. Shows app names, versions, and status. |
| `get_powerapp` | Get detailed information about a Power App including owner, connections, and app URIs. |
| `publish_powerapp` | Publish a Power App to make the latest version available to users. |
| `get_powerapp_versions` | Get version history for a Power App. Shows all saved versions with dates. |
| `restore_powerapp_version` | Restore a Power App to a previous version. |
| `get_powerapp_permissions` | Get the list of users, groups, and service principals that have access to a Power App. |
| `share_powerapp` | Share a Power App with a user, group, or service principal. Grant CanEdit or CanView permissions. |
| `unshare_powerapp` | Remove a user or group's access to a Power App. |
| `set_powerapp_owner` | Transfer ownership of a Power App to another user. Requires Power Platform admin role. |
| `set_powerapp_display_name` | Change the display name of a Power App. |
| `delete_powerapp` | Delete a Power App permanently. This action cannot be undone. Set confirm=true to proceed. |

</details>

<details>
<summary><strong>Canvas App Authoring (Preview)</strong> (13 tools)</summary>

| Tool | Description |
|------|-------------|
| `connect_canvas_authoring` | Connect the preview Canvas authoring service to an existing app whose Power Apps Studio tab is open… |
| `list_canvas_controls` | List controls supported by the connected Canvas authoring session. |
| `describe_canvas_control` | Describe one Canvas control and its authoring properties. |
| `list_canvas_apis` | List connector APIs visible to the connected Canvas authoring session. |
| `describe_canvas_api` | Describe one connector API visible to the connected Canvas app. |
| `list_canvas_data_sources` | List data sources already present in the connected Canvas app. |
| `get_canvas_data_source_schema` | Get the schema of a data source already present in the connected Canvas app. |
| `sync_canvas_source` | Sync the connected live Canvas app into an existing local source directory. This can overwrite local… |
| `compile_canvas_source` | Compile the local .pa.yaml workspace into the connected live Canvas app. This is a destructive tenan… |
| `list_canvas_source_files` | List safe .pa.yaml files in an existing local Canvas source directory, including size and SHA-256. |
| `read_canvas_source_file` | Read one safe UTF-8 .pa.yaml file (maximum 1 MiB) and return its content, size, and SHA-256. |
| `write_canvas_source_file` | Create one safe UTF-8 .pa.yaml file (maximum 1 MiB). Existing files are preserved unless overwrite=t… |
| `delete_canvas_source_file` | Delete one safe local .pa.yaml file. Requires confirm=true; expectedSha256 can prevent deleting a ch… |

</details>

<details>
<summary><strong>Model-driven Apps</strong> (13 tools)</summary>

| Tool | Description |
|------|-------------|
| `list_model_driven_apps` | List published or unpublished model-driven Power Apps from Dataverse, including AppModule IDs and un… |
| `get_model_driven_app` | Get a model-driven app's published or unpublished AppModule record. Optionally includes the complete… |
| `create_model_driven_app` | Create a real model-driven AppModule in Dataverse. This creates the app shell; add components, valid… |
| `update_model_driven_app` | Update supported properties on a published model-driven AppModule, creating unpublished changes. A n… |
| `delete_model_driven_app` | Permanently delete a model-driven AppModule. Requires confirm=true. |
| `get_model_driven_app_components` | Retrieve all components currently included in a published model-driven app. |
| `add_model_driven_app_components` | Add Dataverse components such as views, forms, workflows, dashboards, and sitemaps to a model-driven… |
| `remove_model_driven_app_components` | Remove one or more Dataverse components from a model-driven app through RemoveAppComponents. |
| `validate_model_driven_app` | Run Dataverse ValidateApp and return dependency errors and warnings before publishing. |
| `publish_model_driven_app` | Validate and publish one model-driven app via PublishXml. Validation blocks publishing unless skipVa… |
| `list_model_driven_app_roles` | List Dataverse security roles associated with a model-driven app. |
| `grant_model_driven_app_role` | Associate a Dataverse security role with a model-driven app to grant access. |
| `revoke_model_driven_app_role` | Disassociate a Dataverse security role from a model-driven app. |

</details>

<details>
<summary><strong>Power Apps Administration</strong> (4 tools)</summary>

| Tool | Description |
|------|-------------|
| `list_powerapps_admin` | List all Power Apps in an environment as admin. Requires Power Platform admin role. |
| `get_powerapp_admin` | Get Power App details as admin. Requires Power Platform admin role. |
| `delete_powerapp_admin` | Delete a Power App as admin. Requires Power Platform admin role. Set confirm=true to proceed. |
| `quarantine_powerapp` | Quarantine or unquarantine a Power App. Quarantined apps cannot be launched. Requires admin role. |

</details>

<details>
<summary><strong>Power Pages — Site Configuration</strong> (9 tools)</summary>

| Tool | Description |
|------|-------------|
| `list_powerpages_sites` | List Power Pages sites as stored in Dataverse (the configuration plane). Returns enhanced-model site… |
| `get_powerpages_site` | Get a Power Pages site's Dataverse record and detected data model (standard vs enhanced) by its site… |
| `list_powerpages_components` | List configuration components of a Power Pages site across the standard and enhanced data models. Di… |
| `get_powerpages_component` | Get a single Power Pages configuration component row by its record id. siteId selects the data model… |
| `create_powerpages_component` | Create a Power Pages configuration component. Directly site-scoped types receive the website @odata.… |
| `update_powerpages_component` | Update a Power Pages configuration component row. Only include columns you want to change in `data`. |
| `delete_powerpages_component` | Delete a Power Pages configuration component row permanently. Set confirm=true to proceed. |
| `manage_powerpages_relationship` | Associate or disassociate a Power Pages security/configuration record with a web role using a docume… |
| `upload_powerpages_webfile_content` | Attach local file bytes to a standard-model Power Pages web-file record using the documented newest-… |

</details>

<details>
<summary><strong>Power Pages — Site Management</strong> (36 tools)</summary>

| Tool | Description |
|------|-------------|
| `list_powerpages_websites` | List Power Pages websites in an environment via the Power Platform management API. Returns hosting i… |
| `get_powerpages_website` | Get a Power Pages website's hosting details (status, URL, data model) by id, via the management API. |
| `create_powerpages_website` | Provision a new Power Pages website (management API). Asynchronous — returns a tracking URL; provisi… |
| `delete_powerpages_website` | Delete a Power Pages website (management API). This cannot be undone. Set confirm=true to proceed. |
| `restart_powerpages_website` | Restart a Power Pages website (management API). Recycles the site so it picks up Dataverse config ch… |
| `get_powerpages_operation_status` | Get or boundedly wait for a Power Pages Operation-Location result. Only authenticated HTTPS URLs on… |
| `get_powerpages_allowed_ip_addresses` | Get the website IP allow list. |
| `add_powerpages_allowed_ip_addresses` | Add IPv4/IPv6 addresses or CIDR ranges to the website allow list. Set confirm=true. |
| `remove_powerpages_allowed_ip_addresses` | Remove IPv4/IPv6 addresses or CIDR ranges from the website allow list. Set confirm=true. |
| `list_powerpages_custom_domains` | List custom domains configured for a website. |
| `create_powerpages_custom_domain` | Add a custom domain to a website. DNS validation still applies. Set confirm=true. |
| `delete_powerpages_custom_domain` | Remove a custom domain from a website. Set confirm=true. |
| `list_powerpages_certificates` | List SSL or managed certificates for a website. |
| `upload_powerpages_certificate` | Upload a local PFX certificate using multipart form data. Reads an absolute canonical path (max 16 M… |
| `delete_powerpages_certificate` | Delete a certificate by thumbprint and type. Set confirm=true. |
| `list_powerpages_ssl_bindings` | List SSL bindings for a custom hostname. |
| `add_powerpages_ssl_binding` | Bind a certificate thumbprint to a custom hostname. Set confirm=true. |
| `delete_powerpages_ssl_binding` | Delete an SSL binding by hostname and thumbprint. Set confirm=true. |
| `get_powerpages_waf_status` | Get the website web application firewall status. |
| `get_powerpages_waf_rules` | Get managed and custom web application firewall rules. |
| `enable_powerpages_waf` | Enable the website web application firewall. Set confirm=true. |
| `disable_powerpages_waf` | Disable the website web application firewall. Set confirm=true. |
| `create_powerpages_waf_rules` | Create or update managed/custom WAF rules using the published 2024-10-01 contract. Set confirm=true. |
| `delete_powerpages_waf_custom_rules` | Delete named custom WAF rules. Set confirm=true. |
| `start_powerpages_quick_scan` | Start a quick website security scan. Set confirm=true. |
| `start_powerpages_deep_scan` | Start a deep website security scan. Set confirm=true. |
| `get_powerpages_security_scan_report` | Get the latest completed deep security-scan report. |
| `get_powerpages_security_scan_score` | Get the latest deep security-scan score. |
| `start_powerpages_website` | Start a stopped Power Pages website. Set confirm=true. |
| `stop_powerpages_website` | Stop a Power Pages website and make it unavailable. Set confirm=true. |
| `convert_powerpages_trial_to_production` | Convert a trial website to production and optionally enable CDN/WAF. Licensing implications apply. S… |
| `enable_powerpages_bootstrap_v5` | Stamp Bootstrap 5 enabled for a website. Set confirm=true. |
| `set_powerpages_data_model_version` | Set whether the website uses the enhanced data model. Set confirm=true. |
| `toggle_powerpages_afd_routing` | Enable or disable Azure Front Door traffic routing. Set confirm=true. |
| `update_powerpages_security_group` | Set or clear the Entra security group controlling private-site visibility. Set confirm=true. |
| `update_powerpages_site_visibility` | Set website visibility to public or private. Set confirm=true. |

</details>

<details>
<summary><strong>Power Pages — PAC CLI</strong> (8 tools)</summary>

| Tool | Description |
|------|-------------|
| `pac_pages_bootstrap_migrate` | Migrate downloaded website HTML from Bootstrap 3 to Bootstrap 5 in place. Runs the installed pac exe… |
| `pac_pages_clone` | Clone local Power Pages website content into a new output directory. Runs the installed pac executab… |
| `pac_pages_download` | Download a standard or enhanced Power Pages site from Dataverse. Runs the installed pac executable w… |
| `pac_pages_download_code_site` | Download a Power Pages code site from Dataverse. Runs the installed pac executable without a shell a… |
| `pac_pages_list` | List websites from the current or specified PAC Dataverse environment. Runs the installed pac execut… |
| `pac_pages_migrate_datamodel` | Start, inspect, reset, or revert a Power Pages data-model migration. Runs the installed pac executab… |
| `pac_pages_upload` | Upload downloaded website configuration to Dataverse. Runs the installed pac executable without a sh… |
| `pac_pages_upload_code_site` | Upload compiled code to a Power Pages code site. Runs the installed pac executable without a shell a… |

</details>

<details>
<summary><strong>Environment Administration</strong> (10 tools)</summary>

| Tool | Description |
|------|-------------|
| `list_environments` | List all Power Platform environments accessible to the current user. Shows environment names, IDs, r… |
| `get_environment` | Get detailed information about a Power Platform environment including Dataverse URL, region, and SKU… |
| `create_environment` | Create a new Power Platform environment. Requires admin role. |
| `delete_environment` | Delete a Power Platform environment permanently. This action cannot be undone. Set confirm=true. |
| `copy_environment` | Copy a Power Platform environment to create a new one. Set confirm=true. |
| `reset_environment` | Reset a Power Platform environment to its initial state. THIS DELETES ALL DATA. Set confirm=true. |
| `backup_environment` | Create a backup of a Power Platform environment. |
| `restore_environment` | Restore a Power Platform environment from a backup. Set confirm=true. |
| `list_environment_backups` | List available backups for a Power Platform environment. |
| `get_environment_capacity` | Get capacity consumption for a specific environment. |

</details>

<details>
<summary><strong>DLP Policies</strong> (6 tools)</summary>

| Tool | Description |
|------|-------------|
| `list_dlp_policies` | List all Data Loss Prevention (DLP) policies in the tenant. Requires admin role. |
| `get_dlp_policy` | Get details of a DLP policy including connector group assignments. |
| `create_dlp_policy` | Create a new DLP policy. Requires admin role. |
| `update_dlp_policy` | Update an existing DLP policy. Requires admin role. |
| `delete_dlp_policy` | Delete a DLP policy. Set confirm=true to proceed. Requires admin role. |
| `get_dlp_connector_configs` | Get connector-level configurations for a DLP policy (endpoint filtering, etc.). |

</details>

<details>
<summary><strong>Solutions ALM</strong> (8 tools)</summary>

| Tool | Description |
|------|-------------|
| `list_solutions` | List Dataverse solutions in the environment. Solutions are containers for flows, apps, and other com… |
| `export_solution` | Export a Dataverse solution as a base64-encoded zip, or resume an earlier asynchronous export by exp… |
| `import_solution` | Import a base64-encoded Dataverse solution zip. This changes the environment and requires confirm=tr… |
| `clone_solution` | Clone an unmanaged Dataverse solution and consolidate its patches into a new version. |
| `add_solution_component` | Add an existing component to an unmanaged Dataverse solution. |
| `remove_solution_component` | Remove a component from an unmanaged Dataverse solution. Requires confirm=true. |
| `list_solution_flows` | List flows stored in Dataverse solutions. These are 'solution-aware' flows that can be exported and… |
| `publish_all_customizations` | Publish every pending Dataverse customization. This can affect live apps and requires confirm=true. |

</details>

<details>
<summary><strong>Managed Environments & Capacity</strong> (6 tools)</summary>

| Tool | Description |
|------|-------------|
| `enable_managed_environment` | Enable managed environment features. Set confirm=true. Requires admin role. |
| `disable_managed_environment` | Disable managed environment features. Set confirm=true. Requires admin role. |
| `get_managed_environment_settings` | Get the governance configuration for a managed environment. |
| `update_managed_environment_settings` | Update governance settings for a managed environment. Requires admin role. |
| `get_tenant_capacity` | Get storage and API capacity usage for the tenant. Requires admin role. |
| `get_api_request_summary` | Get API request consumption summary for the tenant. Requires admin role. |

</details>

<details>
<summary><strong>Desktop Flows / RPA</strong> (3 tools)</summary>

| Tool | Description |
|------|-------------|
| `list_desktop_flows` | List desktop flows (UI flows) in the environment. Desktop flows automate tasks on Windows or web app… |
| `list_machines` | List registered machines for desktop flows (RPA). Shows machine names, status, and group memberships… |
| `list_machine_groups` | List machine groups for desktop flows. Machine groups allow load balancing of desktop flow runs acro… |

</details>

<details>
<summary><strong>Billing & AI Builder</strong> (3 tools)</summary>

| Tool | Description |
|------|-------------|
| `list_billing_policies` | List pay-as-you-go billing policies for the tenant. Requires admin role. |
| `get_billing_policy` | Get details of a specific billing policy. |
| `list_ai_models` | List AI Builder models in the environment. Shows model names, types, and status. |

</details>
<!-- TOOLS-TABLE:END -->

## Security

This server implements defense-in-depth security hardened through 3 rounds of penetration testing:

- **Secure Token Storage**: DPAPI (Windows), Keychain (macOS), libsecret on Linux when available, with a 0o600 file-cache fallback when it is not
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

<p align="right"><a href="#power-automate-mcp-server">↑ Back to top</a></p>

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

## A Note of Thanks

Thank you for using this project — it is truly appreciated. Every install, bug report, and suggestion makes this a better tool, and I'm committed to fixing any issue that arises so we have the best Power Automate MCP server possible. If something isn't working for you, please open an issue. I read every one, and a solid reproduction gets a fast fix.

## Support

For issues and feature requests, please [open an issue](https://github.com/rcb0727/powerautomate-mcp-docs/issues) in this repository. Upgrading? See [Updating safely](https://github.com/rcb0727/powerautomate-mcp-docs/blob/main/INSTALL.md#updating) and the [Changelog](https://github.com/rcb0727/powerautomate-mcp-docs/blob/main/CHANGELOG.md).
