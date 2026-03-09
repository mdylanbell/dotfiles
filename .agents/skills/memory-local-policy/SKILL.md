---
name: memory-local-policy
description: Use when working with Basic Memory in this environment, including reading, searching, writing, deleting, ingesting, researching into memory, task tracking, reflection, or memory maintenance
---

# Memory Local Policy

Apply this skill before any Basic Memory work in this environment.

## Default Rules

- Use the configured self-hosted Basic Memory MCP server on the home network.
- Do not use Basic Memory Cloud unless the user explicitly asks for it.
- Do not start or prefer a separate local or stdio MCP server unless the user explicitly asks for it.
- Read and search Basic Memory when it is relevant to the task.
- Treat project-level and user-level instructions as higher priority than convenience.

## Write Safety

Before any write, delete, overwrite-destructive action, or undo flow, load:
- `references/policy.md`

If server choice, transport assumptions, or troubleshooting are relevant, load:
- `references/server-usage.md`

## After Local Context

With this local policy in mind, continue normal skill selection for any other installed Basic Memory skills that match the task.

If no more specific skill applies, use the Basic Memory MCP tools directly under this policy.
