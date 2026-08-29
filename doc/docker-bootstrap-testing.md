# Testing bootstrap with Docker

The Ubuntu and Arch harnesses copy the checkout into a writable image, run
`.local/bin/bootstrap_env`, execute the portable shell suite, and verify that
mise reports no missing bootstrap capabilities.

Harness files live under `tests/`:

- `tests/Dockerfile.ubuntu`
- `tests/Dockerfile.arch`
- `tests/module-repository-env.sh`
- `tests/.miserc.toml`
- `tests/mise.toml`
- `tests/run-docker-bootstrap.sh`

`tests/mise.toml` keeps the declarative task definitions and composition. Its
Ubuntu and Arch tasks call the shared Docker runner, which owns the nontrivial
repository forwarding and build logic.
Enter the test project before invoking mise so `tests/.miserc.toml` participates
in early config discovery:

```bash
cd tests
mise run ubuntu
mise run arch
mise run linux
```

The Docker build context remains the repository root (`.`), not `tests/`.
`.dockerignore` therefore stays at the root, and each Dockerfile can use
`COPY . /home/tester/.dotfiles`.

## Acceptance boundaries

Both harnesses explicitly bootstrap `--profile=personal --features=none`.
Profile and feature composition is covered separately by the fast config and
shell tests.

Ubuntu begins with only `sudo`. Stage zero installs native Git, curl, CA
certificates, and Zsh. Mise then installs direct-Brew tools and real Homebrew,
checks the root Brewfile, and converges the login shell to `/bin/zsh`.
The harness asserts Git and curl still resolve from `/usr/bin`.

Arch also begins with only `sudo`. Stage zero installs the same native tools,
then writes `config.linux.local.toml` to select Pacman and disable Homebrew.
The harness verifies `/bin/zsh`, the generated policy, and the absence of both
the `brew` command and Linuxbrew prefix.

Neither harness runs cleanup. The shared Homebrew prefix must never be targeted
by `brew bundle cleanup`, `brew cleanup`, or mise's formula-manager prune.

## Optional module repositories

The Ubuntu and Arch tasks call `tests/module-repository-env.sh` for:

- `NPM_CONFIG_REGISTRY`
- `PIP_INDEX_URL`
- `PIP_EXTRA_INDEX_URL`

The helper uses an explicit environment value first, then a user-level npm or
pip configuration value when available. It forwards only one credential-free
HTTP(S) URL. Values containing userinfo, multiple whitespace-separated URLs,
or no host are rejected; absent values produce no Docker environment option.
The tasks never copy or mount package-manager config files or credentials.

## Other test tasks

```bash
mise run portable
mise run config
mise run macos
mise run macos:integration
mise run all
```

`portable` runs focused behavioral and safety contracts. `config` validates
mise tasks, resolves representative profile/feature combinations, and runs a
bootstrap dry run. `tests/.miserc.toml` enables early `auto_env` discovery, so
mise loads the tasks in `tests/mise.macos.toml` automatically on Darwin;
integration additionally checks bootstrap status and the root Brewfile.
