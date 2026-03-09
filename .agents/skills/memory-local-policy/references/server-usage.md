# Server Usage

Use this reference when server choice, transport, or troubleshooting matters.

## Default Environment

- Assume the self-hosted Basic Memory MCP server is already configured for this environment.
- Use the configured self-hosted MCP server on the home network as the default path.
- Do not switch to Basic Memory Cloud unless the user explicitly asks for cloud behavior.
- Do not start a separate local, localhost, Docker, or stdio MCP server unless the user explicitly asks for setup or troubleshooting help.

## How To Treat Upstream Docs

- Upstream Basic Memory docs about localhost, Docker, SSE, HTTP, or stdio are setup and troubleshooting references, not the default operating mode here.
- Do not infer from upstream local examples that this environment should use a local server process.
- Keep using the already-configured network-hosted MCP server unless the user says otherwise.

## Practical Consequences

- Prefer existing MCP tool access over setup steps.
- Do not suggest cloud-only workflows by default.
- Do not redirect ordinary note, search, or write requests into server setup instructions.
- If connectivity or routing is clearly broken, diagnose within the assumption that the intended target is the self-hosted MCP server on the home network.
