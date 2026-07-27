# Power Platform MCP Server — Claude Code Instructions

## The 6-Phase Flow Workflow

**ALWAYS follow this workflow when users want to create, build, or modify a Power Automate flow:**

### Phase 1: PLAN
1. Call `plan_flow` with the user's description
2. Present ALL clarifying questions to the user (don't skip any)
3. Wait for answers before proceeding
4. If answers are incomplete, ask follow-up questions

### Phase 2: REVIEW
1. Show the user what will be built:
   - Trigger type and timing
   - Actions in order
   - Required connections
2. Confirm before creating
3. Warn about Premium connectors if detected

### Phase 3: VALIDATE
1. For complex flows, use `validate_flow` on the definition
2. Warn about missing error handling
3. Suggest best practices if violations detected

### Phase 4: CREATE
1. Create the flow with `create_flow` or `build_flow`
2. Note the flow ID for testing
3. Remind user the flow is created but stopped by default

### Phase 5: TEST
1. **ALWAYS test after creating or modifying a flow**
2. Use `test_flow` for guided testing with diagnostics
3. Or use `run_flow` for quick execution
4. Check results immediately

### Phase 6: DEBUG (if needed)
1. If test fails, call `diagnose_flow` immediately
2. Show user the error category and suggested fix
3. Offer to apply the fix
4. Re-test after fixing
5. Repeat until flow succeeds

## Canvas App Source Workflow (Preview)

When asked to create or modify a Canvas app, use an existing blank/editable app shell and follow this sequence:

1. Call `connect_canvas_authoring` with the Power Apps Studio Designer URL. Do not guess account, tenant, or authentication overrides.
2. Call `sync_canvas_source` into a dedicated absolute directory and inspect all returned `.pa.yaml` files. The Studio tab must remain open with coauthoring enabled.
3. Before adding controls, call `list_canvas_controls`, then `describe_canvas_control` for every control type used. Likewise discover APIs and data-source schemas instead of guessing them.
4. Write `App.pa.yaml` plus one `.pa.yaml` file per screen. Use `expectedSha256` for every overwrite or delete so concurrent edits cannot be lost silently.
5. Call `compile_canvas_source` with `confirm=true`, fix every reported file/line error, and repeat until clean. Compilation changes the live Studio draft.
6. Re-sync or verify in Studio, then ask the maker to test, save, and publish. A clean compile does not prove runtime behavior, layout, accessibility, data authentication, save, or publish.

## Tool Reference

<!-- TOOLS-TABLE:BEGIN — generated from the tool registry and synced here at each release; do not edit by hand -->
## Available Tools (216 total)

> Every tool the server exposes, grouped by service. All 216 are listed here.

<details>
<summary><strong>Setup & Authentication</strong> (1 tools)</summary>

| Tool | Description |
|------|-------------|
| `sign_in` | Sign in to Microsoft Power Platform when other tools report missing credentials. Starts Microsoft's… |

</details>

<details>
<summary><strong>Core Flow Operations</strong> (15 tools)</summary>

| Tool | Description |
|------|-------------|
| `list_flows` | List Power Automate flows in an environment. Returns flow names, IDs, state (Started/Stopped), last… |
| `get_flow` | Get the complete definition of a Power Automate flow including triggers, actions, connection referen… |
| `create_flow` | Create a new Power Automate flow. Provide a trigger, actions, and connection references. Use search_… |
| `update_flow` | Update an existing Power Automate flow. Three update modes: (1) full replace — pass 'actions' to rep… |
| `preview_update` | Preview exactly what update_flow would change on a flow — display name, trigger, added/removed/modif… |
| `delete_flow` | Delete a Power Automate flow permanently. This action cannot be undone. You must set confirm=true to… |
| `toggle_flow` | Enable or disable a Power Automate flow. Use 'start' to enable a stopped flow or 'stop' to disable a… |
| `clone_flow` | Clone an existing Power Automate flow to create a copy with a new name. Optionally update connection… |
| `export_flow` | Export a flow as a package. Returns the flow definition and metadata that can be used to import into… |
| `share_flow` | Share a flow with users, groups, or service principals. Grant them either 'CanEdit' (can modify the… |
| `get_flow_permissions` | Get the list of users, groups, and service principals that have access to a flow. Shows their role (… |
| `list_flow_versions` | List all versions of a flow. Each version represents a saved state of the flow definition. Use this… |
| `get_flow_version` | Read one saved version of a flow, including its full definition — inspect what a flow looked like be… |
| `restore_flow_version` | Roll a flow back to a previous saved version — the undo for a bad edit. Previews the change unless c… |
| `get_trigger_inputs` | Get the trigger payload a past run actually fired with — the real inputs, not a hand-written guess.… |

</details>

<details>
<summary><strong>Testing & Debugging</strong> (10 tools)</summary>

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
| `cancel_all_runs` | Cancel every in-flight run of a flow (Running, Waiting, Paused, Suspended). Without confirm=true it… |

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
<summary><strong>Connections & Custom Connectors</strong> (13 tools)</summary>

| Tool | Description |
|------|-------------|
| `list_connections` | List all connections in an environment. Shows connection names, statuses (Connected/Error), connecto… |
| `ensure_connection` | Get a working connection for a connector in one call: returns an existing Connected one if there is… |
| `create_connection` | Create a connection for a connector. OAuth connectors (SharePoint, Office 365, Teams…) are created u… |
| `test_connection` | Check whether a connection is healthy (Connected) and surface its error state when it isn't — use af… |
| `fix_connection` | Repair a broken or expired connection: returns re-authentication instructions — a fresh consent link… |
| `delete_connection` | Permanently delete a connection. Flows bound to it will fail until re-bound. Requires confirm=true. |
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
<summary><strong>Desktop Flows / RPA</strong> (13 tools)</summary>

| Tool | Description |
|------|-------------|
| `list_desktop_flows` | List desktop flows (RPA/UI automation built with Power Automate for desktop) in the environment, wit… |
| `get_desktop_flow` | Get a desktop flow's details plus its declared input and output variables (schema) — check this befo… |
| `run_desktop_flow` | Trigger a desktop flow (RPA) run on a registered machine via a desktop-flows connection. Attended ru… |
| `get_desktop_flow_runs` | List recent desktop flow runs (newest first) — across all desktop flows or scoped to one — with stat… |
| `get_desktop_flow_run` | Get one desktop flow run's status. Returns outputs when the run succeeded, and full error details (c… |
| `cancel_desktop_flow_run` | Cancel a queued or running desktop flow run. Needs owner-level access to the run — runs you triggere… |
| `list_desktop_flow_connections` | Find desktop-flows connection references usable as run_desktop_flow's connectionName (with isConnect… |
| `get_desktop_flow_run_logs` | Get a desktop flow run's action-level logs. Tries the V2 log store (flowlog) first, then the V1 run… |
| `diagnose_desktop_flow_run` | Diagnose a desktop flow run: decodes the failure, checks the machine it ran on (status, heartbeat),… |
| `list_machines` | List registered desktop-flow (RPA) machines with live status, last heartbeat, capacity, hosting type… |
| `get_machine` | Get one desktop-flow machine's full detail: status, heartbeat, session capacity, agent version, host… |
| `list_machine_groups` | List desktop-flow machine groups (load balancing / high availability for unattended RPA runs) with t… |
| `restart_hosted_machine` | Restart a Microsoft-hosted RPA machine (interrupts any in-flight run on it). Only works on hosted ma… |

</details>

<details>
<summary><strong>Work Queues (RPA orchestration)</strong> (8 tools)</summary>

| Tool | Description |
|------|-------------|
| `list_work_queues` | List work queues (shared to-do lists that coordinate RPA and cloud-flow processing) with status and… |
| `get_work_queue` | Get one work queue's configuration and health: item counts by state (queued/processing/processed/on-… |
| `create_work_queue` | Create a work queue. Optionally enforce a JSON schema on item inputs and set retry/requeue caps and… |
| `enqueue_work_queue_item` | Add an item to a work queue for processing. Supports priority (1 = highest), delayed availability, e… |
| `list_work_queue_items` | List a work queue's items (newest first), optionally filtered by state: queued, processing, processe… |
| `dequeue_work_queue_item` | Atomically claim the next queued item (oldest first, honoring priority) — it flips to Processing and… |
| `update_work_queue_item` | Finish a claimed work-queue item: mark it processed, fail it with an exception class (business/IT/ge… |
| `delete_work_queue` | Permanently delete a work queue and its items. Requires confirm=true. |

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

## Desktop flows (RPA) — operate, don't author

**There is no way to create or edit a desktop flow through this server, and no
API exists for it.** The definition is Robin script plus companion
`desktopflowbinary` records; Microsoft documents no write path and their own
disaster-recovery guidance is to paste the script into the Power Automate for
desktop designer manually. Never offer to build one.

What to do when a user asks to create one: say authoring happens in Power
Automate for desktop, then offer what this server does well — run an existing
flow, watch it, diagnose a failure, check machine health, or set up work
queues. Moving an authored flow between environments IS supported via
`export_solution` / `import_solution`.

Runs are asynchronous: `run_desktop_flow` returns a session id immediately;
poll `get_desktop_flow_run`. Attended runs need Premium on the connection
owner; unattended additionally need a Process license on the machine — the
tools name which one is missing.

## Critical Rules

1. **ALWAYS test after changes** - Never assume success
2. **NEVER create duplicates** - Use `update_flow` for existing flows
3. **ALWAYS diagnose failures** - Don't leave broken flows
4. **Present all questions** - Don't assume user's answers
5. **Verify connections first** - Check before building
6. **Use `update_flow` not `create_flow`** when modifying an existing flow
7. **Preview before you write** — `preview_update` shows exactly what an edit
   changes and writes nothing. Use it on any flow that matters.
8. **There is an undo** — `list_flow_versions` then `restore_flow_version`
   rolls back a bad edit, and the rollback is itself reversible.
9. **Reproduce with real data** — `get_trigger_inputs` returns the payload a
   failed run actually fired with. Do not invent test input when the real one
   is available.
10. **Never tell a user to re-run `--setup` for a consent error.** It cannot
    grant consent — an Entra admin must. Name the specific permission from the
    error instead.
11. **Confirm destructive operations by name and ID.** 39 tools are annotated
    destructive; `reset_environment`, `restore_environment`, and
    `copy_environment` are irreversible from here.

## Example Workflow

```
User: "Create a flow that emails me daily sales reports"

1. PLAN
   → Call plan_flow with "emails me daily sales reports"
   → Present questions: What time? What data? Which email?
   → Wait for answers

2. REVIEW
   → "I'll create a scheduled flow at 8 AM daily that sends an email with sales data"
   → Confirm: "Shall I proceed?"

3. CREATE
   → Call build_flow with complete specification
   → Output: Created "Daily Sales Report (Scheduled)" (abc123...)

4. TEST
   → Call test_flow flowId="abc123..."
   → Wait for completion
   → Show result: TEST PASSED or TEST FAILED

5. DEBUG (if needed)
   → If failed, diagnose_flow shows: "Connection Error - Re-authenticate"
   → Apply fix
   → test_flow again
   → Repeat until success
```

## Connection Requirements

Resolve connections BEFORE building — a missing connection is the most common
reason a build stalls halfway.

- **`ensure_connection`** is the one call to make: it returns an existing
  Connected connection, or creates one and hands back sign-in instructions.
  Use it instead of stitching `list_connections` + `create_connection` +
  `test_connection` together.
- The server is headless, so it cannot complete OAuth. It returns a consent
  link, or (on environments that expose none — `Default-` environments do not)
  a deep link to the connection in the maker portal. Say that plainly rather
  than implying sign-in already happened.
- **A flow that "just stopped working" is usually an expired connection.**
  Connections die after ~90 days of inactivity (`AADSTS700082`).
  `test_connection` shows it in one step; `fix_connection` returns the repair
  link.
- `create_connection`/`test_connection`/`fix_connection`/`delete_connection`
  need the Power Platform API connectivity scopes with admin consent.
  `list_connections` alone does not.

## Error Recovery Patterns

| Error Type | Suggested Fix |
|------------|---------------|
| Connection Error | Re-authenticate at Power Automate portal |
| Resource Not Found | Verify path/ID, check if deleted |
| Timeout | Enable async, increase timeout, batch operations |
| Rate Limited | Add delays, reduce concurrency |
| Expression Error | Use get_expression_help, check syntax |
| Permission Error | Check service account permissions |
| Consent Error | Admin must grant consent (Global Admin, App Admin, Cloud App Admin, or Privileged Role Admin) |

## Best Practices to Suggest

1. Add Try-Catch error handling for important flows
2. Use meaningful action names
3. Add Compose actions to debug complex expressions
4. Set appropriate timeouts on HTTP actions
5. Use trigger conditions to filter high-volume triggers


## Live-validation lessons (do not relearn these)

Doc-derived code against Microsoft APIs has a meaningful defect rate. Every
one of these passed the mock suite and failed against a real tenant:

- **Dataverse GUIDs are not RFC 4122.** Sequential GUIDs carry a version
  nibble outside 1–8 (real: `8ae8d5b3-6989-f111-…`). Use
  `GUID_PATTERN` from `utils/security.js`, never `z.string().uuid()`.
  Adjusting a test fixture to satisfy a validator is how this stayed hidden —
  question the validator first.
- **Never swallow an error and return a default.** `get_work_queue` reported
  "0 queued" for a full queue because a 400 was caught and turned into `0`.
  A confidently wrong number is worse than a failure.
- **`workqueueitems/$count?$filter=` is rejected** by Dataverse. Use the inline
  OData count (`$count=true` → `@odata.count`).
- **The per-environment Power Platform API host does not resolve** for
  `Default-` environments. Use the global `api.powerplatform.com`; the
  connectivity routes need the environment in the path AND a
  `$filter=environment eq '…'` query.
- **MSAL caches access tokens ~1h**, so a stale-token 403 looks identical to a
  missing-scope 403 right after granting consent. Force a refresh before
  concluding anything about permissions.
- **Smoke-test any new Dataverse family live before shipping it.** Work queues
  need only a signed-in account and clean up after themselves.
