#!/usr/bin/env bash
# Generates a minimal valid meta/main.yml for each role that lacks one.
# Idempotent: skips roles that already have a meta/main.yml.

set -euo pipefail

ROLES_DIR="$(dirname "$0")/roles"
AUTHOR="Corey Ducre"
LICENSE="MIT"
MIN_ANSIBLE="2.12"

for role_path in "$ROLES_DIR"/*/; do
  role_name="$(basename "$role_path")"
  meta_dir="${role_path}meta"
  meta_file="${meta_dir}/main.yml"

  if [[ -f "$meta_file" ]]; then
    echo "SKIP: $role_name already has meta/main.yml"
    continue
  fi

  mkdir -p "$meta_dir"
  cat > "$meta_file" <<EOF
---
galaxy_info:
  role_name: ${role_name}
  author: ${AUTHOR}
  description: ${role_name} role for Charlotte_2026 configuration management
  license: ${LICENSE}
  min_ansible_version: "${MIN_ANSIBLE}"
  platforms:
    - name: EL
      versions:
        - "9"
    - name: Ubuntu
      versions:
        - noble
  galaxy_tags: []

dependencies: []
EOF
  echo "CREATED: $role_name/meta/main.yml"
done

echo "Done."
