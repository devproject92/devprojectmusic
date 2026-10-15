#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

PORT="${PORT:-3000}"
export PORT
PROJ="$PWD"
export PATH="$HOME/flutter/bin:$PATH"

/usr/bin/time -p flutter --version
/usr/bin/time -p flutter pub get

NEED_BUILD=0
if ! /usr/bin/time -p test -f build/web/index.html; then
  NEED_BUILD=1
elif [ -n "$(find lib pubspec.yaml web -newer build/web/index.html -print -quit 2>/dev/null)" ]; then
  NEED_BUILD=1
fi
if [ "$NEED_BUILD" = 1 ]; then
  /usr/bin/time -p flutter build web --release
fi
/usr/bin/time -p test -f build/web/index.html

OUT_DIR="${OPENCODE_WEB_DIR:-/home/runner/work/_temp/omgithub-web}"
/usr/bin/time -p mkdir -p "$OUT_DIR"
/usr/bin/time -p python3 - "$OUT_DIR" "$PROJ" <<'PYEOF'
import sys
import json
out_dir, proj = sys.argv[1], sys.argv[2]
with open(out_dir + "/deployment-output.json", "w") as f:
    json.dump({"project": proj, "directory": proj + "/build/web"}, f)
    f.write("\n")
PYEOF

/usr/bin/time -p python3 -m http.server "$PORT" --directory "$PROJ/build/web" --bind 0.0.0.0
