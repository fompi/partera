#!/usr/bin/env bash
# list_by_type.sh — Lista piezas del sistema de prompts por tipo/disciplina
# Uso:
#   ./scripts/list_by_type.sh disciplines
#   ./scripts/list_by_type.sh adapters [disciplina]
#   ./scripts/list_by_type.sh roles    [disciplina]
#   ./scripts/list_by_type.sh techniques
#   ./scripts/list_by_type.sh sources
#   ./scripts/list_by_type.sh protocols
#   ./scripts/list_by_type.sh capabilities
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

BOLD='\033[1m'
CYAN='\033[0;36m'
DIM='\033[2m'
RESET='\033[0m'

usage() {
  cat <<USAGE
Uso: $0 <tipo> [disciplina]

Tipos disponibles:
  disciplines              — Lista todas las disciplinas
  adapters  [disciplina]   — Lista adaptadores (de una disciplina o todos)
  roles     [disciplina]   — Lista roles (de una disciplina o todos)
  techniques               — Lista técnicas disponibles
  sources                  — Lista fuentes disponibles
  protocols                — Lista protocolos disponibles
  capabilities             — Lista capabilities disponibles

Ejemplos:
  $0 disciplines
  $0 adapters engineering
  $0 roles engineering
  $0 techniques
USAGE
  exit 1
}

# Extrae un campo del front-matter
get_field() {
  local file="$1" field="$2"
  awk '/^---$/{found++; next} found==1{print} found==2{exit}' "$file" \
    | grep "^${field}:" | head -1 | sed 's/^[^:]*: *//'
}

# Muestra info de un archivo .md con front-matter
show_entry() {
  local file="$1"
  # Saltar si no tiene front-matter
  head -1 "$file" | grep -q '^---$' || return

  local id name description tags
  id=$(get_field "$file" "id")
  name=$(get_field "$file" "name")
  description=$(get_field "$file" "description")
  tags=$(get_field "$file" "tags")

  # Primera línea de description
  local desc_short
  desc_short=$(echo "$description" | head -1 | sed 's/^["'"'"']\(.*\)["'"'"']$/\1/')

  printf "  ${CYAN}%-30s${RESET} ${BOLD}%s${RESET}\n" "${id:-$(basename "$file" .md)}" "${name:-N/A}"
  [[ -n "$desc_short" ]] && printf "  ${DIM}%-30s${RESET} %s\n" "" "$desc_short"
  [[ -n "$tags" ]]        && printf "  ${DIM}%-30s${RESET} tags: %s\n" "" "$tags"
  echo ""
}

list_in_dir() {
  local dir="$1" title="$2"
  printf "${BOLD}%s${RESET}\n\n" "$title"

  local found=0
  while IFS= read -r -d '' file; do
    show_entry "$file"
    found=1
  done < <(find "$dir" -maxdepth 1 -name "*.md" -not -name "_*.md" -print0 2>/dev/null | sort -z)

  # También mostrar _index si existe
  if [[ -f "$dir/_index.md" ]]; then
    show_entry "$dir/_index.md"
    found=1
  fi

  if [[ $found -eq 0 ]]; then
    printf "  ${DIM}(ninguno aún)${RESET}\n\n"
  fi
}

list_recursive_by_type() {
  local search_path="$1" type_filter="$2" title="$3"
  printf "${BOLD}%s${RESET}\n\n" "$title"

  local found=0
  while IFS= read -r -d '' file; do
    local type
    type=$(get_field "$file" "type" 2>/dev/null || echo "")
    if [[ "$type" == "$type_filter" ]]; then
      show_entry "$file"
      found=1
    fi
  done < <(find "$search_path" -name "*.md" -print0 2>/dev/null | sort -z)

  if [[ $found -eq 0 ]]; then
    printf "  ${DIM}(ninguno aún)${RESET}\n\n"
  fi
}

# --- Main ---

[[ $# -lt 1 ]] && usage

SUBCMD="$1"
DISC="${2:-}"

case "$SUBCMD" in
  disciplines)
    printf "${BOLD}Disciplinas disponibles${RESET}\n\n"
    if [[ -d "$REPO_DIR/disciplines" ]]; then
      for d in "$REPO_DIR/disciplines"/*/; do
        [[ -d "$d" ]] || continue
        disc_name=$(basename "$d")
        printf "  ${CYAN}%-20s${RESET}" "$disc_name"
        # Mostrar _base.md si existe
        if [[ -f "$d/_base.md" ]]; then
          local_name=$(get_field "$d/_base.md" "name" 2>/dev/null || echo "")
          [[ -n "$local_name" ]] && printf " — %s" "$local_name"
        fi
        printf "\n"
      done
    else
      printf "  ${DIM}(directorio disciplines/ no existe aún)${RESET}\n"
    fi
    echo ""
    ;;

  adapters)
    if [[ -n "$DISC" ]]; then
      search="$REPO_DIR/disciplines/$DISC/adapters"
      list_in_dir "$search" "Adaptadores — disciplina: $DISC"
    else
      list_recursive_by_type "$REPO_DIR/disciplines" "adapter" "Todos los adaptadores"
    fi
    ;;

  roles)
    if [[ -n "$DISC" ]]; then
      search="$REPO_DIR/disciplines/$DISC/roles"
      printf "${BOLD}Roles — disciplina: $DISC${RESET}\n\n"
      found=0
      while IFS= read -r -d '' file; do
        show_entry "$file"
        found=1
      done < <(find "$search" -name "*.md" -print0 2>/dev/null | sort -z)
      if [[ $found -eq 0 ]]; then
        printf "  ${DIM}(ninguno aún)${RESET}\n\n"
      fi
    else
      list_recursive_by_type "$REPO_DIR/disciplines" "role" "Todos los roles"
    fi
    ;;

  techniques)
    printf "${BOLD}Técnicas disponibles${RESET}\n\n"
    if [[ -d "$REPO_DIR/techniques" ]]; then
      for area in "$REPO_DIR/techniques"/*/; do
        [[ -d "$area" ]] || continue
        printf "  ${CYAN}%s/${RESET}\n" "$(basename "$area")"
        while IFS= read -r -d '' file; do
          [[ "$(basename "$file")" == ".gitkeep" ]] && continue
          show_entry "$file"
        done < <(find "$area" -name "*.md" -print0 2>/dev/null | sort -z)
      done
    else
      printf "  ${DIM}(directorio techniques/ no existe aún)${RESET}\n"
    fi
    echo ""
    ;;

  sources)
    list_in_dir "$REPO_DIR/sources" "Fuentes disponibles"
    ;;

  protocols)
    list_in_dir "$REPO_DIR/protocols" "Protocolos disponibles"
    ;;

  capabilities)
    list_in_dir "$REPO_DIR/capabilities" "Capabilities disponibles"
    ;;

  *)
    echo "Tipo desconocido: $SUBCMD" >&2
    usage
    ;;
esac
