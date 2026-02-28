#!/usr/bin/env bash
# list_almas.sh — Lista almas disponibles con nombre, descripción y composición resumida
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
ALMAS_DIR="$ROOT_DIR/almas"

CYAN='\033[0;36m'
DIM='\033[2m'
BOLD='\033[1m'
RESET='\033[0m'

if ! command -v yq &>/dev/null; then
  echo "Error: yq no encontrado. Instalar: brew install yq  o  pip install yq" >&2
  exit 1
fi

if [[ ! -d "$ALMAS_DIR" ]]; then
  echo "No hay directorio almas/ — ninguna alma definida."
  exit 0
fi

alma_files=$(find "$ALMAS_DIR" -name "*.alma.yaml" | sort)
count=$(echo "$alma_files" | grep -c '\.alma\.yaml$' || true)

if [[ "$count" -eq 0 ]]; then
  echo "No se encontraron almas."
  exit 0
fi

echo -e "${BOLD}Almas disponibles ($count):${RESET}"
echo ""

current_dir=""
while IFS= read -r alma_file; do
  rel_path="${alma_file#$ALMAS_DIR/}"
  alma_name="${rel_path%.alma.yaml}"
  dir_name=$(dirname "$rel_path")

  if [[ "$dir_name" != "$current_dir" ]]; then
    current_dir="$dir_name"
    echo -e "  ${BOLD}${dir_name}/${RESET}"
  fi

  name=$(yq -r '.name // empty' "$alma_file" 2>/dev/null || true)
  desc=$(yq -r '.description // empty' "$alma_file" 2>/dev/null || true)
  extends=$(yq -r '.extends // empty' "$alma_file" 2>/dev/null || true)
  disc=$(yq -r '.compose.discipline // empty' "$alma_file" 2>/dev/null || true)
  role=$(yq -r '.compose.role // empty' "$alma_file" 2>/dev/null || true)

  base_name=$(basename "$alma_name")
  printf "    ${CYAN}%-30s${RESET} %s\n" "$base_name" "${name:-$alma_name}"

  if [[ -n "$desc" ]]; then
    printf "    ${DIM}%-30s %s${RESET}\n" "" "$desc"
  fi

  compose_parts=()
  [[ -n "$disc" ]] && compose_parts+=("disc=$disc")
  [[ -n "$role" ]] && compose_parts+=("role=$role")
  [[ -n "$extends" ]] && compose_parts+=("extends=$extends")

  tech_count=$(yq -r '.compose.techniques // [] | length' "$alma_file" 2>/dev/null || echo "0")
  [[ "$tech_count" -gt 0 ]] && compose_parts+=("${tech_count} técnicas")

  mod_count=$(yq -r '.compose.modifiers // [] | length' "$alma_file" 2>/dev/null || echo "0")
  [[ "$mod_count" -gt 0 ]] && compose_parts+=("${mod_count} modifiers")

  runtime=$(yq -r '.compose.runtime // empty' "$alma_file" 2>/dev/null || true)
  [[ -n "$runtime" ]] && compose_parts+=("runtime=$runtime")

  if [[ ${#compose_parts[@]} -gt 0 ]]; then
    printf "    ${DIM}%-30s [%s]${RESET}\n" "" "$(IFS=', '; echo "${compose_parts[*]}")"
  fi
done <<< "$alma_files"

echo ""
echo -e "Uso:"
echo -e "  ${CYAN}make alma ALMA=<nombre> ADAPTER=<adaptador>${RESET}"
echo -e "  ${CYAN}./compose.sh --alma <nombre> <adaptador>${RESET}"
echo ""
echo -e "Ejemplo:"
echo -e "  ${CYAN}make alma ALMA=v02/security-deep ADAPTER=python${RESET}"
