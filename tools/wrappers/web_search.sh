#!/usr/bin/env bash
# Wrapper para web search
# Uso: ./web_search.sh "<query>" [num_results]
# Requiere: ddgr (pip install ddgr) o tavily-python

set -euo pipefail

QUERY="${1:-}"
NUM_RESULTS="${2:-5}"

if [[ -z "$QUERY" ]]; then
  echo "Uso: $0 \"<query>\" [num_results]" >&2
  exit 1
fi

# Opción 1: ddgr (DuckDuckGo CLI)
if command -v ddgr &>/dev/null; then
  ddgr --num="$NUM_RESULTS" --json "$QUERY"
  exit 0
fi

# Opción 2: Tavily API (requiere TAVILY_API_KEY)
if command -v python3 &>/dev/null && python3 -c "import tavily" 2>/dev/null; then
  python3 - <<EOF
import json
from tavily import TavilyClient

client = TavilyClient(api_key="$TAVILY_API_KEY")
results = client.search("$QUERY", max_results=$NUM_RESULTS)
print(json.dumps(results, indent=2, ensure_ascii=False))
EOF
  exit 0
fi

echo "Error: ningún backend disponible." >&2
echo "Instalar: pip install ddgr  o  pip install tavily-python" >&2
exit 1
