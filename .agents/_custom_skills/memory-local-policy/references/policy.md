# Basic Memory Policy

Use this reference before any write, delete, overwrite-destructive action, or undo flow.

## Default Behavior

- Read from Basic Memory by relevance when it helps complete the request.
- Block writes and deletes unless the user explicitly asks for a write or delete action.
- Treat project-level and user-level instructions as higher priority than convenience.

## Write Modes

- `confirm write` mode (default): show a preview, then wait for explicit approval.
- `write freely` mode: execute non-destructive writes immediately when explicitly requested.
- Mode toggle phrases:
  - `set memory write mode confirm`
  - `set memory write mode free`

## Pre-Write Preview Options

- `summary` (default): short preview of target, action, and content summary.
- `view full`: show full markdown that will be written.
- `download md`: provide or export exact markdown content for download where supported; otherwise return full markdown inline.
- Preview keywords:
  - `preview summary`
  - `preview full`
  - `download md`
  - `no-preview-write`

`no-preview-write` skips preview only for that request and never bypasses destructive confirmation.

## Write Gating

Before a write in `confirm write` mode, include:
- target project
- operation (`create` or `update`)
- target permalink or path
- overwrite risk note when applicable

Require the explicit approval phrase `approve write`.

If the user requests changes, use a `revise write` flow and then re-preview before writing.

## Destructive Actions

Delete and overwrite-destructive operations use a strict two-step flow.

Step 1: preview the exact targets and effects.

Step 2: require the exact confirmation phrase:
- `confirm delete <target>`
- `confirm overwrite <target>`

No bulk destructive actions unless all targets are explicitly enumerated.

## Post-Write Retrieval

Support these requests at any point in the current session:
- `show me the note/file/doc you just wrote`
- `let me download that last note/file`

Track and expose the immediately previous write target and content for retrieval.

## Undo Policy

Support `undo last write` for the immediately previous write action only.

Undo should restore the prior document state, or remove the newly created document for that last action.

This applies only within the current chat session and has no persistence guarantee across restarts.

## Reporting

After any write, delete, or undo, report the exact changed targets as project plus permalink or path.

If a request conflicts with this policy, ask for confirmation before proceeding.
