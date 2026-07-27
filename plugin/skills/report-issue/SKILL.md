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

## File it

The repo uses GitHub **issue forms**, so the user gets a structured form with
labelled fields rather than a blank text box. Prefill it by passing each
field's id as a query parameter — do not build a `?body=` link, which bypasses
the form and opens a blank issue instead.

Build this URL, URL-encoding each value, and give it to the user to open:

```
https://github.com/rcb0727/powerplatform-mcp-docs/issues/new
  ?template=bug_report.yml
  &version=<powerautomate-mcp version>
  &tool=<tool name>
  &expected=<one line>
  &actual=<the exact error>
  &environment=<OS · Node version · AI client>
```

(as a single line, no spaces or newlines in the actual URL).

The five parameters map to the form's fields: `version`, `tool`, `expected`,
`actual`, `environment`. For a feature request use `template=feature_request.yml`
with `problem`, `today`, and optionally `api`.

Tell the user to review the form before submitting — the environment field may
contain details they would rather redact, and everything is editable in the
browser.
