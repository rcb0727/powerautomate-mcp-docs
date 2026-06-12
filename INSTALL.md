# Installation Guide

**Docs:** [Overview](https://github.com/rcb0727/powerautomate-mcp-docs/blob/main/README.md) · **Installation & Upgrading** · [Changelog](https://github.com/rcb0727/powerautomate-mcp-docs/blob/main/CHANGELOG.md) · [Report an issue](https://github.com/rcb0727/powerautomate-mcp-docs/issues)

This MCP server uses the **stdio** transport and works with any MCP-compatible AI client.

**On this page:** [Prerequisites](#prerequisites) · [Install](#install-from-npm) · [Updating](#updating) · [First-Time Setup](#first-time-setup) · [Configure Your AI Client](#configure-your-ai-client) · [Enterprise Tenants](#enterprise-tenants-with-strict-consent-policies)

## Prerequisites

- Node.js 20+
- Microsoft 365 work account with Power Automate access
- Microsoft Entra app registration (see [README](https://github.com/rcb0727/powerautomate-mcp-docs/blob/main/README.md#microsoft-entra-app-registration))
- **Linux only**: libsecret for secure token storage
  ```bash
  # Ubuntu/Debian runtime
  sudo apt-get install libsecret-1-0 gnome-keyring

  # Fedora/RHEL runtime
  sudo dnf install libsecret gnome-keyring
  ```

  If you build native modules from source, also install the development package:

  ```bash
  # Ubuntu/Debian
  sudo apt-get install libsecret-1-dev

  # Fedora/RHEL
  sudo dnf install libsecret-devel
  ```

  If setup fails with `libsecret-1.so.0: cannot open shared object file`, the
  runtime package above is missing.

## Install from npm

```bash
npm install -g powerautomate-mcp
```

## Updating

> **Stop running MCP instances before you upgrade.** Quit your AI clients (Claude Desktop, Cursor, VS Code, etc.) and stop any `powerautomate-mcp --http` servers first. A running process keeps the old version loaded in memory, and on Windows it can hold file locks in npm's global directory — causing `EBUSY`/`EPERM` errors and a half-upgraded install that's confusing to debug.

1. Quit your AI clients and stop any `--http` server instances
2. Upgrade:
   ```bash
   npm install -g powerautomate-mcp@latest
   ```
3. Verify the new version:
   ```bash
   powerautomate-mcp --version
   ```
4. Relaunch your AI client — it starts the new version automatically. Claude Code picks it up on the next session.

`powerautomate-mcp --update` does the npm upgrade for you — the same rule applies: close clients first.

See the [Changelog](https://github.com/rcb0727/powerautomate-mcp-docs/blob/main/CHANGELOG.md) for what's new and any version-specific upgrade notes.

## First-Time Setup

```bash
powerautomate-mcp --setup
```

This interactive wizard will:
1. Sign you in via browser
2. Discover your Power Automate environments
3. Create the configuration file

## Configure Your AI Client

- [Claude Desktop](#claude-desktop)
- [Claude Code (CLI)](#claude-code-cli)
- [VS Code (GitHub Copilot)](#vs-code-github-copilot)
- [Cursor](#cursor)
- [Google Gemini CLI](#google-gemini-cli)
- [ChatGPT (OpenAI)](#chatgpt-openai)
- [Other MCP Clients](#other-mcp-clients)

---

### Claude Desktop

Add to your Claude Desktop config file:

| OS | Config Path |
|----|-------------|
| macOS | `~/Library/Application Support/Claude/claude_desktop_config.json` |
| Windows | `%APPDATA%\Claude\claude_desktop_config.json` |
| Linux | `~/.config/Claude/claude_desktop_config.json` |

```json
{
  "mcpServers": {
    "powerautomate": {
      "command": "powerautomate-mcp"
    }
  }
}
```

Restart Claude Desktop. The Power Automate tools will appear automatically.

---

### Claude Code (CLI)

Add the server from your terminal:

```bash
claude mcp add powerautomate -- powerautomate-mcp
```

Or add it to your project's `.mcp.json`:

```json
{
  "mcpServers": {
    "powerautomate": {
      "command": "powerautomate-mcp"
    }
  }
}
```

---

### VS Code (GitHub Copilot)

Add to your workspace `.vscode/mcp.json` (or user-level `mcp.json`):

```json
{
  "servers": {
    "powerautomate": {
      "type": "stdio",
      "command": "powerautomate-mcp"
    }
  }
}
```

Or open the Command Palette (`Ctrl+Shift+P`) and run **MCP: Add Server**.

---

### Cursor

Add to `~/.cursor/mcp.json` (global) or `.cursor/mcp.json` (project):

```json
{
  "mcpServers": {
    "powerautomate": {
      "command": "powerautomate-mcp"
    }
  }
}
```

Restart Cursor to pick up the new server.

---

### Google Gemini CLI

Add to `~/.gemini/settings.json`:

```json
{
  "mcpServers": {
    "powerautomate": {
      "command": "powerautomate-mcp"
    }
  }
}
```

---

### ChatGPT (OpenAI)

ChatGPT requires a remote HTTPS MCP endpoint. This server supports that via the `--http` flag.

**1. Start the server in HTTP mode:**

```bash
powerautomate-mcp --http --port 3000
```

This starts the MCP server with Streamable HTTP transport at `http://localhost:3000/mcp`.

**2. Expose via tunnel (pick one):**

```bash
# ngrok
ngrok http 3000

# Cloudflare Tunnel
cloudflared tunnel --url http://localhost:3000
```

Copy the HTTPS URL (e.g. `https://abc123.ngrok-free.app`).

**3. Add to ChatGPT:**

1. Open [ChatGPT](https://chat.openai.com) → Settings → MCP Servers
2. Click **Add Server**
3. Enter URL: `https://your-tunnel-url.ngrok-free.app/mcp`
4. Save

The Power Automate tools will appear in ChatGPT's tool picker.

> **Security**: The tunnel exposes your local MCP server to the internet. Only run it while actively using ChatGPT. Stop the server and tunnel when done.

---

### Other MCP Clients

**Stdio transport** (default — for local clients):

```bash
powerautomate-mcp
```

**HTTP transport** (for remote/web clients):

```bash
powerautomate-mcp --http --port 3000
```

This starts a Streamable HTTP server on `POST /mcp` compatible with any MCP client that supports the HTTP transport.


## Enterprise Tenants with Strict Consent Policies

If your tenant requires admin consent for all applications:

1. **Add required API permissions to your app registration** in Microsoft Entra:
   - Microsoft Graph: `User.Read`, `Sites.ReadWrite.All`, `Files.ReadWrite.All`
   - Flow Service (`7df0a125-d3be-4c96-aa54-591f83ff541c`): `Flows.Read.All`, `Flows.Manage.All`, `Activity.Read.All`, `Approvals.Manage.All`
   - PowerApps Service (`475226c6-020e-4fb2-8a90-7a972cbfc1d4`): `User`
   - Dynamics CRM (`00000007-0000-0000-c000-000000000000`): `user_impersonation`

2. **Grant admin consent** for all permissions via:
   ```
   https://login.microsoftonline.com/{tenant-id}/adminconsent?client_id={your-client-id}
   ```

3. Re-run `powerautomate-mcp --setup` to authenticate.

Without the PowerApps Service permission, `list_connections` and other connector tools will fail with AADSTS65001.
