#!/usr/bin/env bash
set -euo pipefail

# create-github-release.sh
# Create a GitHub release with assets
# Usage: create-github-release.sh <version>

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <version>" >&2
  exit 1
fi

VERSION="$1"

# Create release and upload assets
gh release create "$VERSION" .genreleases/*.zip \
  --title "$VERSION" \
  --notes-file release_notes.md \
  --target main

echo "Created GitHub release: $VERSION"
