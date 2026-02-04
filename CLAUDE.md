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

## Tool Reference

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

### Discovery
| Tool | When to Use |
|------|-------------|
| `list_flows` | See all flows in environment |
| `get_flow` | Get full flow definition |
| `list_connections` | Check available connections |
| `search_connectors` | Find connectors by name |
| `get_action_schema` | Get action parameters |

### Expressions
| Tool | When to Use |
|------|-------------|
| `get_expression_help` | Help with Power Automate expressions |

## Critical Rules

1. **ALWAYS test after changes** - Never assume success
2. **NEVER create duplicates** - Use `update_flow` for existing flows
3. **ALWAYS diagnose failures** - Don't leave broken flows
4. **Present all questions** - Don't assume user's answers
5. **Verify connections first** - Check before building

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
   → Show result: ✅ TEST PASSED or ❌ TEST FAILED

5. DEBUG (if needed)
   → If failed, diagnose_flow shows: "Connection Error - Re-authenticate"
   → Apply fix
   → test_flow again
   → Repeat until ✅
```

## Connection Requirements

Before building flows, verify connections exist:
- **Office 365 Outlook** → Email triggers/actions
- **SharePoint Online** → File/list operations
- **Microsoft Teams** → Channel posts, notifications
- **Excel Online (Business)** → Spreadsheet operations
- **Approvals** → Approval workflows

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

## Best Practices to Suggest

1. Add Try-Catch error handling for important flows
2. Use meaningful action names
3. Add Compose actions to debug complex expressions
4. Set appropriate timeouts on HTTP actions
5. Use trigger conditions to filter high-volume triggers
