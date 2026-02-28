#!/usr/bin/env bash
# resolve_alma.sh — Lee un .alma.yaml, resuelve herencia y emite variables para compose.sh
# Uso: eval "$(scripts/resolve_alma.sh <alma_name>)"
# Emite: DISC, ROLE, BASE (si compose.base), EXT, RUNTIME, INJECT_*, MODEL_*
# NO emite ADAPTER (se pasa al invocar compose.sh)
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
ALMAS_DIR="$ROOT_DIR/almas"

if [[ $# -lt 1 ]]; then
  echo "Error: nombre del alma requerido" >&2
  echo "Uso: $0 <alma_name>  (ej: v02/security-deep, engineering/security-fintech)" >&2
  exit 1
fi

if ! command -v yq &>/dev/null; then
  echo "Error: yq no encontrado. Instalar: brew install yq  o  pip install yq" >&2
  exit 1
fi

ALMA_NAME="$1"
ALMA_FILE="$ALMAS_DIR/${ALMA_NAME}.alma.yaml"

if [[ ! -f "$ALMA_FILE" ]]; then
  echo "Error: alma '$ALMA_NAME' no encontrada ($ALMA_FILE)" >&2
  exit 1
fi

resolve_alma() {
  local alma_file="$1"
  local depth="${2:-0}"

  if [[ "$depth" -gt 10 ]]; then
    echo "Error: herencia circular detectada (profundidad > 10)" >&2
    exit 1
  fi

  local extends
  extends=$(yq -r '.extends // empty' "$alma_file" 2>/dev/null || true)

  local parent_json="{}"
  if [[ -n "$extends" ]]; then
    local parent_file="$ALMAS_DIR/${extends}.alma.yaml"
    if [[ ! -f "$parent_file" ]]; then
      echo "Error: alma padre '$extends' no encontrada ($parent_file)" >&2
      exit 1
    fi
    parent_json=$(resolve_alma "$parent_file" $((depth + 1)))
  fi

  local child_json
  child_json=$(yq '.' "$alma_file")

  # Shallow merge: child overwrites parent at compose.* level
  echo "$parent_json" "$child_json" | jq -s '
    (.[0].compose // {}) as $parent_compose |
    (.[1].compose // {}) as $child_compose |
    (.[0] // {}) * (.[1] // {}) |
    .compose = ($parent_compose * $child_compose)
  '
}

RESOLVED=$(resolve_alma "$ALMA_FILE")

read_field() {
  echo "$RESOLVED" | jq -r "$1 // empty" 2>/dev/null || true
}

read_array() {
  echo "$RESOLVED" | jq -r "($1 // []) | .[]" 2>/dev/null || true
}

DISC=$(read_field '.compose.discipline')
ROLE=$(read_field '.compose.role')
BASE=$(read_field '.compose.base')
RUNTIME=$(read_field '.compose.runtime')

if [[ -z "$DISC" ]]; then
  echo "Error: alma '$ALMA_NAME' no define compose.discipline (ni la hereda)" >&2
  exit 1
fi
if [[ -z "$ROLE" ]]; then
  echo "Error: alma '$ALMA_NAME' no define compose.role (ni lo hereda)" >&2
  exit 1
fi

EXT_PARTS=()

while IFS= read -r item; do
  [[ -n "$item" ]] && EXT_PARTS+=("knowledge/$item")
done < <(read_array '.compose.knowledge')

while IFS= read -r item; do
  [[ -n "$item" ]] && EXT_PARTS+=("techniques/$item")
done < <(read_array '.compose.techniques')

while IFS= read -r item; do
  [[ -n "$item" ]] && EXT_PARTS+=("modifiers/$item")
done < <(read_array '.compose.modifiers')

while IFS= read -r item; do
  [[ -n "$item" ]] && EXT_PARTS+=("sources/$item")
done < <(read_array '.compose.sources')

while IFS= read -r item; do
  [[ -n "$item" ]] && EXT_PARTS+=("protocols/$item")
done < <(read_array '.compose.protocols')

while IFS= read -r item; do
  [[ -n "$item" ]] && EXT_PARTS+=("capabilities/$item")
done < <(read_array '.compose.capabilities')

EXT="${EXT_PARTS[*]:-}"

INJECT_BEFORE=$(read_field '.inject.before_role')
INJECT_AFTER=$(read_field '.inject.after_role')
MODEL_SUGGESTED=$(read_field '.model.suggested')
MODEL_TEMPERATURE=$(read_field '.model.temperature')
MODEL_MAX_TOKENS=$(read_field '.model.max_tokens')

# Emit as eval-able shell variables
emit_var() {
  local name="$1" value="$2"
  if [[ -n "$value" ]]; then
    printf '%s=%q\n' "$name" "$value"
  fi
}

emit_var "DISC" "$DISC"
emit_var "ROLE" "$ROLE"
emit_var "BASE" "${BASE:-}"
emit_var "EXT" "$EXT"
emit_var "RUNTIME" "${RUNTIME:-}"
emit_var "INJECT_BEFORE" "${INJECT_BEFORE:-}"
emit_var "INJECT_AFTER" "${INJECT_AFTER:-}"
emit_var "MODEL_SUGGESTED" "${MODEL_SUGGESTED:-}"
emit_var "MODEL_TEMPERATURE" "${MODEL_TEMPERATURE:-}"
emit_var "MODEL_MAX_TOKENS" "${MODEL_MAX_TOKENS:-}"
