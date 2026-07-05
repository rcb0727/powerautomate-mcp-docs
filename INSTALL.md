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

**This takes about 10 minutes.** One step (admin consent) may need a quick approval from your IT department — skim [Step 2](#step-2--run-setup) before you begin so nothing catches you off guard.

You need three things. The Easy Path checks all of them for you, but here's the full list:

1. **A Microsoft 365 *work* account** with Power Automate access — the same email and password you use for Outlook, Teams, and Office at work. (Not a personal @outlook.com / @gmail account. You don't need to create anything new.)
2. **An AI app that supports MCP** — Claude Desktop, Claude Code, Cursor, VS Code (Copilot), Gemini CLI, Windsurf, or ChatGPT. If you have one open right now, you're set.
3. **Node.js 22.19 or newer** — the engine the server runs on. Install steps below.

### Step A — Open a terminal

The terminal is the app where you type the commands in this guide.

- **Windows:** click **Start**, type **PowerShell**, press Enter.
- **macOS:** press **Cmd + Space**, type **Terminal**, press Enter.
- **Linux:** press **Ctrl + Alt + T**, or search **Terminal** in your apps.

To run any command below: click in the terminal, **paste** it, press **Enter**, and wait for it to finish before the next one.

### Step B — Install Node.js (one-time)

**First check if you already have it.** In the terminal, paste this and press Enter:

```bash
node --version
```

- If it prints **`v22.19.0` or newer** (for example `v22.19.x`, `v24.x`, or later), you're done — go to [Easy Path Step 1](#step-1--install-the-server).
- If it says **"command not found"**, `v18`, `v20`, or a `v22` version below `v22.19.0`, install Node:
  - **Windows & macOS:** go to [nodejs.org](https://nodejs.org) and click the big green button labeled **LTS** (the "Recommended for most users" one — *not* "Current"). Run the installer and click through the defaults.
  - **macOS, only if you already use Homebrew:** `brew install node`
  - **Linux:** [nodejs.org](https://nodejs.org), your distro's package manager, or [nvm](https://github.com/nvm-sh/nvm).

  Then close and reopen the terminal and run `node --version` again to confirm.

> **Linux only — secure password storage:** install libsecret so your sign-in token is stored safely. (Windows and macOS users: skip this.)
> ```bash
> sudo apt-get install libsecret-1-0 gnome-keyring   # Ubuntu/Debian
> sudo dnf install libsecret gnome-keyring           # Fedora/RHEL
> ```
> If setup later says `libsecret-1.so.0: cannot open shared object file`, this package is missing.

---

## Easy Path (3 steps)

In your terminal, paste each command, press **Enter**, and let it finish before the next one. When the tool *asks* you something, type your answer (or the number next to your choice) and press Enter.

### Step 1 — Install the server

```bash
npm install -g powerautomate-mcp
```

✅ **You should see** a few lines ending in something like `added 1 package`. Yellow `WARN` lines are normal and safe to ignore — only red `ERR!` means a real problem.

> **If that fails** with `command not found`, `EACCES`, or a permission error, don't worry — you don't need the global install. Just use `npx` instead: everywhere below, replace `powerautomate-mcp` with `npx -y powerautomate-mcp@latest`. So Step 2 becomes `npx -y powerautomate-mcp@latest --setup`. That's the only change — skip the rest of this step.

### Step 2 — Run setup

```bash
powerautomate-mcp --setup
```

A wizard starts and walks you through seven steps. Here's what it asks and what you do:

1. **Choose permissions** — pick a preset: all tools, Power Automate only, Power Automate + connectors, Dataverse, Power Pages, or Custom. Choose only what you plan to use; you can run setup again later to add more.
2. **App registration** — it tries to create this for you automatically with only the selected permissions. **Heads-up:** the automatic path needs a developer tool called *Azure CLI*. If you don't have it (most people don't), the wizard will ask you to paste a **Client ID** instead — a code like `1234abcd-…` that your IT department creates once. If you don't have one, [ask IT first](#getting-a-client-id-from-it) and come back.
3. **Sign in** — your browser opens. Log in with your **work** account. If it shows an account picker, choose your company email (e.g. `you@yourcompany.com`), not a personal one.
4. **Admin consent** — it opens an approval page for the permissions you selected. If you're an admin, approve it. **If you're not** (most people), see [Admin consent: what to do](#admin-consent-what-to-do) — you'll send a link to IT and re-run setup once they approve.
5. **Pick your environment** — type the number next to the one you want (the recommended one is marked ⭐) and press Enter.
6. **Save** — it writes your settings automatically, including which feature scopes are enabled.
7. **Connect your AI app** — type the number for the app you use (Claude Desktop, Claude Code, Cursor, VS Code, Gemini, Windsurf). It wires itself up — no JSON editing.

✅ **You should see** a green **Setup Complete!** banner with your AI app listed as connected.

> Want to skip the app menu? Name it on the command: `powerautomate-mcp --setup --client claude` (or `cursor`, `vscode`, `gemini`, `claude-code`, `windsurf`). Either way works — without `--client`, you just pick from the menu.

#### Admin consent: what to do

Power Automate MCP needs a one-time approval ("admin consent") for your organization. **Most employees aren't admins** — that's expected. The wizard shows a link; copy it and email your IT helpdesk:

> *Hi — I'm setting up a Microsoft tool that connects to Power Automate. Could an administrator approve this consent link for our organization? [paste the link]*

Once IT confirms it's approved, run `powerautomate-mcp --setup` again — it picks up where it left off. (Only a Global, Application, Cloud Application, or Privileged Role admin can approve — IT will know who that is.)

#### Getting a Client ID from IT

If the wizard asks for a **Client ID** and you don't have one, your tenant requires an admin to register the app first. Send your IT department to [Admin & enterprise setup](#admin--enterprise-setup) — they create the app registration once and give you the Client ID (and grant consent). Then run `powerautomate-mcp --setup` and paste it when asked.

### Step 3 — Confirm it works

```bash
powerautomate-mcp --doctor
```

✅ **You should see** green checks for Node, version, config, sign-in, "Power Platform reachable," and your AI app "connected." If anything is red, `--doctor` tells you the exact fix.

**Then fully restart your AI app** so it loads the new tools:
- **macOS:** closing the window isn't enough — press **Cmd + Q** with the app focused (or right-click its Dock icon → **Quit**), then reopen it.
- **Windows/Linux:** close the app completely and reopen it.

Now just ask it:

> *"List my Power Automate flows."*

If it lists your flows — or says you don't have any yet — it's working. 🎉 (If it says it has no Power Automate tool, redo the restart above.)

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

Open the Command Palette (`Ctrl/Cmd+Shift+P`) → **MCP: Open User Configuration**, or edit the file directly:

| OS | Path |
|----|------|
| macOS | `~/Library/Application Support/Code/User/mcp.json` |
| Windows | `%APPDATA%\Code\User\mcp.json` |
| Linux | `~/.config/Code/User/mcp.json` |

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
| `Node.js … (need 22.19+)` from `--doctor` | Upgrade Node from [nodejs.org](https://nodejs.org) (install the LTS). |
| Linux: `libsecret-1.so.0: cannot open shared object file` | Install libsecret — see the Linux note under [Before you start](#before-you-start). |

### Setup & sign-in problems

| Symptom | Fix |
|---------|-----|
| `AADSTS65001` / "admin consent not granted" | An admin must approve the consent URL the wizard shows. Send it to your Global/Application/Cloud-App/Privileged-Role admin, then re-run `--setup`. |
| "No environments found" | The account you signed in with has no Power Automate access — sign in with your work account, or ask IT to grant access. |
| Wizard can't create an app registration | You're not an Entra admin and don't have Azure CLI. Ask an admin for a **Client ID** and paste it when prompted (or set `PA_MCP_CLIENT_ID`). See [Admin & enterprise setup](#admin--enterprise-setup). |
| Some tools fail with `AADSTS65001` after setup | A permission for that feature wasn't consented. Run `powerautomate-mcp --doctor` to see the exact API, then see [enterprise permissions](#admin--enterprise-setup). |

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

1. **Add only the API permissions for the feature set you selected** in Microsoft Entra. A Power Automate-only setup needs only the Flow Service permissions; add the optional APIs only when users need those tools:
   - Flow Service (`7df0a125-d3be-4c96-aa54-591f83ff541c`): `Flows.Read.All`, `Flows.Manage.All`, `Activity.Read.All`, `Approvals.Manage.All`
   - Optional SharePoint/Excel helpers: Microsoft Graph `User.Read`, `Sites.ReadWrite.All`, `Files.ReadWrite.All`
   - Optional connections/connectors/Power Apps: PowerApps Service (`475226c6-020e-4fb2-8a90-7a972cbfc1d4`) `User`
   - Optional Dataverse/admin/Power Pages config: BAP Admin API (`0e0bf3cc-3078-4fd4-9ef3-cb6dc0245b10`) `user_impersonation`
   - Optional Dataverse/Power Pages config: Dynamics CRM (`00000007-0000-0000-c000-000000000000`) `user_impersonation`
   - Power Platform API (`8578e004-a5c6-46e7-913e-12f58912df43`): a delegated permission — **optional**, only for the Power Pages site-management tools. The Power Pages config tools (Dataverse) don't need it.

2. **Grant admin consent** for the selected permissions:
   ```
   https://login.microsoftonline.com/{tenant-id}/adminconsent?client_id={your-client-id}
   ```

3. Have users run `powerautomate-mcp --setup`. Distribute the Client ID via the `PA_MCP_CLIENT_ID` environment variable so they don't have to paste it.

Skipped feature scopes are recorded in `features.enabled`; their tools are hidden and their auth checks are skipped. Without the PowerApps Service permission, connector and Power Apps tools are unavailable. Without the BAP Admin API permission, admin tools and Dataverse URL auto-discovery are unavailable.
