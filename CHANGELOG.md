# Changelog

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
