# Installation Guide

This MCP server uses the **stdio** transport and works with any MCP-compatible AI client.

## Prerequisites

- Node.js 20+
- Microsoft 365 work account with Power Automate access
- Microsoft Entra app registration (see [README](README.md#microsoft-entra-app-registration-required))
- **Linux only**: libsecret for secure token storage
  ```bash
  # Ubuntu/Debian
  sudo apt-get install libsecret-1-dev gnome-keyring

  # Fedora/RHEL
  sudo dnf install libsecret-devel gnome-keyring
  ```

## Install from npm

```bash
npm install -g powerautomate-mcp
```

## Updating

```bash
npm install -g powerautomate-mcp
```

Check your installed version:

```bash
powerautomate-mcp --help
```

After updating, restart your AI client (Claude Desktop, Cursor, etc.) to pick up the new version. Claude Code picks it up automatically on the next session.

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
