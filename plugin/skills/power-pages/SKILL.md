---
name: power-pages
description: Configure and manage Power Pages sites. Use for Power Pages websites, portals, site configuration, custom domains, certificates, WAF, or security scans.
---

# Power Pages

Two distinct surfaces — know which one the request needs.

## Site configuration (content, stored in Dataverse)
`list_powerpages_sites` · `get_powerpages_site` · `list_powerpages_components` · `create/update/delete_powerpages_component` · `manage_powerpages_relationship` · `upload_powerpages_webfile_content`

Pages, web roles, table permissions, snippets, templates. These need the **Dynamics CRM** permission.

## Site management (hosting and lifecycle)
`list_powerpages_websites` · `create/delete/restart_powerpages_website` · custom domains · certificates · SSL bindings · WAF · security scans · `start`/`stop` · trial conversion

These call the Power Platform API and need **PowerPages.Websites.Read/Write**.

## Sequence for provisioning
1. `create_powerpages_website` starts an asynchronous operation.
2. Poll `get_powerpages_operation_status` — do not assume it finished.
3. Configure content through the Dataverse tools once the site exists.

## Notes
- `pac_pages_*` tools wrap the PAC CLI for deployment workflows (upload, download, clone). They can overwrite local files and deployed content — say what will be overwritten before running one.
- Security scans (`start_powerpages_quick_scan`, `start_powerpages_deep_scan`) are asynchronous; fetch the report separately.
