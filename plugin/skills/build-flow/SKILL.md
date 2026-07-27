---
name: build-flow
description: Build a Power Automate cloud flow from a description. Use when the user wants to create, author, or generate a new cloud flow, or describes an automation they want built.
---

# Build a flow

Turn a plain-language description into a working flow.

## Tools
`plan_flow` · `search_connectors` · `get_action_schema` · `ensure_connection` · `build_flow` · `create_flow` · `validate_flow` · `test_flow` · `toggle_flow`

## Sequence
1. **`plan_flow`** with the user's description. It returns the detected trigger, actions, and the questions still unanswered.
2. **Ask what is genuinely ambiguous** — which site, which list, who receives it, how often. Do not ask what the description already answers.
3. **`ensure_connection`** for each connector the plan needs. This is the step that most often blocks a build: it returns an existing working connection, or creates one and gives the user a sign-in link. Resolve connections *before* building, not after the flow fails.
4. **`build_flow`** with the confirmed goal. It creates the flow in a stopped state.
5. **`validate_flow`** and report the score. Fix anything scored as an error before proceeding.
6. **`test_flow`** to prove it runs.
7. **`toggle_flow`** to turn it on, once the user confirms the test looked right.

## Notes
- A flow can be created before its connections work — it is left stopped and the missing connections are listed. That is a valid intermediate state, not a failure.
- If an action rejects a parameter as invalid, use `get_action_schema` to see the required fields rather than guessing.
