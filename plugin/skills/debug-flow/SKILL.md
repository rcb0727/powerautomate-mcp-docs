---
name: debug-flow
description: Diagnose and fix a failed flow run. Use when a flow failed, is erroring, stopped working, or the user asks why a run did not do what they expected.
---

# Debug a failed run

Find the actual cause, then fix it.

## Tools
`get_runs` · `diagnose_flow` · `get_run_actions` · `get_run_action_repetitions` · `get_trigger_inputs` · `test_connection` · `preview_update` · `update_flow` · `resubmit_run`

## Sequence
1. **`get_runs`** to find the failing run and see whether failures are constant or intermittent.
2. **`diagnose_flow`** on that run. It drills to the failing action and returns the real API error, not a generic message.
3. **`get_run_actions`** when you need each step's inputs and outputs. For a failure inside a loop, `get_run_action_repetitions` shows which iteration broke.
4. **Check the connection** with `test_connection` if the error mentions auth, `401`, `403`, or an expired token. Connections silently expire after ~90 days of inactivity — a flow that "just stopped working" is usually this.
5. **Reproduce before fixing**: `get_trigger_inputs` returns the payload that actually broke it. Feed that to `test_flow` rather than inventing test data.
6. **Fix**: `preview_update` first to show exactly what will change, then `update_flow`. Prefer `patchActions` for a surgical edit over resending the whole definition.
7. **Verify**: `test_flow`, or `resubmit_run` to re-run the original failure against the fix.

## Notes
- Report the actual error text to the user. Never paraphrase an API error into a guess.
- If the flow's definition changed recently and broke, `list_flow_versions` + `restore_flow_version` is the fastest undo.
