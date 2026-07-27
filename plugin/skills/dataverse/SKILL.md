---
name: dataverse
description: Query and modify Dataverse data and solutions. Use for Dataverse or Dynamics 365 tables, rows, records, solutions, or model-driven apps.
---

# Dataverse

## Tools
`list_dataverse_tables` · `get_dataverse_table` · `query_dataverse_rows` · `get/create/update/delete_dataverse_row` · `list_solutions` · `export_solution` · `import_solution` · `clone_solution` · `add/remove_solution_component` · `publish_all_customizations` · model-driven app tools

## Reading
1. `list_dataverse_tables` to find the logical name (it is rarely what the user calls it — "Accounts" is `account`).
2. `get_dataverse_table` for its columns before writing a query, so you filter on fields that exist.
3. `query_dataverse_rows` with an OData filter. Select only the columns you need.

## Writing
- Confirm destructive operations with the user first. `delete_dataverse_row` cannot be undone.
- Lookups are set with `@odata.bind`, not a bare GUID.

## Solutions
Export and import are asynchronous. `import_solution` can overwrite unmanaged customizations — treat it as destructive and say so before running it.

## Note
Dataverse record IDs are GUIDs but are not RFC 4122 — a version nibble outside the normal range is valid, not corrupt.
