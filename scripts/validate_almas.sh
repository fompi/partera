#!/usr/bin/env bash
# validate_almas.sh — Valida todas las almas del sistema
# Verifica: campos requeridos, piezas referenciadas, herencia no circular, consistencia de IDs
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
ALMAS_DIR="$ROOT_DIR/almas"

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BOLD='\033[1m'
RESET='\033[0m'

ERRORS=0
WARNINGS=0
CHECKED=0

error() { echo -e "${RED}  ✗ $1${RESET}"; ERRORS=$((ERRORS + 1)); }
warn()  { echo -e "${YELLOW}  ⚠ $1${RESET}"; WARNINGS=$((WARNINGS + 1)); }
ok()    { echo -e "${GREEN}  ✓ $1${RESET}"; }

if ! command -v yq &>/dev/null; then
  echo "Error: yq no encontrado. Instalar: brew install yq  o  pip install yq" >&2
  exit 1
fi

if [[ ! -d "$ALMAS_DIR" ]]; then
  echo "No hay directorio almas/ — nada que validar"
  exit 0
fi

# Resuelve ruta lógica (p. ej. techniques/security/foo) a ruta en layers/
resolve_piece_path() {
  local piece_path="$1"
  case "$piece_path" in
    patterns/*)      echo "$ROOT_DIR/layers/04_patterns/${piece_path#patterns/}" ;;
    knowledge/*)     echo "$ROOT_DIR/layers/05_knowledge/${piece_path#knowledge/}" ;;
    techniques/*)    echo "$ROOT_DIR/layers/07_techniques/${piece_path#techniques/}" ;;
    modifiers/*)     echo "$ROOT_DIR/layers/08_modifiers/${piece_path#modifiers/}" ;;
    sources/*)       echo "$ROOT_DIR/layers/09_sources/${piece_path#sources/}" ;;
    protocols/*)     echo "$ROOT_DIR/layers/10_protocols/${piece_path#protocols/}" ;;
    capabilities/*)  echo "$ROOT_DIR/layers/11_capabilities/${piece_path#capabilities/}" ;;
    runtimes/*)      echo "$ROOT_DIR/layers/12_runtimes/${piece_path#runtimes/}" ;;
    *)               echo "$ROOT_DIR/${piece_path}" ;;
  esac
}

check_piece_exists() {
  local piece_path="$1"
  local file
  file=$(resolve_piece_path "$piece_path")
  [[ "$file" != *.md ]] && file="${file}.md"
  [[ -f "$file" ]]
}

check_extends_chain() {
  local alma_file="$1"
  local visited="$2"
  local extends
  extends=$(yq -r '.extends // empty' "$alma_file" 2>/dev/null || true)

  if [[ -z "$extends" ]]; then
    return 0
  fi

  local parent_file="$ALMAS_DIR/${extends}.alma.yaml"
  if [[ ! -f "$parent_file" ]]; then
    error "  extends '$extends' no encontrado ($parent_file)"
    return 1
  fi

  if echo "$visited" | grep -qF "|${extends}|"; then
    error "  herencia circular detectada: $extends ya visitado en cadena $visited"
    return 1
  fi

  check_extends_chain "$parent_file" "${visited}${extends}|"
}

for alma_file in $(find "$ALMAS_DIR" -name "*.alma.yaml" | sort); do
  rel_path="${alma_file#$ALMAS_DIR/}"
  alma_name="${rel_path%.alma.yaml}"
  CHECKED=$((CHECKED + 1))

  echo -e "\n${BOLD}Validando: $alma_name${RESET}"

  # Campo type
  type_val=$(yq -r '.type // empty' "$alma_file" 2>/dev/null || true)
  if [[ "$type_val" != "alma" ]]; then
    error "type debe ser 'alma' (encontrado: '${type_val:-<vacío>}')"
  fi

  # Campos requeridos
  for field in id name version description; do
    val=$(yq -r ".${field} // empty" "$alma_file" 2>/dev/null || true)
    if [[ -z "$val" ]]; then
      error "campo requerido '$field' ausente"
    fi
  done

  # Validar ID matchea nombre de archivo
  id_val=$(yq -r '.id // empty' "$alma_file" 2>/dev/null || true)
  expected_id="alma.$(echo "$alma_name" | tr '/' '.')"
  if [[ -n "$id_val" ]] && [[ "$id_val" != "$expected_id" ]]; then
    warn "id '$id_val' no coincide con el esperado '$expected_id'"
  fi

  # compose.discipline y compose.role (requeridos si no hereda)
  extends=$(yq -r '.extends // empty' "$alma_file" 2>/dev/null || true)
  disc=$(yq -r '.compose.discipline // empty' "$alma_file" 2>/dev/null || true)
  role=$(yq -r '.compose.role // empty' "$alma_file" 2>/dev/null || true)

  if [[ -z "$extends" ]]; then
    if [[ -z "$disc" ]]; then
      error "compose.discipline requerido (no hereda de otra alma)"
    fi
    if [[ -z "$role" ]]; then
      error "compose.role requerido (no hereda de otra alma)"
    fi
  fi

  # Verificar herencia no circular
  if [[ -n "$extends" ]]; then
    check_extends_chain "$alma_file" "|"
  fi

  # Verificar piezas referenciadas
  if [[ -n "$disc" ]]; then
    disc_dir="$ROOT_DIR/layers/02_disciplines/$disc"
    if [[ ! -d "$disc_dir" ]]; then
      error "disciplina '$disc' no encontrada en layers/02_disciplines/"
    fi
  fi

  if [[ -n "$role" ]] && [[ -n "$disc" ]]; then
    role_file="$ROOT_DIR/layers/02_disciplines/$disc/06_roles/${role}"
    [[ "$role_file" != *.md ]] && role_file="${role_file}.md"
    if [[ ! -f "$role_file" ]]; then
      error "rol '$role' no encontrado en layers/02_disciplines/$disc/06_roles/"
    fi
  fi

  for category in knowledge techniques modifiers sources protocols capabilities; do
    prefix="$category"
    # techniques -> techniques/
    case "$category" in
      knowledge)    prefix="knowledge" ;;
      techniques)   prefix="techniques" ;;
      modifiers)    prefix="modifiers" ;;
      sources)      prefix="sources" ;;
      protocols)    prefix="protocols" ;;
      capabilities) prefix="capabilities" ;;
    esac

    items=$(yq -r ".compose.${category} // [] | .[]" "$alma_file" 2>/dev/null || true)
    while IFS= read -r item; do
      [[ -z "$item" ]] && continue
      if ! check_piece_exists "${prefix}/${item}"; then
        error "pieza '${prefix}/${item}' no encontrada"
      fi
    done <<< "$items"
  done

  runtime=$(yq -r '.compose.runtime // empty' "$alma_file" 2>/dev/null || true)
  if [[ -n "$runtime" ]]; then
    if ! check_piece_exists "runtimes/${runtime}"; then
      error "runtime '$runtime' no encontrado en layers/12_runtimes/"
    fi
  fi

  # Si no hubo errores para esta alma, ok
  if [[ "$ERRORS" -eq 0 ]] || true; then
    ok "$alma_name"
  fi
done

echo -e "\n${BOLD}=== Resumen ===${RESET}"
echo -e "  Almas validadas: $CHECKED"
echo -e "  Errores: $ERRORS"
echo -e "  Advertencias: $WARNINGS"

if [[ "$ERRORS" -eq 0 ]]; then
  echo -e "\n${GREEN}${BOLD}✓ Todas las almas son válidas${RESET}"
else
  echo -e "\n${RED}${BOLD}✗ $ERRORS error(es) encontrado(s)${RESET}"
fi

[[ "$ERRORS" -eq 0 ]]
