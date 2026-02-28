#!/usr/bin/env bash
# validate_chains.sh — Valida todos los chains del sistema
# Verifica: front-matter YAML, campos requeridos, existencia de los roles referenciados
# Referencia: docs/chains-and-patterns.md, chains/_schema.yaml
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
CHAINS_DIR="$ROOT_DIR/chains"

RED='\033[0;31m'
GREEN='\033[0;32m'
BOLD='\033[1m'
RESET='\033[0m'

ERRORS=0
CHECKED=0

error() { echo -e "${RED}  ✗ $1${RESET}"; ERRORS=$((ERRORS + 1)); }
ok()    { echo -e "${GREEN}  ✓ $1${RESET}"; }

if [[ ! -d "$CHAINS_DIR" ]]; then
  echo "No hay directorio chains/ — nada que validar"
  exit 0
fi

# Resolver role_id (engineering.audit.0001_security) → DISC y ruta de roles (audit/0001_security/_index)
resolve_role() {
  local role_id="$1"
  local disc subpath role_path
  disc=$(echo "$role_id" | cut -d. -f1)
  subpath=$(echo "$role_id" | cut -d. -f2-)
  role_path=$(echo "$subpath" | tr '.' '/')
  role_path="${role_path}/_index"
  echo "${disc}|${role_path}"
}

# Extraer steps del front-matter (role por línea)
get_steps_roles() {
  local file="$1"
  awk '/^---$/{found++; next} found==2{exit} found==1{print}' "$file" \
    | grep -E '^\s+role:' | sed 's/.*role: *//; s/"//g; s/^ *//; s/ *$//'
}

get_field() {
  local file="$1" field="$2"
  awk '/^---$/{found++; next} found==1{print} found==2{exit}' "$file" \
    | grep "^${field}:" | head -1 | sed 's/^[^:]*: *//' | tr -d '"'
}

for chain_file in "$CHAINS_DIR"/*.chain; do
  [[ -f "$chain_file" ]] || continue
  base=$(basename "$chain_file" .chain)
  CHECKED=$((CHECKED + 1))

  echo -e "\n${BOLD}Validando: $base${RESET}"

  # Campos requeridos
  for field in id type name description steps; do
    val=$(get_field "$chain_file" "$field" 2>/dev/null || true)
    if [[ -z "$val" ]] && [[ "$field" != "steps" ]]; then
      error "falta campo '$field' en front-matter"
    fi
  done

  type_val=$(get_field "$chain_file" "type" 2>/dev/null || true)
  if [[ -n "$type_val" ]] && [[ "$type_val" != "chain" ]]; then
    error "type debe ser 'chain' (encontrado: '$type_val')"
  fi

  # Validar cada step: role existe en disciplines/<disc>/roles/<path>.md
  while IFS= read -r role_id; do
    [[ -n "$role_id" ]] || continue
    resolved=$(resolve_role "$role_id")
    disc=$(echo "$resolved" | cut -d'|' -f1)
    role_path=$(echo "$resolved" | cut -d'|' -f2)
    role_file="$ROOT_DIR/disciplines/$disc/roles/${role_path}.md"
    if [[ ! -f "$role_file" ]]; then
      error "rol '$role_id' → $role_file no existe"
    else
      ok "rol '$role_id' → disciplines/$disc/roles/${role_path}.md"
    fi
  done < <(get_steps_roles "$chain_file")

  if [[ $ERRORS -eq 0 ]]; then
    ok "chain '$base' válido"
  fi
done

echo ""
if [[ $ERRORS -gt 0 ]]; then
  echo -e "${RED}Errores: $ERRORS${RESET}"
  exit 1
fi
echo -e "${GREEN}Chains validados: $CHECKED. Sin errores.${RESET}"
