#!/usr/bin/env bash
# validate_frontmatter.sh — Valida que los archivos .md tienen front-matter YAML correcto
# Uso: ./scripts/validate_frontmatter.sh [directorio]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="${1:-$(dirname "$SCRIPT_DIR")}"

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RESET='\033[0m'

errors=0
warnings=0
checked=0

COMMON_FIELDS="id type name version description tags"

# Campos extra por tipo (sin associative arrays para compatibilidad bash 3)
extra_fields_for_type() {
  case "$1" in
    role)       echo "input output discipline task_type" ;;
    adapter)    echo "discipline" ;;
    technique)  echo "area applicable_disciplines" ;;
    capability) echo "native_in" ;;
    *)          echo "" ;;
  esac
}

log_error() { printf "${RED}ERROR${RESET}  %s\n" "$1" >&2; errors=$((errors+1)); }
log_warn()  { printf "${YELLOW}WARN${RESET}   %s\n" "$1"; warnings=$((warnings+1)); }
log_ok()    { printf "${GREEN}OK${RESET}     %s\n" "$1"; }

# Extrae el valor de un campo del front-matter (entre los dos primeros ---)
get_field() {
  local file="$1" field="$2"
  awk '/^---$/{found++; next} found==1{print} found==2{exit}' "$file" \
    | grep "^${field}:" | head -1 | sed 's/^[^:]*: *//' || true
}

has_frontmatter() {
  head -1 "$1" | grep -q '^---$'
}

validate_file() {
  local file="$1"
  local rel="${file#$REPO_DIR/}"
  checked=$((checked+1))

  if ! has_frontmatter "$file"; then
    log_error "$rel — sin front-matter (el archivo debe comenzar con ---)"
    return
  fi

  local type
  type=$(get_field "$file" "type")

  if [[ -z "$type" ]]; then
    log_error "$rel — campo 'type' ausente o vacío"
    return
  fi

  local file_errors=0

  # Campos comunes obligatorios
  for field in $COMMON_FIELDS; do
    local val
    val=$(get_field "$file" "$field")
    if [[ -z "$val" ]]; then
      log_error "$rel — campo obligatorio '$field' ausente (type=$type)"
      file_errors=$((file_errors+1))
    fi
  done

  # Campos extra por tipo
  local extra
  extra=$(extra_fields_for_type "$type")
  for field in $extra; do
    local val
    val=$(get_field "$file" "$field")
    if [[ -z "$val" ]]; then
      log_warn "$rel — campo recomendado '$field' ausente para type=$type"
    fi
  done

  # Validar formato de id
  local id
  id=$(get_field "$file" "id")
  if [[ -n "$id" ]] && ! echo "$id" | grep -qE '^[a-z0-9._-]+$'; then
    log_warn "$rel — 'id' tiene formato no estándar: '$id' (esperado: minúsculas, puntos, guiones)"
  fi

  # Validar semver
  local version
  version=$(get_field "$file" "version")
  if [[ -n "$version" ]] && ! echo "$version" | grep -qE '^[0-9]+\.[0-9]+\.[0-9]+$'; then
    log_warn "$rel — 'version' no sigue semver: '$version' (esperado: X.Y.Z)"
  fi

  if [[ $file_errors -eq 0 ]]; then
    log_ok "$rel (type=$type)"
  fi
}

echo "Validando front-matter en: $REPO_DIR"
echo "---"

while IFS= read -r -d '' file; do
  if head -1 "$file" | grep -q '^---$'; then
    validate_file "$file"
  fi
done < <(find "$REPO_DIR" \
  -name "*.md" \
  -not -path "*/_archive/*" \
  -not -path "*/node_modules/*" \
  -not -path "*/.git/*" \
  -not -name "README.md" \
  -not -name "CLAUDE.md" \
  -print0 | sort -z)

echo "---"
printf "Archivos con front-matter validados: %d\n" "$checked"
printf "Errores: ${RED}%d${RESET}  |  Advertencias: ${YELLOW}%d${RESET}\n" "$errors" "$warnings"

if [[ $errors -gt 0 ]]; then
  printf "${RED}FALLO: %d error(es) encontrado(s)${RESET}\n" "$errors"
  exit 1
else
  printf "${GREEN}OK: todos los front-matter son válidos${RESET}\n"
  exit 0
fi
