# Changelog

**Docs:** [Overview](https://github.com/rcb0727/powerautomate-mcp-docs/blob/main/README.md) · [Installation & Upgrading](https://github.com/rcb0727/powerautomate-mcp-docs/blob/main/INSTALL.md) · **Changelog** · [Report an issue](https://github.com/rcb0727/powerautomate-mcp-docs/issues)

> **Upgrading?** Quit your AI clients first so no `powerautomate-mcp` process is running, then `npm install -g powerautomate-mcp@latest`. Details: [Updating safely](https://github.com/rcb0727/powerautomate-mcp-docs/blob/main/INSTALL.md#updating).

## Release Index

| Version | Date | Highlights |
|---------|------|------------|
| [0.13.0](#0130---2026-07-09) | 2026-07-09 | **`update_flow` fixes + fresh-tenant setup** — description-only updates work (no more `properties.description` rejection or false connection-reference blocks, [#15](https://github.com/rcb0727/powerautomate-mcp-docs/issues/15)); `--setup` now succeeds in tenants that never used Power Platform (auto-creates service principals, resolves tenant-local permission ids); msal-node 5; `npm audit` 0 vulnerabilities |
| [0.12.0](#0120---2026-07-05) | 2026-07-05 | **Least privilege + hardening release** — permission presets, feature-aware tool filtering and health checks, live-tenant fixes for approvals/consent errors, structuredContent expansion, pagination/retry/ETag improvements, hardened Streamable HTTP, coverage/Scorecard gates, dependency/security updates, and a Node.js 22.19+ baseline |
| [0.11.1](#0111---2026-07-01) | 2026-07-01 | **Security** — `fast-uri` 3.1.2→3.1.3 (CVE / CWE-436 interpretation conflict: Unicode/fullwidth hostnames like `http://127。0。0。1/` left unconverted, could steer host-based security checks). Override floor raised from `^3.1.2` to `^3.1.3` so the patched build is actually locked in |
| [0.11.0](#0110---2026-06-24) | 2026-06-24 | **Easier install** — `--setup` now connects your AI app for you (auto-writes/merges the client config, no hand-editing JSON); new `--doctor` health check; new `--client <name>` and `--npx` flags; rewritten install guide with an Easy Path, troubleshooting FAQ, and glossary |
| [0.10.3](#0103---2026-06-20) | 2026-06-20 | **Security** — `qs` 6.15.1→6.15.2 (NULL deref), `fast-uri` 3.1.0→3.1.2 (directory traversal + host interpretation conflict), `ip-address` 10.1.0→10.2.0 (XSS); pinned via npm `overrides` (deep transitive deps of the MCP SDK) |
| [0.10.2](#0102---2026-06-19) | 2026-06-19 | **Security** — `undici` 6.25→6.27 (4 CVEs: CRLF injection, resource exhaustion, permissive inputs, TOCTOU), `ajv` 8.17→8.20 (ReDoS), `hono` 4.11→4.12 (directory traversal), `@hono/node-server` 1.19.9→1.19.14 (URL encoding bypass) |
| [0.10.1](#0101---2026-06-15) | 2026-06-15 | **Security** — Dataverse API error bodies sanitized before reaching tool output; record GUIDs, user emails, and credentials no longer leak in error messages |
| [0.10.0](#0100---2026-06-15) | 2026-06-15 | **Power Pages** — 12 new tools: Dataverse site config (pages, web roles, table permissions, snippets, templates) with standard/enhanced data-model auto-routing, plus site management (provision/restart/delete) via the Power Platform API |
| [0.9.4](#094---2026-06-11) | 2026-06-11 | `get_run_actions`/`diagnose_flow` payload fetches unblocked — `*.powerplatformusercontent.com` added to resource-link allowlist ([#12](https://github.com/rcb0727/powerautomate-mcp-docs/issues/12)) |
| [0.9.3](#093---2026-05-23) | 2026-05-23 | `diagnose_flow` fetches the actual HTTP response body from failed actions |
| [0.9.2](#092---2026-05-22) | 2026-05-22 | BAP token caching after `--setup`, 20+ Azure region mappings ([#11](https://github.com/rcb0727/powerautomate-mcp-docs/issues/11)) |
| [0.9.1](#091---2026-05-17) | 2026-05-17 | `--setup` crash with reused app registration fixed ([#10](https://github.com/rcb0727/powerautomate-mcp-docs/issues/10)) |
| [0.9.0](#090---2026-05-13) | 2026-05-13 | Full action-level I/O visibility + `get_run_action_repetitions` loop drill-down |
| [0.8.0](#080---2026-05-06) | 2026-05-06 | Nested-action capture (`format="json"`), merge/patch flow updates, shared-flow filtering |
| [0.7.9](#079---2026-05-05) | 2026-05-05 | Security: `undici` + MCP SDK bumps closing 6 advisories |
| [0.7.8](#078---2026-04-30) | 2026-04-30 | Actionable diagnostics when device-code flow is blocked ([#9](https://github.com/rcb0727/powerautomate-mcp-docs/issues/9)) |
| [0.7.7](#077---2026-04-29) | 2026-04-29 | Device-code prompt rendering fix ([#9](https://github.com/rcb0727/powerautomate-mcp-docs/issues/9)) |
| [0.7.6](#076---2026-04-23) | 2026-04-23 | Dataverse URL auto-resolution, flow run-ID validation, `$orderby` fix ([#6](https://github.com/rcb0727/powerautomate-mcp-docs/issues/6), [#7](https://github.com/rcb0727/powerautomate-mcp-docs/issues/7), [#8](https://github.com/rcb0727/powerautomate-mcp-docs/issues/8)) |

Older releases are documented below in full.

## [0.13.0] - 2026-07-09

`update_flow` reliability fixes plus a setup overhaul that makes `--setup` work in brand-new tenants.

### Fixed
- **Updating only a flow's description works.** ([#15](https://github.com/rcb0727/powerautomate-mcp-docs/issues/15)) Two separate causes, both closed:
  - The flows API rejects `properties.description` on write ("The request content was invalid ... Invalid JSON at path 'properties.description'"). Descriptions now travel inside the workflow definition (`definition.description`), where the service actually stores them. `get_flow` surfaces the definition-level description too.
  - With `validateBeforeUpdate: true`, the pre-update validation ran structure checks (`connectionName`/`id`/`source`) against connection references merely **carried over unchanged** from the live flow. Flows built in the Power Automate designer store references in a modern shape without those fields, so a description-only update was blocked with "Connection reference missing connectionName". Carried-over references are now exempt from structure checks; references you supply in the call are still fully validated, and missing/unused-connection checks still run in both cases.
- Friendlier error when an environment has no Dataverse organization instead of a raw API failure.

### Added
- **Fresh-tenant setup hardening.** `--setup` previously assumed the first-party resource service principals (Environment Service, PowerApps Service, ...) already exist in your tenant and publish their permission scopes under well-known ids — true only in tenants that already used Power Platform. In new tenants setup failed with `AADSTS650052` (missing service principal) and then `AADSTS65006` (permission ids not found). Setup now: creates any missing service principals (the app's own and each resource's), reads each live service principal's published scopes and resolves permission ids by **scope value** for your tenant, re-applies the public-client flag, waits out Entra propagation (with automatic sign-in retries labeled as propagation, not failure), and offers to grant admin consent directly through the Azure CLI. A created app's client ID is also saved immediately, so a failed run resumes with the same app instead of piling up orphan registrations.
- After device-code sign-in, the wizard now tells you the leftover browser tab (including the `.../wrongplace` page) is normal and safe to close.
- `--validate` gives exact Azure CLI/portal steps for the manual Power Platform API (Power Pages Tier 2) permission instead of a generic pointer.

### Changed
- **Auth stack upgraded: `@azure/msal-node` 2 → 5.3.1** (with matching msal-node-extensions). Token cache and sign-in flows are unchanged from a user's perspective.
- Test suite grew from ~630 to 1,274 tests (statement coverage 48% → 84%) and CI now also runs on Windows.

### Security
- `hono` (transitive via the MCP SDK) pinned to ≥ 4.12.27 (resolves 4.12.28), closing three advisories including an SSR request-context race. `npm audit` reports **0 vulnerabilities**.

### Upgrade Notes
- Requires Node.js 22.19 or newer (unchanged since 0.12.0).
- Upgrade with `npm install -g powerautomate-mcp@latest` (quit your AI clients first).
- If setup previously failed in your tenant with `AADSTS650052` or `AADSTS65006`, re-run `powerautomate-mcp --setup` — it now repairs the app registration in place.

## [0.12.0] - 2026-07-05

Least-privilege setup plus the full 0.12 release train from the source PR and issue sweep.

### Added
- **Permission presets in `--setup`.** Users can now choose **All tool surfaces**, **Power Automate only**, **Power Automate + connectors**, **Dataverse**, **Power Pages**, or **Custom** before app registration creation. Power Automate remains the base scope; optional Graph, PowerApps Service, BAP Admin API, Dynamics CRM, and Power Platform API surfaces are only requested when selected.
- **Feature-aware config.** Setup writes `features.enabled` so the selected tool surfaces are explicit and repeatable. Existing configs remain backwards-compatible and default to the historical "all tools" behavior.
- **Feature-aware tool advertising.** MCP clients no longer see tools for permission surfaces the user skipped. Calling a disabled tool returns guidance to re-run setup with the matching feature enabled.
- **Feature-aware health checks.** `--doctor` and `--validate` now check only selected secondary APIs. A Power Automate-only install no longer fails because Graph, PowerApps, Dataverse, admin, or Power Pages permissions were intentionally omitted.
- **Pagination and structured MCP output improvements.** `list_flows` supports live `skipToken` pagination plus opt-in `fetchAll`, and structuredContent coverage expanded across key read tools including flow/run diagnostics, environments, approvals, permissions, versions, connections, and solutions.



### Changed
- **App registration generation is least-privilege.** Azure CLI-created app registrations now build `requiredResourceAccess` from the selected feature set instead of always asking for every standard permission.
- **HTTP and API resilience improved.** Idempotent GETs now retry transient 429s with backoff, `update_flow` uses opportunistic ETag/If-Match concurrency when available, and Streamable HTTP is hardened with per-session servers, Origin checks, bearer auth, and session caps.
- **Core dispatch and safety code was tightened.** The large tool-dispatch switch was replaced with a data-driven handler map, runtime JSON escaping/brace matching was fixed, sanitizer edge cases were covered, and `http://` token/resource paths are rejected.
- **Dependency/tooling refresh.** Updated undici 8.7.0, zod 4.4.3, TypeScript 6.0.3, ESLint 10.6.0, Vitest/coverage 4.1.9, pino 10.3.1, rimraf 6.1.3, setup-node 6, checkout 7, upload-artifact 6, and pinned `uuid >=12.0.1`.

### Fixed
- **`list_approvals` works in real tenants.** The tool now sends the owner `$filter` required by the approvals API, using the signed-in token's object ID.
- **Consent failures are actionable.** `AADSTS65001` no longer masquerades as "no cached credentials"; the error now names the exact unconsented scope/resource.
- **BAP Admin API consent is now surfaced clearly.** Live tenant validation can distinguish "PowerApps Service is authorized" from "BAP Admin API is missing," which keeps Dataverse URL discovery/admin failures actionable.

### Upgrade Notes
- Requires Node.js 22.19 or newer.
- Upgrade with `npm install -g powerautomate-mcp@latest`.
- Existing configs continue to work as "all tool surfaces" until you re-run setup. To reduce requested scopes, run `powerautomate-mcp --setup`, choose a narrower permission set, and remove any no-longer-needed API permissions from the app registration in Microsoft Entra.

## [0.11.1] - 2026-07-01

Security patch for a transitive dependency of the MCP SDK.

### Security
- **`fast-uri` 3.1.2 → 3.1.3** (High). Addresses an interpretation-conflict flaw (CWE-436) in `fast-uri`'s `parse()`/`normalize()`/`equal()`: a `TypeError` from the missing `URL.domainToASCII()` was silently swallowed, leaving internationalized/fullwidth hostnames (e.g. `http://127。0。0。1/`) in their unconverted Unicode form. Where a host string is used for security decisions (denylists, loopback filtering, redirect/proxy validation) before a downstream consumer canonicalizes it differently, this could route to an unintended destination.
- **Root cause of the miss:** the existing override pinned `fast-uri: ^3.1.2`, which is *satisfied* by the vulnerable 3.1.2, so npm never advanced the lockfile to the patched 3.1.3. The override floor is now `^3.1.3`, and the lockfile is regenerated to lock `fast-uri@3.1.3`.
- **Provenance:** `fast-uri` is pulled in transitively via `@modelcontextprotocol/sdk` → `ajv` / `ajv-formats`; there is no direct dependency to bump, hence the npm `overrides` approach.

## [0.11.0] - 2026-06-24

Focused on making installation work for everyone, not just developers.

### Added
- **`--setup` now connects your AI app automatically.** A new final step writes/merges the `powerautomate` server into your client's config so you never hand-edit JSON. Supports Claude Desktop, Cursor, VS Code (Copilot), Gemini CLI, and Windsurf via a safe JSON merge (existing servers and settings are preserved), and Claude Code via its official `claude mcp add` CLI. Pick from a menu, or pre-select with `--client <name>`.
- **`--doctor` — a friendly health check.** Verifies Node.js version, install/update status, config, sign-in, Power Platform connectivity, and which AI apps are wired up — then prints the exact next step in plain English. Exit code reflects whether the essentials pass.
- **`--client <name>` flag.** Wire (or re-wire) an app's config any time without re-running auth: `powerautomate-mcp --client cursor`. Names: `claude`, `claude-code`, `cursor`, `vscode`, `gemini`, `windsurf` (aliases accepted).
- **`--npx` flag.** With `--setup`/`--client`, configures the app to launch the server via `npx -y powerautomate-mcp@latest` — no global install required (handy when `npm install -g` hits permission errors).

### Changed
- **Rewritten installation guide.** Adds a "choose your path" router (non-technical / developer / admin), foolproof prerequisites (per-OS Node install, how to open a terminal, version checks), a 3-step Easy Path with "what you should see" checkpoints, a troubleshooting FAQ keyed to real error messages (`EACCES`, `command not found`, `AADSTS65001`, "tools don't appear", libsecret), and a plain-English glossary.
- **Tightened README Quick Start** to the new three commands (install → setup → doctor) and documented the new flags in the CLI reference.
- Setup wizard is now 6 steps (was 5); the final "next steps" point you to `--doctor`.

### Fixed
- **Tool documentation now matches the server exactly — all 121 tools listed, zero fabricated names.** The README/CLAUDE tool tables previously listed 84 entries, 13 of which were names the server never registered (e.g. `get_canvas_app`, `share_app`, `get_solution`, `get_governance_settings`) — an AI told to call them would fail. Regenerated every tool table from the source registry: the 13 invalid names are corrected to their real equivalents (`get_powerapp`, `share_powerapp`, `get_managed_environment_settings`, `get_dlp_connector_configs`, …), the ~37 previously-undocumented tools (custom connectors, approvals, Excel, RPA/desktop flows, billing, AI Builder, admin variants, etc.) are now documented, and the "121 total" count is accurate. On Windows, generated client configs now wrap the launch command in `cmd /c` so the server actually starts.

### Upgrade Notes
- `npm install -g powerautomate-mcp@latest`. No configuration or permission changes required. Existing installs keep working unchanged; the new flags are additive. To let setup wire your client, just run `powerautomate-mcp --setup` again (it merges, it won't clobber other servers).

## [0.10.3] - 2026-06-20

### Security
- **`qs` 6.15.1 → 6.15.2** — closes NULL pointer dereference in `stringify()` when `arrayFormat: 'comma'` + `encodeValuesOnly: true` process arrays containing `null`/`undefined` elements (CVSSv4 6.9). Transitive via `@modelcontextprotocol/sdk` › `express` (and `body-parser`).
- **`fast-uri` 3.1.0 → 3.1.2** — closes directory traversal in `normalize()`/`equal()` via crafted percent-encoded/dot segments (CVSSv4 8.7) and host-component interpretation conflict during URI serialization that could bypass host allowlist/redirect checks (CVSSv4 8.7). Transitive via `@modelcontextprotocol/sdk` › `ajv`.
- **`ip-address` 10.1.0 → 10.2.0** — closes XSS via `group`/`link`/`spanAll` and the `parseMessage` field of thrown errors (CVSSv4 5.3). Transitive via `@modelcontextprotocol/sdk` › `express-rate-limit`.
- Pinned through an `overrides` block in `package.json` — `express-rate-limit` pins `ip-address` to an exact version, so a plain reinstall would not have upgraded it. Build, typecheck, and the full test suite pass against the overridden versions.

### Upgrade Notes
- `npm install -g powerautomate-mcp@latest`. No configuration, permission, or workflow changes required.

## [0.10.2] - 2026-06-19

### Security
- **`undici` 6.25.0 → 6.27.0** — closes 4 CVEs: CRLF injection in `parseSetCookie` (CVSSv4 9.2), allocation without limits via WebSocket fragments (CVSSv4 8.7), permissive `SameSite` attribute parsing (CVSSv4 8.3), and TOCTOU race on keep-alive sockets (CVSSv4 6.3). Direct dependency.
- **`ajv` 8.17.1 → 8.20.0** — closes ReDoS via `$data`-referenced `pattern` keyword (CVSSv4 8.2). Transitive through `@modelcontextprotocol/sdk`.
- **`hono` 4.11.7 → 4.12.26** — closes directory traversal via encoded backslash on Windows hosts (CVSSv4 8.7). Transitive through `@modelcontextprotocol/sdk`.
- **`@hono/node-server` 1.19.9 → 1.19.14** — closes URL encoding bypass allowing access to protected static paths (CVSSv4 6.9). Transitive through `@modelcontextprotocol/sdk`.

### Upgrade Notes
- `npm install -g powerautomate-mcp@latest`. No configuration, permission, or workflow changes required.

## [0.10.1] - 2026-06-15

### Security
- **Dataverse API error responses are now sanitized before they can reach tool output (low-severity information disclosure).** `DataverseApi.handleResponse` attached the raw, parsed Dataverse error body to the thrown `ApiError`, and the tool dispatcher's `formatErrorMessage` read `error.details` directly — bypassing `PowerAutomateError.toJSON`'s credential stripping — so a Dataverse error containing a record GUID, user email, or instance URL could surface to the MCP caller un-redacted. Both layers now run the error body through `sanitizeErrorMessage` (GUIDs collapsed to an 8-character correlation prefix, emails → `[EMAIL]`, bearer tokens / API keys redacted), mirroring the existing `PowerPagesApi` behavior. This affects only the text of *error* messages — successful responses, tool signatures, and error categorization (connection/auth/not-found/rate-limit guidance) are unchanged. Regression tests added covering GUID and email redaction at both layers.

### Fixed
- **`tsc --noEmit` is clean again (developer/CI-facing only — no runtime change).** Resolved 5 pre-existing TypeScript errors unrelated to the v0.10.0 Power Pages work: four `TS2532` "object is possibly undefined" index accesses in `get-run-actions.ts` (already guarded by an existing key-initialization check, now expressed with provably-safe non-null assertions) and one `TS6133` unused parameter in `get-run-action-repetitions.ts` (underscore-prefixed). The bundler (tsup/esbuild) never typechecked, so published builds were never affected; this only restores a green `tsc` for contributors and CI. No emitted JavaScript changes.

### Upgrade Notes
- `npm install -g powerautomate-mcp@latest`. No app-registration, configuration, or workflow changes required.

## [0.10.0] - 2026-06-15

### Added
- **Power Pages support (12 new tools, 109 → 121 total).** Two planes:
  - **Site configuration (Dataverse)** — `list_powerpages_sites`, `get_powerpages_site`, and `list`/`get`/`create`/`update`/`delete_powerpages_component` covering web pages, web roles, table permissions, content snippets, web/page templates, site settings, site markers, web link sets, web files, lists, and basic/advanced forms. Each tool auto-detects the site's **data model** and routes to the correct tables — the standard legacy `adx_*` tables or the enhanced `mspp_*` virtual tables — and `create` wires the site association automatically via `@odata.bind`. Runs over the existing Dataverse Web API client (Dataverse-enabled environment required).
  - **Site management (Power Platform API)** — `list`/`get`/`create`/`delete`/`restart_powerpages_website` for hosting/lifecycle via `https://api.powerplatform.com` (`api-version=2024-10-01`). `create` is asynchronous and gated behind `confirm`; `restart` is the API equivalent of the design-studio "Sync".
- Entity-set names and `powerpagecomponenttype` codes verified against Microsoft Learn. Unit tests cover data-model routing, entity-set selection, `@odata.bind` injection, GUID/OData-injection rejection, confirm-gates, and registry wiring.

### Upgrade Notes
- `npm install -g powerautomate-mcp@latest`. The Power Pages **configuration** tools need only your existing Dataverse permission. The Power Pages **management** tools additionally require the **Power Platform API** delegated permission (appId `8578e004-a5c6-46e7-913e-12f58912df43`) on your app registration — add it in Microsoft Entra, grant admin consent, and re-run `--setup` (the wizard reports whether it authorized). Service principals are not supported by the Power Pages management namespace; use the interactive delegated sign-in.

## [0.9.4] - 2026-06-11

### Fixed
- **`get_run_actions` / `diagnose_flow` payload fetches blocked — `*.powerplatformusercontent.com` missing from resource-link allowlist**: action `inputsLink`/`outputsLink` URIs returned by the Flow API resolve to the per-environment Power Platform content endpoint (`<environment-id>.environment.api.powerplatformusercontent.com`), which the resource-link validator rejected fail-closed with `Invalid resource link: domain not in allowlist`. On affected tenants every payload fetch failed, and `diagnose_flow` categorized all failures as "Unknown Error" because it could never retrieve the real HTTP response body (the headline 0.9.3 improvement). Added `powerplatformusercontent.com` to the allowlist with the same dot-boundary subdomain matching as the existing entries — Microsoft lists `https://*.powerplatformusercontent.com` as required Power Platform infrastructure ([online requirements](https://learn.microsoft.com/power-platform/admin/online-requirements)). The existing SAS-token handling (auth header withheld for `sig=`/`sv=` URLs) is URI-based and applies to these links unchanged. Regression tests added, including lookalike-domain rejection (`evilpowerplatformusercontent.com`, `powerplatformusercontent.com.evil.io`). Fixes [#12](https://github.com/rcb0727/powerautomate-mcp-docs/issues/12).

### Upgrade Notes
- `npm install -g powerautomate-mcp@latest`. No configuration or permission changes required.

## [0.9.3] - 2026-05-23

### Improved
- **`diagnose_flow` now fetches actual API error responses**: Previously only read the generic Power Automate error wrapper which often just said "Unknown error." Now fetches the real HTTP response body from failed actions (via `outputsLink`) to surface the actual API error — e.g., Jira's `"The requested API has been removed"`, Graph's `"Resource not found"`, or a 401 auth failure body. Also fetches action inputs to show what URL/body was sent. HTTP status codes, response bodies, and request details are included in the diagnostic output. Error pattern matching re-runs against the real response for better category classification and fix suggestions.

## [0.9.2] - 2026-05-22

### Fixed
- **BAP token not cached after `--setup`**: The setup wizard's "additional resources" probe used silent-only acquisition for `api.bap.microsoft.com`, which fails on strict corporate tenants where consent was never interactively captured. Now uses interactive auth (with silent-first optimization) so the BAP token is reliably cached post-setup. This fixes Dataverse tools failing with "No cached credentials" even after a clean `--setup`.
- **Azure region names produce invalid Dataverse hostnames**: The region map only covered Power Platform region names (`unitedstates`, `europe`) but not Azure region names (`westus`, `eastus`, `westeurope`, etc.). When `region: "westus"` was in the config, the fallback generated `<guid>.westus.dynamics.com` — an invalid hostname. Added 20+ Azure region mappings.
- **Misleading error message on BAP fallback**: Distinguished auth failures ("BAP token not cached — run --setup or add dataverseUrl") from API failures ("instanceUrl not returned — falling back to region guess") so users don't chase futile `--setup` re-runs.

### Upgrade Notes
- `npm install -g powerautomate-mcp@latest`
- Run `powerautomate-mcp --setup` to cache the BAP token interactively
- **Workaround** (if interactive BAP auth fails): Add `dataverseUrl` to your environment config:
  ```json
  { "id": "<env-guid>", "region": "westus", "dataverseUrl": "<org-name>.crm.dynamics.com" }
  ```
- Fixes [#11](https://github.com/rcb0727/powerautomate-mcp-docs/issues/11)

## [0.9.1] - 2026-05-17

### Fixed
- **Setup wizard crashes before showing device code when reusing existing app registration**: The wizard clears the token cache during setup but the account cache persists from a prior session. `currentAccount` was non-null, silent acquisition failed (no tokens), and the secondary-resource-probe guard (added in v0.7.4) blocked the device code fallback — crashing with "Silent token acquisition failed" before the user ever saw an auth code. Fixed by tracking `interactiveAuthCompleted` flag: the guard now only blocks secondary resource probes after a successful device code auth in the current session, not when `currentAccount` is stale from a prior run.

### Upgrade Notes
- `npm install -g powerautomate-mcp@latest`
- No re-authentication needed — this fix makes `--setup` work correctly when it previously crashed.
- Fixes [#10](https://github.com/rcb0727/powerautomate-mcp-docs/issues/10)

## [0.9.0] - 2026-05-13

### Added
- **`get_run_actions` full I/O visibility**: Removed the hardcoded action-name filter that only fetched outputs for a handful of named actions. The tool now fetches **inputs and outputs for all failed actions by default**, and for all actions when `includeInputs` / `includeOutputs` is explicitly set to `true`. New `actionName` parameter allows filtering to a specific action by partial name match for targeted drill-down. Truncation limits raised from 200 to 1,000 characters. I/O fetches run in parallel for faster results. Tracked properties and retry counts are now surfaced in the output.
- **New `get_run_action_repetitions` tool**: Drill into individual iterations of `Apply_to_each` (for_each) and `Do_until` loops. Shows per-iteration status, timing, inputs, outputs, and error details. Supports `failedOnly` filtering, `includeInputs`/`includeOutputs` toggles, and a `maxIterations` cap (default 50) to handle large loops safely. Essential for debugging loops that partially fail — previously you could only see the parent action status with no visibility into which iteration broke.
- **New `getFlowRunActionRepetitions` API method**: Calls the Power Automate `runs/{runId}/actions/{actionName}/repetitions` endpoint to retrieve iteration-level data for loop actions.
- **New types**: `FlowRunActionRepetition` and `FlowRunActionRepetitionProperties` with support for `repetitionIndexes` (scope + item index), `inputsLink`, `outputsLink`, and `iterationCount`.

### Changed
- **`get_run_actions` output format**: Each action now renders on its own block with structured sub-lines for Error, Inputs, Outputs, Tracked properties, and Retries — replacing the previous single-line format that truncated errors at 100 characters.
- **`getRunActionsTool` JSON Schema**: Now includes `includeInputs`, `includeOutputs`, and `actionName` properties to match the Zod validation schema.

### Upgrade Notes
- `npm install -g powerautomate-mcp@latest`. No app-registration, configuration, or workflow changes required.
- All v0.9.0 additions are additive and backwards-compatible. Existing `get_run_actions` calls continue to work — failed actions now automatically include I/O data without any parameter changes.
- Recommended debugging workflow: `get_run_actions` with `failedOnly: true` → identify the failed action → if it's inside a loop, call `get_run_action_repetitions` with the action name to see which iteration failed and why.

## [0.8.0] - 2026-05-06

### Added
- **`get_flow` `format` parameter (`"summary" | "json" | "both"`)**: The previous output rendered only top-level actions and silently dropped everything nested inside `Switch`/`If`/`Foreach`/`Scope` controls. Round-tripping a flow with nested branches through `get_flow` → `update_flow` lost the nested actions. The new `format="json"` mode returns the raw `flow.properties.definition` JSON with every nested action preserved; `format="both"` appends the JSON after the human-readable summary. The `summary` default is unchanged for back-compat. The summary output also now surfaces flow `description` and creator (owner). Use `format="json"` whenever you intend to call `update_flow` on a flow with nested controls.
- **`update_flow` `mergeActions` mode**: Set `mergeActions: true` to deep-merge the actions you provide onto the current flow definition instead of replacing wholesale. Recurses into `actions`/`cases`/`else`/`foreach` so siblings you didn't pass are preserved. Solves the wholesale-replace footgun where omitting any action caused it to be deleted.
- **`update_flow` `patchActions` (path-based, smallest payload)**: Pass a map of slash-separated paths to action values, e.g. `{"If_Recognized_Form/cases/Default/actions/Compose": {...}}`. Each entry surgically replaces (or, when value is `null`, deletes) one node in the action tree. Ideal when an LLM client has per-tool-input size pressure — a surgical edit is typically a fraction of the full action tree (~31% of the full payload in our smoke tests for a representative Switch with cases). `patchActions` is applied AFTER `mergeActions` so they compose.
- **`description` on `create_flow` and `update_flow`**: Optional `description` parameter sets the flow description shown in the Power Automate UI. On `update_flow`, an empty string clears the description; `undefined` leaves it unchanged. The field is also surfaced by `get_flow` in both summary and JSON output.
- **`list_flows` ownership filter**: New `scope` parameter (`"owned" | "shared" | "all"` — default `"all"`) filters results client-side by comparing `flow.properties.creator.id` against the current user's Azure AD object ID (extracted from the access token). Use `scope="shared"` to surface flows that have been shared with you that you didn't create. The new `includeOwner` flag (default `true`) tags each row with the owner display name plus an `[owned]` / `[shared]` indicator.

### Changed
- **`FlowProperties` and `CreateFlowRequest` types now include optional `description: string`** to match the Power Automate Flow Service API surface. Internal helper `getCurrentUserOid()` was added to `FlowManagementApi` to expose the current user's object ID for ownership filtering, derived from the existing access token (no extra Graph calls).

### Upgrade Notes
- `npm install -g powerautomate-mcp@latest`. No app-registration, configuration, or workflow changes required.
- All v0.8.0 additions are additive and backwards-compatible. Existing `get_flow` / `update_flow` / `create_flow` / `list_flows` calls continue to work exactly as before.
- Recommended workflow when editing a flow with nested controls: call `get_flow` with `format="json"` to capture the full definition, then call `update_flow` with either `mergeActions: true` (delta-only) or `patchActions` (surgical) to avoid resending the entire action tree.

## [0.7.9] - 2026-05-05

### Security
- **Bumped `undici` to ^6.24.0 and `@modelcontextprotocol/sdk` to ^1.26.0** to close 6 published advisories: SNYK-JS-UNDICI-15518064 (uncaught exception, high), SNYK-JS-UNDICI-15518068 (data amplification, high), SNYK-JS-UNDICI-15518070 (uncaught exception, high), SNYK-JS-UNDICI-15518061 (HTTP request smuggling, medium), SNYK-JS-UNDICI-15518072 (CRLF injection, medium), and SNYK-JS-MODELCONTEXTPROTOCOLSDK-15208843 (race condition, high). No behavior changes — minor/patch upgrades only. The remaining transitive advisory in `uuid` (SNYK-JS-UUID-16133035) is reachable only through `@azure/msal-node@2.x` and will be addressed alongside an msal-node major upgrade in a future release.

### Upgrade Notes
- `npm install -g powerautomate-mcp@latest`. No app-registration, configuration, or workflow changes required.

## [0.7.8] - 2026-04-30

### Fixed
- **Setup wizard failed silently when device-code flow was blocked at the tenant**: 0.7.7 fixed the `? undefined` prompt rendering, but on tenants where device-code flow itself is blocked, Microsoft also leaves `userCode` empty. The callback rendered `enter the code (code missing) to authenticate`, MSAL polled the token endpoint and got immediate `invalid_grant`, and the user got the cryptic `post_request_failed` message with no actionable next step. The setup wizard now detects an empty `userCode` and surfaces the three likely root causes in the error message: (1) Conditional Access blocking device-code grants, (2) app registration missing **Allow public client flows** (most common single fix — flip it under Authentication → Advanced settings in Azure Portal), or (3) corporate proxy stripping OAuth response fields. The device-code response shape is also logged at info level (non-PII fields only) so future tenant anomalies are diagnosable straight from `--debug` logs. Continues fixing [#9](https://github.com/rcb0727/powerautomate-mcp-docs/issues/9).

### Upgrade Notes
- `npm install -g powerautomate-mcp@latest`, then re-run `powerautomate-mcp --setup`. If the new error fires, the most common fix is **Allow public client flows** on your app registration.

## [0.7.7] - 2026-04-29

### Fixed
- **Setup wizard showed `? undefined` instead of the device code on some tenants**: When running `powerautomate-mcp --setup`, the device-code prompt could render as `? undefined` instead of showing the URL and code to enter on `microsoft.com/devicelogin`. With no code visible, the 15-minute window expired and the wizard failed with the misleading error `Failed to authenticate: ... invalid_grant`. Affected tenants tended to be non-English locales and stricter B2B configurations where Microsoft's authentication response did not include the pre-formatted prompt string our code expected. The setup wizard now builds the prompt itself from the user code + verification URL when Microsoft omits it, so the prompt always renders correctly. Fixes [#9](https://github.com/rcb0727/powerautomate-mcp-docs/issues/9).

### Upgrade Notes
- Run `npm install -g powerautomate-mcp@latest`, then re-run `powerautomate-mcp --setup`. No app-registration or permission changes are needed.

## [0.7.6] - 2026-04-23

### Fixed
- **Dataverse URL constructed from environment GUID instead of `domainName`**: `createMcpServer` now resolves the Dataverse hostname at startup by calling the BAP admin API (`GET /providers/Microsoft.BusinessAppPlatform/scopes/admin/environments/{envId}`) and using `properties.linkedEnvironmentMetadata.instanceUrl`. Every Dataverse-dependent tool (`list_dataverse_tables`, `list_solutions`, `query_dataverse_rows`, `create_dataverse_row`, etc.) was failing with `ENOTFOUND <envId>.crm.dynamics.com` on tenants where the org's unique name differs from the environment GUID — i.e. the common case. A `dataverseUrl` override can also be set per environment in `config.json`; the region-based guess is kept only as a last-resort fallback. Fixes [#6](https://github.com/rcb0727/powerautomate-mcp-docs/issues/6).
- **`get_run_actions` / `cancel_run` / `resubmit_run` rejected valid Power Automate run IDs**: `validateRowId` enforces a strict GUID pattern, but flow run IDs are uppercase alphanumeric (`085842471510537964096537047XXCU11`), not GUIDs. Introduced `validateFlowRunId` (alphanumeric, 10-128 chars) and routed the three run-handling sites through it. Flow-ID / connection-ID / approval-ID validation is unchanged. Fixes [#7](https://github.com/rcb0727/powerautomate-mcp-docs/issues/7).
- **`list_dataverse_tables` failed with `0x80060888: The query parameter $orderby is not supported`**: Dataverse `EntityDefinitions` rejects `$orderby` (and `$top`) on the metadata collection. Removed the server-side `$orderby` / `$top` params and now sort + cap the result client-side by `LogicalName`. Fixes [#8](https://github.com/rcb0727/powerautomate-mcp-docs/issues/8).

### Upgrade Notes
- No action needed for most users — the Dataverse URL is now auto-resolved at startup via the BAP admin API using the existing `https://api.bap.microsoft.com` permission.
- If you prefer to pin the Dataverse hostname explicitly, add `"dataverseUrl": "<org>.crm.dynamics.com"` to the environment block in `config.json`.

## [0.7.5] - 2026-04-20

### Fixed
- **Linux setup crash when `libsecret` runtime is missing**: Documented the missing-library failure more clearly and aligned the install instructions with the actual runtime packages users need for `powerautomate-mcp --setup`.
- **Linux token cache fallback docs**: Clarified that Linux uses `libsecret` when available and otherwise falls back to a `0o600` file cache.

## [0.7.4] - 2026-03-27

### Fixed
- **BAP Admin API missing from app registration**: Added `0e0bf3cc-3078-4fd4-9ef3-cb6dc0245b10` (Business Application Platform) with `user_impersonation` to `REQUIRED_RESOURCE_ACCESS`. App registrations created by `--setup` now include all 5 required APIs (Graph, Flow Service, PowerApps Service, BAP Admin, Dynamics CRM).
- **PowerApps Service missing from app registration**: Added `475226c6-020e-4fb2-8a90-7a972cbfc1d4` with `User` delegated permission. Fixes `list_connections` and connector tools failing with AADSTS65001 on enterprise tenants.
- **Unexpected second device code prompt during setup**: Added `tryGetTokenForResourceSilent()` to auth providers — attempts silent-only token acquisition and returns null on failure instead of falling back to interactive device code. Post-sign-in resource probes no longer trigger confusing second auth prompts.

### Upgrade Notes
- Run `powerautomate-mcp --setup` after updating.
- For existing app registrations, add **PowerApps Service** and **BAP Admin API** permissions in Entra, then re-grant admin consent.
- Fixes [#3](https://github.com/rcb0727/powerautomate-mcp-docs/issues/3) and [#4](https://github.com/rcb0727/powerautomate-mcp-docs/issues/4)

## [0.7.2] - 2026-03-25

### Fixed
- **AADSTS650057 during setup**: Added Business Application Platform (BAP) API (`0e0bf3cc-3078-4fd4-9ef3-cb6dc0245b10`) to `REQUIRED_RESOURCE_ACCESS` in the app registration created by `--setup`. Without this, token acquisition for `https://api.bap.microsoft.com` failed with "Invalid resource" error.
- **Unexpected second device code prompt during setup**: After initial sign-in, secondary resource probes (BAP, PowerApps) that failed silent token acquisition would fall through to an interactive device code flow, presenting the user with a confusing second auth prompt. Both `device-code.ts` and `wam-broker.ts` now detect that an account already exists and throw immediately instead of launching another interactive flow.

### Upgrade Notes
- Run `powerautomate-mcp --setup` after updating to add BAP API permissions to your existing app registration.
- Fixes [#4](https://github.com/rcb0727/powerautomate-mcp-docs/issues/4)

## [0.7.1] - 2026-03-23

### Fixed
- **AADSTS65001 consent error on admin tools**: Setup wizard now pre-caches tokens for `api.bap.microsoft.com` and `service.powerapps.com` during initial authentication. Previously, only `service.flow.microsoft.com` was consented, causing silent token acquisition to fail at runtime for tools that call the Power Platform Admin API or PowerApps API.
- **RouteNotFound on `get_environment` and other admin tools**: Switched Power Platform Admin API base URL from `api.powerplatform.com` (which requires geography-based routing) to `api.bap.microsoft.com` (the correct global BAP admin endpoint). Added automatic `/scopes/admin/` path prefix insertion for all `Microsoft.BusinessAppPlatform` API paths.
- **Token domain allowlist incomplete**: Added `powerplatform.com` and `powerapps.com` to `ALLOWED_TOKEN_DOMAINS`. Token requests for these resources were previously rejected with "Token resource not in allowlist" before the HTTP call was even made.

### Upgrade Notes
- After updating, run `powerautomate-mcp --setup` again to re-authenticate with the new scopes.
- No changes to Azure AD app registration permissions are required.

## [0.7.0] - 2026-03-14

### Added
- **Expression escaping for flow creation** — HTTP action `body` objects containing `@{}` template expressions or `@`-prefixed keys (e.g., `@odata.type`) are automatically converted to runtime string expressions using `json(concat(...))`. This fixes "invalid template" errors when creating complex flows programmatically via `create_flow` or `update_flow`.
- **`preprocessFlowActions()` utility** — Walks the entire action tree (including nested Foreach/If/Switch/Scope actions) and escapes expression-in-object patterns before sending to the Logic Apps API.
- **Connector parameter escaping** — Same expression escaping applied to OpenApiConnection `parameters` objects, not just HTTP `body`.

### Fixed
- **If/Switch condition format** — The structured object format `{"not": {"contains": [...]}}` is now documented and validated. The string expression format `{"type": "Expression", "value": "@..."}` was incorrectly accepted by validation but rejected by the API.
- **Complex flow creation via API** — Flows with Graph API email attachments (`@odata.type`), nested expressions in JSON bodies, and multi-level foreach loops can now be created programmatically without manual UI editing.

### Developer Notes
- New file: `src/utils/expression-escape.ts` — `containsExpressions()`, `objectToStringExpression()`, `preprocessFlowActions()`
- Modified: `src/tools/create-flow.ts`, `src/tools/update-flow.ts` — preprocess actions before API submission


## [0.6.0] - 2026-03-13

### Added
- **CLI: `--version` / `-v`** — Print installed version and exit
- **CLI: `--validate`** — Verify config, authentication, and API connectivity in one shot, then exit
- **CLI: `--update`** — Self-update via npm registry. Checks latest published version, detects install method (npm/yarn/pnpm/npx), runs the appropriate update command
- **CLI: `--env <name>`** — Override the default environment at startup without editing config.json
- **CLI: `--config <path>`** — Use an alternate config file path
- **CLI: `--debug`** — Enable debug-level logging at startup
- **Startup update notice** — Non-blocking background check against npm registry on every server start; prints "Update available" to stderr if a newer version exists
- **Flow search by name** — `list_flows` tool accepts a `search` parameter for case-insensitive name filtering
- **Environment variable interpolation** — Config values support `${VAR}` patterns resolved from environment variables at load time
- **Test suite** — 64 tests across 8 test files covering validators, expression parsing, config loading, CLI features

### Fixed
- **Nested action scope validation** — Control actions (If, Foreach, Switch, Scope, Until) now validate `runAfter` references within local scope instead of top-level actions
- **Circular dependency detection** — Now applied recursively to nested action scopes
- **Bare expression detection** — `@triggerBody()`, `@outputs()`, `@utcNow()` expressions now detected (previously only `@{...}` wrapped form)
- **retryPolicy check location** — Best practices validator checks `inputs.retryPolicy` where Power Automate stores it
- **429 rate limit handling** — All API clients detect HTTP 429 and throw `RateLimitError` with retry-after parsing
- **Setup wizard tenantId** — Reads from existing config during re-auth instead of defaulting to "common"

## [0.5.3] - 2026-02-23

### Changed
- **Dynamic app registration**: Removed hardcoded `PUBLISHED_APP_CLIENT_ID` — each tenant now provides its own Entra app Client ID via environment variable (`PA_MCP_CLIENT_ID`), config file, Azure CLI auto-create, or manual prompt during setup. No more silent fallback to a shared app registration.
- **`PA_MCP_CLIENT_ID` env var**: New environment variable overrides config file `auth.clientId` at both setup and runtime — useful for CI/CD and multi-tenant deployments
- Setup wizard now prompts for manual Client ID entry when Azure CLI is unavailable (instead of falling back to a hardcoded ID)

## [0.5.2] - 2026-02-23

### Fixed
- **AADSTS65006 on device code auth**: Flow Service scope GUIDs (`Flows.Read.All`, `Flows.Manage.All`) were invalid — replaced with correct IDs from the Microsoft Flow Service principal
- **Device code flow blocked**: App registration was missing `isFallbackPublicClient = true` — added `--is-fallback-public-client` flag to `az ad app create` in setup wizard
- **Missing Flow Service scopes**: Added `Activity.Read.All` and `Approvals.Manage.All` delegated permissions for run history and approval tools

## [0.5.1] - 2026-02-23

### Fixed
- **Incomplete app registration scopes**: Added Graph `Sites.ReadWrite.All`, `Files.ReadWrite.All`, and Dynamics CRM `user_impersonation` to `REQUIRED_RESOURCE_ACCESS` — previously only Graph `User.Read` and Flow Service scopes were provisioned, causing AADSTS65006 errors when accessing SharePoint/Dataverse tools
- **AADSTS50011 redirect URI mismatch**: Setup wizard now uses Device Code Flow instead of interactive browser auth — avoids random localhost port issues on strict corporate tenants with Conditional Access policies
- **Linux token cache failure on KDE/non-GNOME**: Added native filesystem cache fallback (`NativeFileCachePlugin`) when `msal-node-extensions` `PersistenceCreator` fails — handles KDE KWallet, headless servers, WSL without keyring; writes to `token-cache.bin` with 0o600 permissions
- **Race condition on setup exit**: Added 1.5s flush delay before `process.exit(0)` after setup wizard completes — prevents truncated/empty token cache files from async MSAL cache writes being killed mid-flight

## [0.5.0] - 2026-02-05

### Security — 3 rounds of penetration testing, 30+ findings fixed
- **SSRF protection**: IPv4, IPv6, IPv6-mapped IPv4, IPv4-compatible IPv6, expanded loopback, octal/hex/decimal IP notation, ULA (fc00::/7), link-local (fe80::/10)
- **OData injection**: Tautology detection expanded to all comparison operators (lt/gt/le/ge/ne), parenthesized forms, arithmetic operators (add/sub/mul/div), OData function calls (length/concat/substring/etc.)
- **Path traversal**: NFKC Unicode normalization (collapses fullwidth `．．／` → `../`), bidi control character stripping (RLO U+202E etc.), zero-width character removal, null byte rejection, double-encoding defense
- **Domain validation**: Proper domain boundary checks (prevents `evil-dynamics.com` matching `dynamics.com`), trailing dot normalization, ASCII-only enforcement against homoglyph attacks
- **Error sanitization**: Recursive sensitive key redaction (tokens, passwords, secrets, credentials), underscore-separated key variants, stack trace suppression in fatal handler
- **Prototype pollution defense**: `__proto__`/`constructor`/`prototype` key rejection in account cache deserialization, type validation on all cached fields
- **Input limits**: 2MB max on MCP tool inputs, 20-level object depth limit (prevents stack exhaustion DoS)
- **Config hardening**: Symlink rejection on config file (non-Windows), world-readable permission warnings, SQLite cache file permissions (0o600)
- **MSAL log suppression**: Verbose/Trace level messages dropped from MSAL callback to prevent internal data leakage
- **Token domain allowlist**: Moved to bare-domain format with `isAllowedTokenDomain()` function using proper suffix matching

### Fixed
- HTTP transport restored with full Streamable HTTP MCP implementation (session management, health endpoint, localhost-only binding, graceful shutdown)

## [0.4.0] - 2026-02-05

### Added
- **Power Apps tools** (16 new): list/get/publish canvas apps, list/get model-driven apps, list/get app versions, list/get app connections, list/get app permissions, share/remove app permissions, get app audit log, set app owner
- **Environment Lifecycle tools** (8 new): list/get/create/delete/copy/reset/backup/restore environments
- **DLP Policy tools** (6 new): list/get/create/update/delete DLP policies, list connectors by policy
- **Solutions ALM tools** (6 new): list/get/export/import solutions, list solution components, add component to solution
- **Managed Environments tools** (4 new): enable/disable managed environments, get/set governance settings
- **Capacity tools** (5 new): get tenant capacity, list environment capacity, list add-ons, get storage breakdown, get capacity alerts
- New API clients: `PowerAppsApi`, `PowerPlatformAdminApi`
- **Setup wizard with integrated app registration** (`--setup` handles everything):
  - Auto-creates app registration via Azure CLI (or prompts for manual Client ID)
  - Interactive browser-based sign-in
  - Admin consent URL auto-opened in browser
  - Environment discovery and selection
  - Config file creation with proper permissions
- 45 new MCP tools (108 total)

### Fixed
- Resolved ~50 pre-existing TypeScript strict-mode errors across the codebase

## [0.3.3] - 2026-02-04

### Security
- GUID validation on all flow/run/approval/connection IDs before URL interpolation in FlowManagementApi
- GUID validation on Dataverse `getSolution`, `getSolutionFlow`, `setSolutionFlowState`, `getCanvasApp`, `getAIModel`
- Timing-safe API key comparison (`crypto.timingSafeEqual`) for HTTP transport
- Handle `X-API-Key` header array type safely
- Validate Dataverse environment URL in constructor (not just `setEnvironmentUrl`)
- Validate OpenAPI import host URL with `validateHttpsUrl`
- Block `@{`/`}@` injection in `conditions.custom()` expressions
- Consume response body on 401 path to prevent connection pool leaks
- Consume response body on DELETE success path in connector-metadata
- Restrict OData filter character set to ASCII-only (prevent Unicode bypass)
- Deep wildcard `**` log redaction for nested auth headers/tokens
- Additional redacted fields: `refreshToken`, `idToken`, `client_secret`, `apiKey`
- Sanitize `handleBinaryResponse` error details before propagation
- Sanitize Dataverse init error via `sanitizeErrorMessage` before storing on globalThis
- Log outer `clearAccountCache` deletion error before fallback
- Streaming response body consumption with size limit (prevents OOM before size check)
- MSAL logger forwarding to pino (errors/warnings surfaced, PII filtered)

## [0.3.2] - 2026-02-04

### Security
- Remove API key via query parameter — header-only authentication for HTTP transport
- Block Power Automate expression injection (`@{`, `}@`) in trigger condition values
- Validate `$select` on Dataverse `getRow()` to prevent OData injection
- Remove response body from binary download error logs to prevent data leakage

## [0.3.1] - 2026-02-04

### Security
- Input validation on all Graph API methods (site, list, drive, item IDs) via `validateGraphId`
- Input validation on all Dataverse API methods (logical names, entity set names, row IDs)
- SharePoint hostname validation to prevent SSRF (`validateSharePointHostname`)
- File path sanitization blocks path traversal (`..`), backslashes, and absolute paths
- 100MB download size limit on binary file responses to prevent memory exhaustion
- OData filter validation applied to all Dataverse query endpoints

## [0.3.0] - 2026-02-04

### Added
- **Dataverse CRUD**: Full table/row operations via OData Web API
  - `list_dataverse_tables` - List all tables (entities) with metadata
  - `get_dataverse_table` - Get table schema including all column definitions
  - `query_dataverse_rows` - Query rows with OData filtering, selecting, ordering
  - `get_dataverse_row` - Get a single row by ID
  - `create_dataverse_row` - Create new rows with field validation
  - `update_dataverse_row` - Update existing rows (partial updates)
  - `delete_dataverse_row` - Delete rows with confirmation guard
- **SharePoint Sites & Lists** via Microsoft Graph v1.0
  - `search_sharepoint_sites` - Search for SharePoint sites by name
  - `get_sharepoint_site` - Get site by ID or hostname/path
  - `list_sharepoint_lists` - List all lists and libraries in a site
  - `get_sharepoint_list_columns` - Get column definitions for a list
  - `list_sharepoint_items` - Get list items with OData filtering
  - `create_sharepoint_item` - Create new list items
  - `update_sharepoint_item` - Update list item fields
  - `delete_sharepoint_item` - Delete list items with confirmation
- **SharePoint Files** via Microsoft Graph
  - `list_sharepoint_files` - List files in document libraries
  - `upload_sharepoint_file` - Upload files up to 4MB (simple upload)
  - `get_sharepoint_file_content` - Download file content (text/binary)
- **Flow Builder enhancements**
  - Dataverse (current environment) connector support (`shared_commondataserviceforapps`)
  - `dataverseRowCreated` / `dataverseRowModified` trigger builders
  - `getDataverseRows`, `createDataverseRowAction`, `updateDataverseRowAction`, `deleteDataverseRowAction` action builders
  - `deleteSharePointItem`, `getSharePointFileContentAction`, `createSharePointFile` action builders
  - `dataverseCurrent()` fluent connection reference builder
- 18 new MCP tools (63 total), ~20 new API methods

## [0.2.0] - 2026-02-03

### Added
- HTTP transport mode via `--http` flag for ChatGPT and remote MCP client compatibility
- `--port <N>` flag to configure HTTP listen port (default: 3000)
- Stateless Streamable HTTP transport on `POST /mcp` endpoint per MCP spec
- ChatGPT setup instructions in INSTALL.md

## [0.1.1] - 2026-02-03

### Fixed
- Default connection source changed from `Invoker` to `Embedded` to resolve ConnectionAuthorizationFailed errors when creating flows
- OData filter validation now catches case-insensitive tautology bypasses (`oR 1 eq 1`)
- Added UNION and SELECT...FROM pattern blocking in OData filter validation

## [0.1.0] - 2026-02-02

### Added
- Initial release
- 40+ MCP tools for Power Automate flow management
- Flow creation, testing, debugging, and validation
- Interactive flow planning wizard (`plan_flow`, `build_flow`)
- Connector search with 400+ connectors and schema lookup
- Custom connector creation, update, and import from OpenAPI specs
- Expression help reference for Power Automate expressions
- Flow cloning across environments
- Approval management (list, respond)
- Desktop flow and machine management
- Dataverse solution and canvas app listing
- Excel file search and inspection

### Security
- Secure token storage via DPAPI (Windows), Keychain (macOS), libsecret (Linux)
- OData injection protection with pattern detection
- FTS5/SQL injection prevention in connector search
- Shell command injection prevention (execFile over exec)
- PII sanitization in error messages
- Input validation on all user-supplied parameters
- File permission hardening (0o600) for cached credentials
- No plaintext token fallback on Linux
