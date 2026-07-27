---
name: manage-connections
description: Create, test, and repair Power Platform connections. Use when connections are broken, expired, missing, or when a flow fails with authentication or connection errors.
---

# Manage connections

Connections are the most common cause of a flow that used to work and now doesn't.

## Tools
`ensure_connection` · `list_connections` · `test_connection` · `fix_connection` · `create_connection` · `delete_connection`

## Which tool
- **Need a working connection for a connector?** `ensure_connection`. One call: returns an existing Connected one, or creates one and gives sign-in instructions. Prefer it over stitching list + create + test yourself.
- **Is this specific connection healthy?** `test_connection`. It reports `Connected`, or the real error.
- **It's broken or expired?** `fix_connection`. Returns a consent link where the environment offers one, otherwise a direct link to the connection in the maker portal.
- **Clean-up?** `delete_connection` (requires `confirm: true`; any flow bound to it will break).

## What to expect
- The server is headless, so it cannot complete OAuth for the user. It hands back a link; the user signs in; then `test_connection` confirms. Say this plainly rather than implying it happened automatically.
- On many environments there is no direct consent link and the maker-portal link is the normal path — not an error.
- `AADSTS700082` in a connection's error means its refresh token expired from inactivity. `fix_connection` is the answer.
