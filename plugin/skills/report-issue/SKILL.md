---
name: report-issue
description: Report a bug or request a feature for the Power Automate MCP server. Use when the user hits an error they think is a defect, says something is broken or behaving wrong, or asks to file an issue.
---

# Report an issue

Turn what just went wrong into a report a maintainer can act on without a
follow-up round trip.

## Gather first — do not ask the user for what you can read

1. **What was attempted**: the tool name and the arguments (redact any value
   that looks like a secret, token, or personal data).
2. **What happened**: the exact error text. Never paraphrase it.
3. **Version**: from the server's startup log, or ask them to run
   `powerautomate-mcp --version`.
4. **Environment shape**: OS, Node version, and which AI client they are using.
   `powerautomate-mcp --doctor` prints most of this in one go.

## Check it is actually a defect

Several classes of failure are configuration, not bugs — filing them wastes
the user's time and the maintainer's:

- `AADSTS65001` or "consent missing" → an Entra admin has not granted a
  permission. Point at the `setup` skill instead.
- `403` on Dataverse, desktop flow, or work-queue tools → the Dynamics CRM
  permission is missing.
- A connection error mentioning an expired token → `fix_connection`.
- A tool that is not in the list at all → its feature is off in the permission
  profile; `--setup` again with a wider profile.

Say which one you think it is and let the user decide. If they still want to
file, file it.

## Write the report

Keep it to what a maintainer needs:

```
**What I did**
<tool> with <arguments, redacted>

**What I expected**
<one line>

**What happened**
<exact error text, in a code block>

**Environment**
powerautomate-mcp <version> · Node <version> · <OS> · <AI client>
```

## File it

Build a pre-filled URL and give it to the user to open — do not try to post on
their behalf, and do not assume the `gh` CLI is installed:

```
https://github.com/rcb0727/powerautomate-mcp-docs/issues/new?title=<url-encoded title>&body=<url-encoded body>
```

Tell them to review it before submitting, since the body may contain
environment details they would rather redact.
