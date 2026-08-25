#!/usr/bin/env bash
set -euo pipefail

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
verify="$root/scripts/verify-harness-release-assets.sh"
temp=$(mktemp -d)
trap 'rm -rf "$temp"' EXIT

for artifact in \
  harness-macos-arm64 harness-macos-arm64.sha256; do
  touch "$temp/$artifact"
done
"$verify" "$temp" >/dev/null

touch "$temp/harness-cli-macos-arm64"
if "$verify" "$temp" >/dev/null 2>&1; then
  echo "mixed core/compatibility artifact inventory unexpectedly passed" >&2
  exit 1
fi
rm "$temp/harness-cli-macos-arm64"

rm "$temp/harness-macos-arm64"
if "$verify" "$temp" >/dev/null 2>&1; then
  echo "incomplete core artifact inventory unexpectedly passed" >&2
  exit 1
fi

echo "Harness core release inventory accepts exact assets and rejects mixed or missing assets"
