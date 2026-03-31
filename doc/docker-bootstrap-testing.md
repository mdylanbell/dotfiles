# Testing bootstrap via docker

## Cached image test

Build a self-contained image that copies the repo into the image and boots from
that writable copy:

```bash
docker build -f Dockerfile.test.local -t local-dotfiles-test .
docker run --rm -it local-dotfiles-test
```

This is the preferred harness for normal bootstrap verification because Docker
layer caching works as expected and Neovim/lazy can write through the live
config symlinks without touching the host checkout.

The bootstrap script is invoked with explicit CLI args for the repo root,
skip-git behavior, and the zsh prompt answer.

## Timed report-and-exit run

If you want the container to exit cleanly after bootstrap and print a short
status report instead of dropping into a shell, override the image command:

```bash
docker run --rm -it local-dotfiles-test /bin/bash -lc '
  start=$(date +%s)
  /home/tester/.dotfiles/.local/bin/bootstrap_env \
    --dotfiles-root=/home/tester/.dotfiles \
    --skip-git \
    --zsh-default=y \
    >/tmp/bootstrap.out 2>&1
  status=$?
  end=$(date +%s)
  printf "bootstrap status: %s\n" "$status"
  printf "duration_sec: %s\n" "$((end - start))"
  if [ "$status" -ne 0 ]; then
    printf "\n--- bootstrap log ---\n"
    cat /tmp/bootstrap.out
  fi
  exit "$status"
'
```

This keeps the bootstrap output quiet on success, prints the elapsed duration,
and only shows the captured bootstrap log if the run fails.
