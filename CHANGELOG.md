# Changelog

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
