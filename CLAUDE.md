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

## Tool Reference (108 tools)

### Planning & Building
| Tool | When to Use |
|------|-------------|
| `plan_flow` | FIRST step - analyzes requirements, asks questions |
| `build_flow` | Simple flows - wizard-style creation |
| `create_flow` | Complex flows - full control over definition |
| `update_flow` | Modify existing flows (NEVER create duplicates) |

### Testing & Debugging
| Tool | When to Use |
|------|-------------|
| `test_flow` | Guided testing with automatic diagnosis |
| `run_flow` | Quick execution of any flow |
| `get_runs` | Check execution history |
| `diagnose_flow` | Troubleshoot failures with fixes |
| `get_run_actions` | Detailed action-level debugging |
| `validate_flow` | Pre-flight validation with best practices score |

### Discovery
| Tool | When to Use |
|------|-------------|
| `list_flows` | See all flows in environment |
| `get_flow` | Get full flow definition |
| `list_connections` | Check available connections |
| `search_connectors` | Find connectors by name |
| `get_action_schema` | Get connector action parameters |
| `get_expression_help` | Expression syntax reference |

### Dataverse CRUD
| Tool | When to Use |
|------|-------------|
| `list_dataverse_tables` | List all tables (entities) in the environment |
| `get_dataverse_table` | Get table schema with column definitions |
| `query_dataverse_rows` | Query rows with OData filter/select/orderby |
| `get_dataverse_row` | Get a single row by ID |
| `create_dataverse_row` | Create a new row |
| `update_dataverse_row` | Update an existing row |
| `delete_dataverse_row` | Delete a row (with confirmation) |

### SharePoint
| Tool | When to Use |
|------|-------------|
| `search_sharepoint_sites` | Search for SharePoint sites by name |
| `get_sharepoint_site` | Get site by ID or hostname/path |
| `list_sharepoint_lists` | List all lists and libraries in a site |
| `get_sharepoint_list_columns` | Get column definitions for a list |
| `list_sharepoint_items` | Get list items with OData filtering |
| `create_sharepoint_item` | Create a new list item |
| `update_sharepoint_item` | Update a list item |
| `delete_sharepoint_item` | Delete a list item (with confirmation) |
| `list_sharepoint_files` | List files in a document library |
| `upload_sharepoint_file` | Upload a file (up to 4MB) |
| `get_sharepoint_file_content` | Download file content |

### Power Apps
| Tool | When to Use |
|------|-------------|
| `list_canvas_apps` | List canvas apps in the environment |
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
| Tool | When to Use |
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
| Tool | When to Use |
|------|-------------|
| `list_dlp_policies` | List data loss prevention policies |
| `get_dlp_policy` | Get policy details |
| `create_dlp_policy` | Create a new DLP policy |
| `update_dlp_policy` | Update an existing policy |
| `delete_dlp_policy` | Delete a policy |
| `list_policy_connectors` | List connectors by policy group |

### Solutions ALM
| Tool | When to Use |
|------|-------------|
| `list_solutions` | List Dataverse solutions |
| `get_solution` | Get solution details |
| `export_solution` | Export a solution |
| `import_solution` | Import a solution |
| `list_solution_components` | List components in a solution |
| `add_solution_component` | Add a component to a solution |

### Managed Environments & Capacity
| Tool | When to Use |
|------|-------------|
| `enable_managed_environment` | Enable managed environment |
| `disable_managed_environment` | Disable managed environment |
| `get_governance_settings` | Get governance configuration |
| `get_tenant_capacity` | Get tenant-level capacity |
| `get_capacity_alerts` | Get capacity alert notifications |

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
