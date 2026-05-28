#!/usr/bin/env bash
# VeinX demo — serve this folder on http://localhost:8000
cd "$(dirname "$0")" || exit 1
echo "VeinX demo → http://localhost:8000/present  (Ctrl+C to stop)"
( sleep 1; (command -v open >/dev/null && open http://localhost:8000/present) \
  || (command -v xdg-open >/dev/null && xdg-open http://localhost:8000/present) ) &
if command -v python3 >/dev/null; then exec python3 -m http.server 8000;
elif command -v python  >/dev/null; then exec python  -m http.server 8000;
elif command -v npx     >/dev/null; then exec npx --yes serve -l 8000 .;
else echo "Install Python or Node.js, then run: npx serve -l 8000"; fi
