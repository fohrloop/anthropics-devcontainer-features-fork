#!/bin/sh
set -eu

# Auto-detect the current user
username="$(whoami 2>/dev/null || true)"

# No username detected? Exit gracefully (volume still mounted at /claude-config)
[ -n "$username" ] || exit 0

# Find home directory for that user
home_dir="$(getent passwd "$username" | cut -d: -f6 || true)"
if [ -z "$home_dir" ]; then
  echo "claude-config: user '$username' not found; skipping" >&2
  exit 0
fi

echo "Checking /claude-config before creation..." >&2
if [ -d /claude-config ]; then
  echo "  EXISTS: $(ls -ld /claude-config)" >&2
else
  echo "  Does not exist yet" >&2
fi

mkdir -p /claude-config
mkdir -p "$home_dir"

# Create/replace symlink: ~/.claude -> /claude-config
echo "Creating symlink: $home_dir/.claude -> /claude-config" >&2
ln -snf /claude-config "$home_dir/.claude"
