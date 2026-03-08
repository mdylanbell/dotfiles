---
name: git-wt-operator
description: Set up repositories in the git-wt container format and execute work inside the correct branch worktree. Use when an agent needs to clone or migrate a repo into a container with main and wt directories, create or resume a branch worktree for implementation tasks, sync main, or clean up completed worktrees.
---

# Git WT Operator

Execute `git-wt` workflows for two primary jobs:
1. Bootstrap repository in container layout.
2. Run coding tasks inside a dedicated branch worktree.

Use this skill for commands: `init`, `migrate`, `add`, `path`, `list`, `status`, `config`, `sync`, `clean`, and `remove`.

`git-wt open` is typically human/editor-oriented and should not be used by agents unless the user explicitly asks to open a path/tool.

## Interaction Contract

Gather only missing inputs before running commands:
1. For bootstrap: ask for target container path and remote URL if either is missing.
2. For task execution: ask for branch name if missing.
3. Ask for `--container` only when not currently inside a git-wt container.
4. Ask for destructive intent confirmation when deleting worktrees/branches (`remove`, `clean --with-branches`) unless user already requested it.

Default behavior:
- Prefer `--dry-run` first for mutating commands unless user asks for direct execution.
- Add `--verbose` when user asks "why" or when debugging failures.
- Do not use `--dry-run` with read-only commands (`list`, `status`, `path`, `config show/get`), because these commands reject it.
- Never run `git-wt migrate` unless the user explicitly instructs migration (or explicitly grants permission after being asked).
- For clone requests, ask whether to clone using `git-wt init` before doing so.
- If a repository is not already in git-wt container format, and the user did not explicitly request git-wt adoption, proceed with normal git workflows instead of git-wt commands.
- Branch naming policy: if branch name is unclear, ask unless user has clearly granted broad autonomy for this task. If unsure, ask.
- Cleanup policy: never run `git-wt clean` unless the user explicitly instructs cleanup.
- For `git-wt add` decisions, infer user autonomy level from current prompt context. If uncertain, ask whether post-task cleanup is desired before creating the worktree, then remember that choice for the current task only.

### Command Precedence (Container Repos)

When container format is detected (`main/` + `wt/`):
- Local worktree/branch lifecycle operations MUST use `git-wt` first.
- Do not use native `git worktree` or local `git branch -d/-D` for routine cleanup/create flows in container repos.
- Use native git only for tasks `git-wt` does not provide (for example, remote branch inspection/deletion/validation).

### Operation Map (Required Defaults)

In container repos, map intent to commands as follows:
- Sync main branch state: `git-wt sync`
- Create worktree for new branch: `git-wt add -b <branch> [--base <branch>]`
- Resume existing branch worktree: `git-wt path <branch>` (then run work in that path)
- Remove one worktree + branch: `git-wt remove <path-or-branch> --delete-branch`
- Bulk local cleanup: `git-wt clean`
- Inspect container state: `git-wt list`, `git-wt status`
- Remote branch validation only: native git allowed (`git ls-remote --heads origin`, `git fetch --prune`)

Disallowed-by-default in container repos (unless fallback protocol is triggered):
- `git worktree add/remove/prune`
- local `git branch -d/-D` for branch lifecycle managed by git-wt

### Native Git Fallback Protocol

If native git is used for a local lifecycle operation in a container repo, the agent must:
1. Attempt the relevant `git-wt` command first, OR cite a concrete missing capability.
2. State why `git-wt` is insufficient for this operation.
3. Report the fallback explicitly in the final response.

## Workflow

1. Classify intent.
`bootstrap` (new repo setup) or `worktree-task` (implement or edit code in a branch worktree).
2. Detect container context.
`git-wt` auto-detects by walking up for `<container>/main` and `<container>/wt`.
3. Run command-selection checklist.
- Container detected?
- Can this operation be completed with `git-wt` only?
- If not, what exact capability gap requires native git?
4. Choose command from task intent.
Use the quick map in [commands.md](references/commands.md).
5. Run preflight.
Check required tools (`git`; for config reads and hooks, `python3` with `tomllib`).
6. Execute command.
Prefer safe flags (`--dry-run`, `--verbose`) based on user intent.
7. Report output and next action.
If command prints a resulting path, surface it clearly.

Container format detection:
- Treat as git-wt container only when sibling directories `main/` and `wt/` exist.
- `git-wt.toml` may exist or be absent; it is optional and not required for container detection.

## Bootstrap Flow

For "pull down repo in custom format":
1. Ask whether to use git-wt container format for this clone.
2. If yes, run:
`git-wt init <container_path> <remote_url>`
3. If no, clone normally with standard git commands.
4. Do not run `git-wt migrate` unless explicitly instructed.
5. If user explicitly requests migration of an existing non-container repo, run:
`git-wt migrate <repo_path>`
6. Optionally configure:
`git-wt config set open.cmd "code ."`
7. Confirm layout:
`git-wt list`

## Worktree Task Flow

For "work in my worktrees":
1. Ensure main is up to date:
`git-wt sync`
2. Resolve or create target worktree:
- Existing branch: `git-wt path <branch>` then `cd` there.
- New branch: `git-wt add -b <branch>` then `cd` there.
3. Perform implementation in that worktree only.
4. Do not run `git-wt clean` automatically. Run cleanup only when explicitly requested.

Before running `git-wt add`:
- Determine whether the user expects full autonomy or cautious confirmation in this task.
- If unclear, ask whether to clean up worktree/branch after task completion.
- Apply the answer only to the current task unless user explicitly says to reuse it more broadly.

## Safety Rules

- Never remove the current worktree.
- Avoid operations on `main/` worktree except `sync` and `config`.
- For `clean`, explain skip reasons with `--verbose` if user is uncertain.
- For `sync`, fail early if `main/` is dirty and tell user how to inspect and resolve.
- Treat `git-wt remove` as destructive. Prefer caution, and ask when user intent is ambiguous.

## Configuration Guidance

- Show and read settings with:
`git-wt config show`
`git-wt config get default_branch`
`git-wt config get open.cmd`
- Set values with:
`git-wt config set default_branch <branch>`
`git-wt config set open.cmd "<command>"`

When setting `open.cmd`, avoid unescaped double quotes in the command string. If complex quoting is needed, edit `git-wt.toml` directly and then verify with `git-wt config show`.

## Hooks

Use hooks when post-operation automation is needed (`add`, `remove`, `sync`, `clean`):
- Configure hook lists in `git-wt.toml` under `[hooks]`.
- Place executable hook scripts under `~/.local/libexec/git-wt/hooks/`.
- Use `[hooks.<name>.cmd]` for inline shell commands.

## Examples

- Clean local container worktrees/branches while preserving `main`: `git-wt clean`
- Remove one local branch worktree pair: `git-wt remove <path-or-branch> --delete-branch`
- Validate remote branches (no mutation): `git ls-remote --heads origin`

Read [commands.md](references/commands.md) for command-by-command behavior and recovery patterns.
