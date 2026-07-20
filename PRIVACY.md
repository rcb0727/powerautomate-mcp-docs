# Privacy Policy — Power Automate MCP

**Effective date:** July 20, 2026
**Applies to:** the `powerautomate-mcp` server (npm package and desktop-extension bundle), in all versions.

The short version: **this software runs entirely on your computer, collects nothing about you, and sends data only to Microsoft — under your own account, at your direction.** The project has no servers, no telemetry, and no access to anything you do.

## What the software is

Power Automate MCP is a local MCP (Model Context Protocol) server that lets an AI assistant work with Microsoft Power Platform (Power Automate, SharePoint, Excel, Dataverse/Dynamics 365, Power Apps, Power Pages) on your behalf. It runs as a process on your machine, launched by your AI application.

## Data collection

**We collect nothing.** The project operates no backend services, no analytics, no telemetry, no crash reporting, and no usage tracking. No data about you, your organization, your prompts, or your Power Platform content is ever transmitted to the project's maintainers.

## Where your data goes

When you use the tools, the server communicates only with:

1. **Microsoft services** — the Microsoft identity platform (`login.microsoftonline.com`) for sign-in, and Microsoft's Power Platform, Dataverse, and Microsoft Graph APIs to perform the actions you request. Everything happens under your own Microsoft work account and is limited to what that account can already do. Microsoft's handling of this data is governed by the [Microsoft Privacy Statement](https://privacy.microsoft.com/privacystatement) and your organization's agreements with Microsoft.
2. **npm's registry** (`registry.npmjs.org`) — a version check to tell you when an update is available. The request contains no personal data.

That's the complete list. The optional HTTP mode (`--http`) additionally runs a local web endpoint that you control and secure yourself (see the install guide).

Your conversations with your AI assistant are handled by that assistant's provider (for example, Anthropic for Claude), not by this software.

## What is stored on your machine

| Data | Where | Purpose |
|------|-------|---------|
| Sign-in tokens | Your operating system's secure storage (macOS Keychain, Windows DPAPI, Linux libsecret) | Staying signed in to Microsoft |
| Account reference (your username and directory IDs) | `account-cache.json` in the app's config folder | Silent sign-in between sessions |
| Configuration (app registration ID, environment selection) | `config.json` in the app's config folder | Remembering your setup |
| Connector metadata cache | `schema-cache.sqlite` in the app's config folder | Faster connector lookups; contains Microsoft connector schemas, not your data |

Config folder locations: `~/Library/Application Support/powerautomate-mcp` (macOS), `%LOCALAPPDATA%\powerautomate-mcp` (Windows), `~/.config/powerautomate-mcp` (Linux). Logs go to the process's error stream (visible to your AI app), not to files.

## Third-party sharing

None. The software shares data with no one other than the Microsoft endpoints listed above, which it contacts solely to carry out your requests.

## Data retention and deletion

Everything listed above lives on your machine and is yours to delete at any time: remove the config folder and the `powerautomate-mcp` entry in your OS keychain/credential manager, or simply uninstall. Nothing is retained anywhere else, because nothing is stored anywhere else. Data held by Microsoft (your flows, files, records) is subject to your organization's Microsoft retention policies, unchanged by this software.

## Security practices

Sign-in uses Microsoft's standard OAuth 2.0 device authorization flow — the software never sees or asks for your password, and multi-factor authentication applies as normal. Tokens are stored in OS-encrypted storage. API error messages are sanitized before display to avoid leaking identifiers. The permission scopes requested are limited to the feature set you select at setup.

## Changes to this policy

Changes are published to this page with an updated effective date and noted in the project [changelog](https://github.com/rcb0727/powerautomate-mcp-docs/blob/main/CHANGELOG.md).

## Contact

Questions or concerns: open an issue at [github.com/rcb0727/powerautomate-mcp-docs/issues](https://github.com/rcb0727/powerautomate-mcp-docs/issues).
