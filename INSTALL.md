# Installation Guide

**Docs:** [Overview](https://github.com/rcb0727/powerautomate-mcp-docs/blob/main/README.md) · **Installation & Upgrading** · [Changelog](https://github.com/rcb0727/powerautomate-mcp-docs/blob/main/CHANGELOG.md) · [Report an issue](https://github.com/rcb0727/powerautomate-mcp-docs/issues)

This guide gets you from zero to "ask your AI app to build a flow." Pick the path that sounds like you — you don't need to read the whole page.

## Choose your path

| You are… | Go to |
|----------|-------|
| 🟢 **Not very technical** — you just want it working | [Easy Path](#easy-path-3-steps) |
| 🔵 **A developer** — comfortable in a terminal | [Fast Path](#fast-path-developers) |
| 🟣 **An IT admin** — setting this up for yourself or your org | [Admin & enterprise setup](#admin--enterprise-setup) |
| ❓ Stuck on something | [Troubleshooting](#troubleshooting) · [Glossary](#glossary) |

New to any of this? The [Glossary](#glossary) explains MCP, app registration, tenant, and consent in one line each.

---

## Before you start

You need three things. The Easy Path checks all of them for you, but here's the full list:

1. **A Microsoft 365 *work* account** with Power Automate access (your work email — not a personal @outlook.com).
2. **An AI app that supports MCP** — Claude Desktop, Claude Code, Cursor, VS Code (Copilot), Gemini CLI, or ChatGPT. If you have one open right now, you're set.
3. **Node.js 20 or newer** — this is the engine the server runs on. Install steps below.

### Install Node.js (one-time)

**Check if you already have it.** Open a terminal (see below) and run:

```bash
node --version
```

If it prints `v20.x.x` or higher, skip ahead. If it says "command not found" or a number below 20:

- **Windows & macOS:** download the **LTS** installer from [nodejs.org](https://nodejs.org) and run it. Click through the defaults.
- **macOS with Homebrew:** `brew install node`
- **Linux:** use [nodejs.org](https://nodejs.org), your distro's package manager, or [nvm](https://github.com/nvm-sh/nvm).

### How to open a terminal

- **Windows:** press the **Start** button, type **PowerShell**, press Enter.
- **macOS:** press **Cmd + Space**, type **Terminal**, press Enter.
- **Linux:** press **Ctrl + Alt + T**, or search **Terminal** in your apps.

> **Linux only — secure password storage:** install libsecret so your sign-in token is stored safely.
> ```bash
> sudo apt-get install libsecret-1-0 gnome-keyring   # Ubuntu/Debian
> sudo dnf install libsecret gnome-keyring           # Fedora/RHEL
> ```
> If setup later says `libsecret-1.so.0: cannot open shared object file`, this package is missing.

---

## Easy Path (3 steps)

Open a terminal and run these one at a time.

### Step 1 — Install the server

```bash
npm install -g powerautomate-mcp
```

✅ **You should see** a few lines ending in something like `added 1 package`. No red `ERR!` lines.

> Hit a permission error (`EACCES`) or `command not found` afterward? Skip the global install and use the no-install option instead — jump to [Troubleshooting → install problems](#install-problems). Everything below still works.

### Step 2 — Run setup

```bash
powerautomate-mcp --setup
```

This wizard walks you through everything:

1. **App registration** — created automatically, or paste one if your admin gave you a Client ID
2. **Sign in** — opens your browser; log in with your work account
3. **Admin consent** — opens the approval page (if you're not an admin, send the link it shows to your admin)
4. **Pick your environment** — choose from the list (the recommended one is marked ⭐)
5. **Save** — writes your settings
6. **Connect your AI app** — pick your app from a menu and it wires itself up automatically

✅ **You should see** a green **Setup Complete!** banner, and your AI app listed as connected.

> Want to skip the menu? Add your app to the command:
> `powerautomate-mcp --setup --client claude` (or `cursor`, `vscode`, `gemini`, `claude-code`, `windsurf`).

### Step 3 — Confirm it works

```bash
powerautomate-mcp --doctor
```

✅ **You should see** green checks for Node, version, config, sign-in, "Power Platform reachable," and your AI app "connected." If anything is red, `--doctor` tells you the exact fix.

**Then:** fully **restart your AI app** (quit and reopen) so it loads the new tools — and just ask it:

> *"List my Power Automate flows."*

That's it. 🎉

---

## Fast Path (developers)

```bash
npm install -g powerautomate-mcp          # or: npx -y powerautomate-mcp@latest --setup
powerautomate-mcp --setup --client cursor # runs the wizard + writes your client config
powerautomate-mcp --doctor                # verify config + auth + connectivity + wiring
```

`--client` accepts: `claude`, `claude-code`, `cursor`, `vscode`, `gemini`, `windsurf`. Add `--npx` to write a config that runs the server via `npx -y powerautomate-mcp@latest` (no global install). Prefer to wire the client yourself? See [manual client configs](#connect-your-ai-app-manually).

**No global install at all:** point your client at `npx` (see the [npx option](#option-b-no-global-install-npx)) and run setup with `npx -y powerautomate-mcp@latest --setup`.

---

## Connecting your AI app

`--setup` connects your app for you. You only need this section if you skipped that step, use a second app, or want to do it by hand.

### Auto-connect (recommended)

Run any time — no re-auth needed, it only writes the client's config file:

```bash
powerautomate-mcp --client claude     # Claude Desktop
powerautomate-mcp --client cursor     # Cursor
powerautomate-mcp --client vscode     # VS Code (Copilot)
powerautomate-mcp --client gemini     # Gemini CLI
powerautomate-mcp --client claude-code # Claude Code (uses `claude mcp add`)
powerautomate-mcp --client windsurf   # Windsurf
```

It **merges** into any existing config — your other MCP servers are preserved. Add `--npx` for the no-global-install form. Restart the app afterward.

### Connect your AI app manually

Prefer to edit the files yourself? Use these.

<details>
<summary><strong>Claude Desktop</strong></summary>

Edit the config file (create it if missing):

| OS | Path |
|----|------|
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

If the file already has content, add the `powerautomate` block **inside** the existing `mcpServers` object — don't create a second one. Restart Claude Desktop.
</details>

<details>
<summary><strong>Claude Code (CLI)</strong></summary>

```bash
claude mcp add powerautomate -- powerautomate-mcp
```

Or add to your project's `.mcp.json`:

```json
{
  "mcpServers": {
    "powerautomate": { "command": "powerautomate-mcp" }
  }
}
```
</details>

<details>
<summary><strong>VS Code (GitHub Copilot)</strong></summary>

Open the Command Palette (`Ctrl/Cmd+Shift+P`) → **MCP: Open User Configuration**, or edit `mcp.json` directly:

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

Note VS Code uses `servers` (not `mcpServers`) and needs `"type": "stdio"`.
</details>

<details>
<summary><strong>Cursor</strong></summary>

Edit `~/.cursor/mcp.json` (global) or `.cursor/mcp.json` (project):

```json
{
  "mcpServers": {
    "powerautomate": { "command": "powerautomate-mcp" }
  }
}
```

Restart Cursor.
</details>

<details>
<summary><strong>Google Gemini CLI</strong></summary>

Edit `~/.gemini/settings.json`:

```json
{
  "mcpServers": {
    "powerautomate": { "command": "powerautomate-mcp" }
  }
}
```
</details>

<details>
<summary><strong>ChatGPT (advanced — needs a public HTTPS URL)</strong></summary>

ChatGPT can only reach a remote HTTPS MCP endpoint, so you expose the local server through a tunnel.

**1. Start in HTTP mode:**
```bash
powerautomate-mcp --http --port 3000
```
Serves Streamable HTTP at `http://localhost:3000/mcp`.

**2. Expose it (pick one):**
```bash
ngrok http 3000
# or
cloudflared tunnel --url http://localhost:3000
```

**3. In ChatGPT:** Settings → MCP Servers → **Add Server** → enter `https://your-tunnel-url/mcp` → Save.

> **Security:** the tunnel exposes your local server to the internet. Only run it while using ChatGPT, and stop the server and tunnel when done.
</details>

### Option B: no global install (npx)

If `npm install -g` causes permission headaches, skip it entirely. Configure your client to launch the server through `npx`, which downloads it on demand:

```json
{
  "mcpServers": {
    "powerautomate": {
      "command": "npx",
      "args": ["-y", "powerautomate-mcp@latest"]
    }
  }
}
```

`powerautomate-mcp --client <name> --npx` writes exactly this for you. Run setup the same way: `npx -y powerautomate-mcp@latest --setup`. Trade-off: the first launch each session is a little slower while npx fetches the package.

---

## Updating

> **Quit your AI apps first.** A running server keeps the old version loaded, and on Windows it can lock files in npm's folder and cause a half-finished, confusing upgrade.

1. Quit your AI apps and stop any `--http` servers.
2. Upgrade:
   ```bash
   npm install -g powerautomate-mcp@latest
   ```
3. Confirm:
   ```bash
   powerautomate-mcp --doctor
   ```
4. Reopen your AI app — it picks up the new version automatically.

`powerautomate-mcp --update` does the npm upgrade for you (same rule: close apps first). The [Changelog](https://github.com/rcb0727/powerautomate-mcp-docs/blob/main/CHANGELOG.md) lists what changed and any version-specific notes.

---

## Troubleshooting

Run **`powerautomate-mcp --doctor`** first — it pinpoints most problems and prints the fix. Common cases:

### Install problems

| Symptom | Fix |
|---------|-----|
| `command not found: powerautomate-mcp` after install | npm's global folder isn't on your PATH. Easiest fix: use the [npx option](#option-b-no-global-install-npx) instead. Or check `npm config get prefix` and add its `bin` folder to PATH. |
| `npm ERR! code EACCES` during `npm install -g` | A permissions issue. **Don't use `sudo`.** Use the [npx option](#option-b-no-global-install-npx), or set npm's prefix to a folder you own, or install Node via [nvm](https://github.com/nvm-sh/nvm). |
| `EBUSY` / `EPERM` on Windows during upgrade | An app is still running the server. Quit all AI apps and `--http` servers, then upgrade again. |
| `Node.js … (need 20+)` from `--doctor` | Upgrade Node from [nodejs.org](https://nodejs.org) (install the LTS). |
| Linux: `libsecret-1.so.0: cannot open shared object file` | Install libsecret — see the [Linux note](#how-to-open-a-terminal). |

### Setup & sign-in problems

| Symptom | Fix |
|---------|-----|
| `AADSTS65001` / "admin consent not granted" | An admin must approve the consent URL the wizard shows. Send it to your Global/Application/Cloud-App/Privileged-Role admin, then re-run `--setup`. |
| "No environments found" | The account you signed in with has no Power Automate access — sign in with your work account, or ask IT to grant access. |
| Wizard can't create an app registration | You're not an Entra admin and don't have Azure CLI. Ask an admin for a **Client ID** and paste it when prompted (or set `PA_MCP_CLIENT_ID`). See [Admin & enterprise setup](#admin--enterprise-setup). |
| Some tools fail with `AADSTS65001` after setup | A required permission wasn't consented (often PowerApps Service). See [enterprise permissions](#admin--enterprise-setup). |

### "It installed but my AI app doesn't see the tools"

1. **Fully restart the app** — quit completely (not just close the window) and reopen.
2. Run `powerautomate-mcp --doctor` — it shows whether your app is "connected."
3. If it's not connected, run `powerautomate-mcp --client <your-app>` and restart again.
4. Confirm the command works on its own: `powerautomate-mcp --version` should print a number.

Still stuck? [Open an issue](https://github.com/rcb0727/powerautomate-mcp-docs/issues) — include your OS, AI app, and the output of `powerautomate-mcp --doctor`.

---

## Glossary

| Term | In plain English |
|------|------------------|
| **MCP** (Model Context Protocol) | A standard way for AI apps to use external tools. This server is one such tool. |
| **MCP client / AI app** | The app you chat with (Claude, Cursor, VS Code Copilot, etc.) that runs the tools. |
| **App registration** | An identity in Microsoft Entra that lets this server sign in to your Microsoft account on your behalf. The wizard usually creates it for you. |
| **Tenant** | Your organization's Microsoft 365 directory — basically "your company's Microsoft account." |
| **Admin consent** | A one-time approval from an IT admin that allows the app's permissions across your tenant. |
| **Environment** | A Power Platform workspace that holds your flows, apps, and data. You pick one during setup. |
| **stdio** | How the AI app talks to this server locally (over standard input/output). The default — nothing to configure. |
| **Client ID** | The ID of the app registration — a UUID like `1234abcd-…`. Only needed if you provide your own. |

---

## Admin & enterprise setup

If your tenant **requires admin consent for all applications** (most enterprises do), the per-user wizard can't self-approve. As an admin:

1. **Add the API permissions to the app registration** in Microsoft Entra (the wizard's auto-created app already has these; add them manually only if you create the app yourself):
   - Microsoft Graph: `User.Read`, `Sites.ReadWrite.All`, `Files.ReadWrite.All`
   - Flow Service (`7df0a125-d3be-4c96-aa54-591f83ff541c`): `Flows.Read.All`, `Flows.Manage.All`, `Activity.Read.All`, `Approvals.Manage.All`
   - PowerApps Service (`475226c6-020e-4fb2-8a90-7a972cbfc1d4`): `User`
   - Dynamics CRM (`00000007-0000-0000-c000-000000000000`): `user_impersonation`
   - Power Platform API (`8578e004-a5c6-46e7-913e-12f58912df43`): a delegated permission — **optional**, only for the Power Pages site-management tools. The Power Pages config tools (Dataverse) don't need it.

2. **Grant admin consent** for all permissions:
   ```
   https://login.microsoftonline.com/{tenant-id}/adminconsent?client_id={your-client-id}
   ```

3. Have users run `powerautomate-mcp --setup`. Distribute the Client ID via the `PA_MCP_CLIENT_ID` environment variable so they don't have to paste it.

Without the PowerApps Service permission, `list_connections` and other connector tools fail with `AADSTS65001`.
