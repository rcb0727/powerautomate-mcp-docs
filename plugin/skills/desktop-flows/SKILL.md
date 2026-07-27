---
name: desktop-flows
description: Run and troubleshoot desktop flows (RPA). Use for desktop flows, RPA, UI automation, unattended bots, or machine problems.
---

# Desktop flows (RPA)

Run automation on Windows machines, and work out why a run failed.

## Tools
`list_desktop_flows` · `get_desktop_flow` · `run_desktop_flow` · `get_desktop_flow_runs` · `get_desktop_flow_run` · `cancel_desktop_flow_run` · `diagnose_desktop_flow_run` · `get_desktop_flow_run_logs` · `list_desktop_flow_connections` · `list_machines` · `get_machine` · `list_machine_groups` · `restart_hosted_machine`

## Running one
1. `list_desktop_flows` to find it.
2. `get_desktop_flow` to see the input variables it declares — pass matching keys, do not guess.
3. `list_desktop_flow_connections` to find the connection (a desktop-flow connection carries the target machine and its credentials).
4. `run_desktop_flow` with `attended` or `unattended`. It returns a session ID immediately; the run is asynchronous.
5. Poll `get_desktop_flow_run`. Outputs appear when it succeeds; full error detail when it fails.

## When a run fails
`diagnose_desktop_flow_run` first — it decodes the failure, checks the machine's status and heartbeat, and translates licensing errors into the exact license to request. Then `get_desktop_flow_run_logs` for action-level detail if any was recorded.

## Prerequisites worth stating up front
- Attended runs need Power Automate **Premium** on the connection owner; unattended additionally need a **Process** license on the machine. The tools report which one is missing.
- The machine must be registered (Power Automate for desktop installed and signed in). `list_machines` shows status and heartbeat — a machine with a stale heartbeat cannot take runs.
- Desktop flows cannot be authored through the API. Creating or editing one requires the Power Automate for desktop designer.
