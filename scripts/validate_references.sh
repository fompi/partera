#!/usr/bin/env bash
# validate_references.sh — Valida que todas las referencias en roles (capabilities,
# protocols, sources) apuntan a archivos existentes en sus directorios respectivos.
# Uso: ./scripts/validate_references.sh [--quiet]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

QUIET=0
[[ "${1:-}" == "--quiet" ]] && QUIET=1

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RESET='\033[0m'

errors=0
warnings=0
checked=0

log_error() { printf "${RED}ERROR${RESET}  %s\n" "$1"; errors=$((errors+1)); }
log_warn()  { printf "${YELLOW}WARN${RESET}   %s\n" "$1"; warnings=$((warnings+1)); }
log_ok()    { [[ $QUIET -eq 0 ]] && printf "${GREEN}OK${RESET}     %s\n" "$1" || true; }
log_info()  { [[ $QUIET -eq 0 ]] && printf "${BLUE}INFO${RESET}   %s\n" "$1" || true; }

# Extrae campo escalar del front-matter
get_field() {
  local file="$1" field="$2"
  awk '/^---$/{found++; next} found==1{print} found==2{exit}' "$file" \
    | grep "^${field}:" | head -1 | sed 's/^[^:]*: *//'
}

# Extrae valores de una lista YAML (soporta inline [a, b] y multiline con -)
get_list_values() {
  local file="$1" field="$2"
  # multiline
  awk '/^---$/{found++; next} found==1{print} found==2{exit}' "$file" \
    | awk "/^${field}:/{found=1; next} found && /^  - /{print \$2; next} found && /^[^ ]/{exit}"
  # inline
  get_field "$file" "$field" | tr -d '[]' | tr ',' '\n' | tr -d ' ' | grep -v '^$' || true
}

# Verifica que un valor referencia existe como <dir>/<value>.md (dir bajo layers/)
check_ref() {
  local role_rel="$1" field="$2" value="$3" dir="$4" optional="$5"
  if [[ -z "$value" ]]; then return; fi
  local target="$REPO_DIR/$dir/$value.md"
  if [[ -f "$target" ]]; then
    log_ok "$role_rel — $field '$value' existe ✓"
  else
    if [[ "$optional" == "optional" ]]; then
      log_warn "$role_rel — $field '$value' no encontrado en $dir/ (opcional)"
    else
      log_error "$role_rel — $field '$value' no encontrado en $dir/"
    fi
  fi
}

echo ""
log_info "Validando referencias en roles de todas las disciplinas..."
echo "────────────────────────────────────────────────────────────"

while IFS= read -r -d '' file; do
  rel="${file#$REPO_DIR/}"
  checked=$((checked+1))

  # capabilities_required (error si falta)
  while IFS= read -r val; do
    [[ -z "$val" ]] && continue
    check_ref "$rel" "capabilities_required" "$val" "layers/11_capabilities" "required"
  done < <(get_list_values "$file" "capabilities_required" | sort -u)

  # capabilities_optional (warning si falta)
  while IFS= read -r val; do
    [[ -z "$val" ]] && continue
    check_ref "$rel" "capabilities_optional" "$val" "layers/11_capabilities" "optional"
  done < <(get_list_values "$file" "capabilities_optional" | sort -u)

  # protocols_recommended (warning si falta)
  while IFS= read -r val; do
    [[ -z "$val" ]] && continue
    check_ref "$rel" "protocols_recommended" "$val" "layers/10_protocols" "optional"
  done < <(get_list_values "$file" "protocols_recommended" | sort -u)

  # sources_recommended (warning si falta)
  while IFS= read -r val; do
    [[ -z "$val" ]] && continue
    check_ref "$rel" "sources_recommended" "$val" "layers/09_sources" "optional"
  done < <(get_list_values "$file" "sources_recommended" | sort -u)

done < <(find "$REPO_DIR/layers/02_disciplines" -name "_index.md" -print0 2>/dev/null | sort -z)

echo ""
echo "════════════════════════════════════════════════════════════"
printf "Roles revisados: ${BLUE}%d${RESET}\n" "$checked"
printf "Errores:         ${RED}%d${RESET}\n" "$errors"
printf "Advertencias:    ${YELLOW}%d${RESET}\n" "$warnings"
echo "════════════════════════════════════════════════════════════"

if [[ $errors -gt 0 ]]; then
  printf "${RED}FALLO: %d referencia(s) requerida(s) no resuelta(s)${RESET}\n" "$errors"
  exit 1
else
  printf "${GREEN}OK: todas las referencias requeridas están resueltas${RESET}\n"
  exit 0
fi
