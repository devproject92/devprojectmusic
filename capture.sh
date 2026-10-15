#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

: "${CAPTURE_URL:?Set CAPTURE_URL to the preview URL to capture.}"
: "${CAPTURE_DIR:?Set CAPTURE_DIR to the output directory for screenshots.}"
: "${RUNTIME_DIR:?Set RUNTIME_DIR to the runtime scripts directory.}"

/usr/bin/time -p mkdir -p "$CAPTURE_DIR"
/usr/bin/time -p test -n "$CAPTURE_URL"
/usr/bin/time -p test -n "$CAPTURE_DIR"

# Wait for the Flutter canvas to render (avoids capturing a blank loader page),
# unless the caller overrides the readiness selector.
export CAPTURE_READY_SELECTOR="${CAPTURE_READY_SELECTOR:-canvas}"

/usr/bin/time -p node "$RUNTIME_DIR/scripts/default-capture.mjs"
