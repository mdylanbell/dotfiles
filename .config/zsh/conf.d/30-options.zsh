# ======================================================================
#  Zsh Options
#
#  Core behavioral tuning for interactive shells.
#  Keep this file small, predictable, and well-documented.
# ======================================================================

# ----------------------------------------------------------------------
#  Shell Behavior
# ----------------------------------------------------------------------

# Allow inline comments (# …) in interactive commands
setopt interactivecomments

# Modern globbing: **, ^foo, etc.
setopt extendedglob

# Include dotfiles in globs (but not "." or "..")
setopt globdots

# Sort globs numerically (file2 < file10)
setopt numericglobsort

# Treat unmatched globs as errors instead of literal strings
setopt nomatch

# Directory stack behavior: push on cd, avoid duplicates, stay quiet
setopt autopushd
setopt pushdsilent
setopt pushdignoredups

# Explicitly avoid implicit "cd" on bare directory names
unsetopt autocd


# ----------------------------------------------------------------------
#  History
# ----------------------------------------------------------------------

# Append history to $HISTFILE, don’t overwrite
setopt appendhistory

# Write each command to history as it is entered
setopt inc_append_history

# Ignore commands starting with a space in history
setopt histignorespace

# Ignore consecutive duplicate commands
setopt histignoredups

# Store timestamps and durations with history entries
setopt extendedhistory

# Do not merge history between interactive shells
unsetopt sharehistory


# ----------------------------------------------------------------------
#  Completion & Lookup
# ----------------------------------------------------------------------

# Allow completion in the middle of a word
setopt completeinword

# Suppress beeps on completion errors
setopt nobeep

# Cache command paths for faster completion
setopt hashlistall

# Case-insensitive globbing (useful for filesystems with mixed case)
setopt nocaseglob


# ----------------------------------------------------------------------
#  Job Control
# ----------------------------------------------------------------------

# Notify immediately when background jobs change state
setopt notify

# Show more detail in job listings
setopt longlistjobs


# ----------------------------------------------------------------------
#  Safety & Correctness
# ----------------------------------------------------------------------

# Prevent accidental truncation: ">" refuses to clobber; use ">|" explicitly
setopt noclobber

# Fail a pipeline if any component command fails
setopt pipefail


# ----------------------------------------------------------------------
#  Explicitly Disabled Legacy/Risky Behaviors
# ----------------------------------------------------------------------

# Preserve zsh’s array semantics; avoid bash-like word splitting
unsetopt shwordsplit

# Avoid implicitly exporting every variable
unsetopt allexport
