#!/bin/sh
set -eu

username="${1:-}"

# Username not provided => do nothing (volume still mounted at /claude-config)
[ -n "$username" ] || exit 0

# Find home directory for that user
home_dir="$(getent passwd "$username" | cut -d: -f6 || true)"
if [ -z "$home_dir" ]; then
  echo "claude-config: user '$username' not found; skipping" >&2
  exit 0
fi

mkdir -p /claude-config
mkdir -p "$home_dir"

# Create/replace symlink: ~/.claude -> /claude-config
ln -snf /claude-config "$home_dir/.claude"