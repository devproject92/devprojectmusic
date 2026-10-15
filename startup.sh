#!/usr/bin/env bash
set -euo pipefail

# Once-per-worker prerequisites for the Music (Flutter) project.
# The Flutter SDK does not persist across workers, so install it when missing.
# Project dependencies and the web build are handled by start.sh, not here.

FLUTTER_VERSION="3.47.7"
FLUTTER_TARBALL="flutter_linux_${FLUTTER_VERSION}-stable.tar.xz"
FLUTTER_URL="https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/${FLUTTER_TARBALL}"

if ! /usr/bin/time -p "$HOME/flutter/bin/flutter" --version >/dev/null 2>&1; then
  /usr/bin/time -p curl -L -o /tmp/flutter.tar.xz "$FLUTTER_URL"
  /usr/bin/time -p rm -rf "$HOME/flutter"
  /usr/bin/time -p tar -xf /tmp/flutter.tar.xz -C "$HOME"
  /usr/bin/time -p rm -f /tmp/flutter.tar.xz
fi
/usr/bin/time -p "$HOME/flutter/bin/flutter" --version
/usr/bin/time -p "$HOME/flutter/bin/flutter" config --enable-web
