---
name: setup
description: Set up or repair the Power Automate MCP connection. Use when the user is installing the server, hits an auth error, or asks why tools are missing or failing with permission errors.
---

# Setup & repair

Get the server working, or diagnose why it isn't.

## Tools
`sign_in` · `list_environments`

## First-time setup
1. Ask whether they have already run `powerautomate-mcp --setup` in a terminal. If not, that is the fastest path — it creates the app registration, signs them in, and wires their AI client.
2. If they cannot use a terminal, call `sign_in`. It returns a device code and URL; the user completes sign-in in a browser, then you continue.
3. Confirm with `list_environments`. If that returns environments, the server is working.

## Diagnosing failures
Match the symptom before suggesting a fix:

| Symptom | Cause | Fix |
|---|---|---|
| `AADSTS65001` / "consent missing" | The app registration lacks a permission, or an admin never consented | An Entra admin must grant consent. Name the specific API from the error — re-running `--setup` does NOT grant consent |
| Tool is not in the list at all | Its feature is disabled in the permission profile | Re-run `--setup` and pick a profile that includes it |
| `403` on Dataverse, desktop flow, or work-queue tools | Missing the Dynamics CRM delegated permission | Add it in Entra and consent |
| `403` on connection create/test | Missing Power Platform API connectivity scopes | Add `Connectivity.Connections.Read/Write` and consent |
| Everything fails after months of working | Expired refresh token | `powerautomate-mcp --login` |

Never tell the user to re-run `--setup` for a consent problem — it cannot fix one.
