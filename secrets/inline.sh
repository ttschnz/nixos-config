#!/usr/bin/env bash

set -euo pipefail

yaml_input=$(cat)     # YAML piped into stdin
target_file="secrets/secrets.nix"
tmp_out=$(mktemp)

# Ensure we are using bash, not sh
[ -n "${BASH_VERSION:-}" ] || { echo "This script must be run with bash"; exit 1; }

# Process each line
while IFS= read -r line; do
  if [[ "$line" =~ \"([^\"]+)\"[[:space:]]*=[[:space:]]*\{[[:space:]]*value[[:space:]]*=[[:space:]]*null[[:space:]]*\;[[:space:]]\}\; ]]; then
    path="${BASH_REMATCH[1]}"
    value=$(printf '%s' "$yaml_input" | yq -r ".${path//\//.}" 2>/dev/null)
    # Escape newlines and quotes for substitution
    value_escaped=$(printf '%s' "$value" | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n/\\n/g' -e 's/"/\\"/g')    
    line=$(echo "$line" | sed "s|null|\"${value_escaped}\"|")
  fi
  echo "$line" >> "$tmp_out"
done < "$target_file"

mv "$tmp_out" "$target_file"
