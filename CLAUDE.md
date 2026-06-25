# Power Automate MCP Server - Claude Code Instructions

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

## Tool Reference (121 tools)

### Core Flow Operations
| Tool | Description |
|------|-------------|
| `list_flows` | List Power Automate flows in an environment |
| `get_flow` | Get the complete definition of a Power Automate flow including triggers, actions, connection refe… |
| `create_flow` | Create a new Power Automate flow |
| `update_flow` | Update an existing Power Automate flow |
| `delete_flow` | Delete a Power Automate flow permanently |
| `toggle_flow` | Enable or disable a Power Automate flow |
| `clone_flow` | Clone an existing Power Automate flow to create a copy with a new name |
| `export_flow` | Export a flow as a package |
| `share_flow` | Share a flow with users, groups, or service principals |
| `get_flow_permissions` | Get the list of users, groups, and service principals that have access to a flow |
| `list_flow_versions` | List all versions of a flow |

### Testing & Debugging
| Tool | Description |
|------|-------------|
| `test_flow` | Test a Power Automate flow with guided feedback |
| `run_flow` | Trigger a Power Automate flow to run immediately |
| `get_runs` | Get the execution history of a Power Automate flow |
| `get_run_actions` | Get detailed action-level information for a flow run |
| `get_run_action_repetitions` | Get iteration-level details for a for_each or do_until loop action in a flow run |
| `diagnose_flow` | Diagnose issues with a Power Automate flow |
| `validate_flow` | Validate a Power Automate flow definition for errors |
| `resubmit_run` | Resubmit a failed or cancelled flow run |
| `cancel_run` | Cancel a currently running flow execution |

### Planning & Help
| Tool | Description |
|------|-------------|
| `plan_flow` | Interactive flow planning wizard |
| `build_flow` | Build a Power Automate flow from a description |
| `get_expression_help` | Get help with Power Automate expressions |
| `search_connectors` | Search for Power Automate connectors by name, description, or category |
| `get_action_schema` | Get the schema and parameters for a connector's actions/triggers |

### Connections & Custom Connectors
| Tool | Description |
|------|-------------|
| `list_connections` | List all connections in an environment |
| `list_custom_connectors` | List all custom connectors in the environment |
| `get_custom_connector` | Get detailed information about a custom connector including its OpenAPI definition and all operat… |
| `create_custom_connector` | Create a custom connector for any REST API |
| `update_custom_connector` | Update a custom connector |
| `delete_custom_connector` | Delete a custom connector |
| `plan_custom_connector` | Get guidance on creating a custom connector |
| `import_openapi_connector` | Create a custom connector by importing an OpenAPI/Swagger specification |

### Approvals
| Tool | Description |
|------|-------------|
| `list_approvals` | List pending approvals in the environment |
| `list_approvals_dataverse` | List pending approval requests from Dataverse |
| `respond_approval` | Respond to a pending approval request |

### Dataverse CRUD
| Tool | Description |
|------|-------------|
| `list_dataverse_tables` | List Dataverse tables (entities) in the environment |
| `get_dataverse_table` | Get detailed metadata for a Dataverse table including all column definitions |
| `query_dataverse_rows` | Query rows from a Dataverse table with OData filtering, selecting, and ordering |
| `get_dataverse_row` | Get a single Dataverse row by its ID |
| `create_dataverse_row` | Create a new row in a Dataverse table |
| `update_dataverse_row` | Update an existing Dataverse row |
| `delete_dataverse_row` | Delete a Dataverse row permanently |

### SharePoint
| Tool | Description |
|------|-------------|
| `search_sharepoint_sites` | Search for SharePoint sites by name or keyword |
| `get_sharepoint_site` | Get a SharePoint site by its ID or by hostname and path |
| `list_sharepoint_lists` | List all lists and libraries in a SharePoint site |
| `get_sharepoint_list_columns` | Get column definitions for a SharePoint list |
| `list_sharepoint_items` | Get items from a SharePoint list with optional filtering and sorting |
| `create_sharepoint_item` | Create a new item in a SharePoint list |
| `update_sharepoint_item` | Update an existing SharePoint list item |
| `delete_sharepoint_item` | Delete a SharePoint list item permanently |
| `list_sharepoint_files` | List files in a SharePoint document library |
| `upload_sharepoint_file` | Upload a file to a SharePoint document library |
| `get_sharepoint_file_content` | Download a file's content from a SharePoint document library |

### Excel (OneDrive)
| Tool | Description |
|------|-------------|
| `search_excel_files` | Search for Excel files in OneDrive by name |
| `inspect_excel_file` | Inspect an Excel file to find tables and columns |

### Power Apps
| Tool | Description |
|------|-------------|
| `list_powerapps` | List Power Apps canvas apps in an environment |
| `list_canvas_apps` | List Power Apps canvas apps stored in Dataverse |
| `get_powerapp` | Get detailed information about a Power App including owner, connections, and app URIs |
| `list_model_driven_apps` | List model-driven apps from Dataverse |
| `publish_powerapp` | Publish a Power App to make the latest version available to users |
| `get_powerapp_versions` | Get version history for a Power App |
| `restore_powerapp_version` | Restore a Power App to a previous version |
| `get_powerapp_permissions` | Get the list of users, groups, and service principals that have access to a Power App |
| `share_powerapp` | Share a Power App with a user, group, or service principal |
| `unshare_powerapp` | Remove a user or group's access to a Power App |
| `set_powerapp_owner` | Transfer ownership of a Power App to another user |
| `set_powerapp_display_name` | Change the display name of a Power App |
| `delete_powerapp` | Delete a Power App permanently |

### Power Apps Administration
| Tool | Description |
|------|-------------|
| `list_powerapps_admin` | List all Power Apps in an environment as admin |
| `get_powerapp_admin` | Get Power App details as admin |
| `delete_powerapp_admin` | Delete a Power App as admin |
| `quarantine_powerapp` | Quarantine or unquarantine a Power App |

### Power Pages — Site Configuration
| Tool | Description |
|------|-------------|
| `list_powerpages_sites` | List Power Pages sites as stored in Dataverse (the configuration plane) |
| `get_powerpages_site` | Get a Power Pages site's Dataverse record and detected data model (standard vs enhanced) by its s… |
| `list_powerpages_components` | List configuration components of a Power Pages site (web pages, web roles, table permissions, con… |
| `get_powerpages_component` | Get a single Power Pages configuration component row by its record id. siteId selects the data model |
| `create_powerpages_component` | Create a Power Pages configuration component (e.g. a web page or content snippet) |
| `update_powerpages_component` | Update a Power Pages configuration component row |
| `delete_powerpages_component` | Delete a Power Pages configuration component row permanently |

### Power Pages — Site Management
| Tool | Description |
|------|-------------|
| `list_powerpages_websites` | List Power Pages websites in an environment via the Power Platform management API |
| `get_powerpages_website` | Get a Power Pages website's hosting details (status, URL, data model) by id, via the management API |
| `create_powerpages_website` | Provision a new Power Pages website (management API) |
| `delete_powerpages_website` | Delete a Power Pages website (management API) |
| `restart_powerpages_website` | Restart a Power Pages website (management API) |

### Environment Administration
> Requires **Power Platform Admin**, **Dynamics 365 Admin**, or **Global Admin** role.

| Tool | Description |
|------|-------------|
| `list_environments` | List all Power Platform environments accessible to the current user |
| `get_environment` | Get detailed information about a Power Platform environment including Dataverse URL, region, and SKU |
| `create_environment` | Create a new Power Platform environment |
| `delete_environment` | Delete a Power Platform environment permanently |
| `copy_environment` | Copy a Power Platform environment to create a new one |
| `reset_environment` | Reset a Power Platform environment to its initial state |
| `backup_environment` | Create a backup of a Power Platform environment |
| `restore_environment` | Restore a Power Platform environment from a backup |
| `list_environment_backups` | List available backups for a Power Platform environment |
| `get_environment_capacity` | Get capacity consumption for a specific environment |

### DLP Policies
> Requires **Power Platform Admin**, **Dynamics 365 Admin**, or **Global Admin** role.

| Tool | Description |
|------|-------------|
| `list_dlp_policies` | List all Data Loss Prevention (DLP) policies in the tenant |
| `get_dlp_policy` | Get details of a DLP policy including connector group assignments |
| `create_dlp_policy` | Create a new DLP policy |
| `update_dlp_policy` | Update an existing DLP policy |
| `delete_dlp_policy` | Delete a DLP policy |
| `get_dlp_connector_configs` | Get connector-level configurations for a DLP policy (endpoint filtering, etc.) |

### Solutions ALM
| Tool | Description |
|------|-------------|
| `list_solutions` | List Dataverse solutions in the environment |
| `export_solution` | Export a Dataverse solution as a zip file (base64-encoded) |
| `import_solution` | Import a Dataverse solution from a base64-encoded zip file |
| `clone_solution` | Clone an unmanaged Dataverse solution to create a new version |
| `add_solution_component` | Add a component (table, flow, etc.) to an unmanaged Dataverse solution |
| `remove_solution_component` | Remove a component from an unmanaged Dataverse solution |
| `list_solution_flows` | List flows stored in Dataverse solutions |
| `publish_all_customizations` | Publish all pending customizations in Dataverse |

### Managed Environments & Capacity
> Requires **Power Platform Admin**, **Dynamics 365 Admin**, or **Global Admin** role.

| Tool | Description |
|------|-------------|
| `enable_managed_environment` | Enable managed environment features |
| `disable_managed_environment` | Disable managed environment features |
| `get_managed_environment_settings` | Get the governance configuration for a managed environment |
| `update_managed_environment_settings` | Update governance settings for a managed environment |
| `get_tenant_capacity` | Get storage and API capacity usage for the tenant |
| `get_api_request_summary` | Get API request consumption summary for the tenant |

### Desktop Flows / RPA
| Tool | Description |
|------|-------------|
| `list_desktop_flows` | List desktop flows (UI flows) in the environment |
| `list_machines` | List registered machines for desktop flows (RPA) |
| `list_machine_groups` | List machine groups for desktop flows |

### Billing & AI Builder
| Tool | Description |
|------|-------------|
| `list_billing_policies` | List pay-as-you-go billing policies for the tenant |
| `get_billing_policy` | Get details of a specific billing policy |
| `list_ai_models` | List AI Builder models in the environment |


## Critical Rules

1. **ALWAYS test after changes** - Never assume success
2. **NEVER create duplicates** - Use `update_flow` for existing flows
3. **ALWAYS diagnose failures** - Don't leave broken flows
4. **Present all questions** - Don't assume user's answers
5. **Verify connections first** - Check before building
6. **Use `update_flow` not `create_flow`** when modifying an existing flow

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

Before building flows, verify connections exist:
- **Office 365 Outlook** - Email triggers/actions
- **SharePoint Online** - File/list operations
- **Microsoft Teams** - Channel posts, notifications
- **Excel Online (Business)** - Spreadsheet operations
- **Approvals** - Approval workflows
- **Dataverse** - Table/row operations

If missing, direct users to: **make.powerautomate.com > Data > Connections**

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
