#!/usr/bin/env bash
# migrate_compose_cmd.sh — Convierte comandos legacy a la nueva sintaxis de disciplinas.
# Uso: ./scripts/migrate_compose_cmd.sh <comando_legacy>
# Ejemplo:
#   ./scripts/migrate_compose_cmd.sh "make compose ADAPTER=python ROLE=01_security/_index"
#   → make compose DISC=engineering ADAPTER=python ROLE=audit/01_security/_index
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RESET='\033[0m'

usage() {
  cat <<'USAGE'
Convierte comandos legacy de audit-prompts a la nueva sintaxis de disciplinas.

Uso:
  ./scripts/migrate_compose_cmd.sh "<comando_legacy>"
  ./scripts/migrate_compose_cmd.sh --interactive

Ejemplos legacy → nuevo:
  make compose ADAPTER=python ROLE=01_security/_index
  → make compose DISC=engineering ADAPTER=python ROLE=audit/01_security/_index

  make compose LANG=bash ROLE=02_performance/_index
  → make compose DISC=engineering ADAPTER=bash ROLE=audit/02_performance/_index

  bash compose.sh python 01_security/01a_injection_surfaces
  → DISC=engineering bash compose.sh python audit/01_security/_index EXT="techniques/security/injection-analysis"

Opciones:
  --interactive   Modo interactivo paso a paso
  --dry-run       Muestra la traducción sin ejecutarla
USAGE
  exit 1
}

# Mapa de subtasks legacy → técnicas nuevas
subtask_to_technique() {
  local subtask="$1"
  case "$subtask" in
    01_security/01a_injection_surfaces)    echo "techniques/security/injection-analysis" ;;
    01_security/01b_auth_access_control)   echo "techniques/security/auth-access-control" ;;
    01_security/01c_secrets_crypto)        echo "techniques/security/secrets-crypto" ;;
    01_security/01d_supply_chain)          echo "techniques/security/supply-chain" ;;
    02_performance/02a_algorithmic_complexity) echo "techniques/performance/algorithmic-complexity" ;;
    02_performance/02b_io_network_concurrency) echo "techniques/performance/io-network-concurrency" ;;
    02_performance/02c_memory_resources)   echo "techniques/performance/memory-resources" ;;
    04_correctness/04a_edge_cases_contracts) echo "techniques/correctness/edge-cases-contracts" ;;
    04_correctness/04b_concurrency_state)  echo "techniques/correctness/concurrency-state" ;;
    04_correctness/04c_error_handling)     echo "techniques/correctness/error-handling" ;;
    *) echo "" ;;
  esac
}

# Convierte un ROLE legacy a su equivalente nuevo
convert_role() {
  local role="$1"
  # Quitar extensión .md si la tiene
  role="${role%.md}"

  # Detectar si es un subtask (tiene subtask: 01a_, 01b_, etc.)
  if echo "$role" | grep -qE '/[0-9]+[a-z]_'; then
    local technique
    technique=$(subtask_to_technique "$role")
    if [[ -n "$technique" ]]; then
      # Extraer el rol padre (ej: 01_security/_index)
      local parent_dir
      parent_dir=$(echo "$role" | cut -d/ -f1)
      echo "ROLE=audit/${parent_dir}/_index EXT=\"${technique}\""
      return
    fi
  fi

  # Rol simple o _index
  if echo "$role" | grep -qE '^[0-9]+_[^/]+/_index$'; then
    echo "ROLE=audit/${role}"
  elif echo "$role" | grep -qE '^[0-9]+_[^/]+$'; then
    echo "ROLE=audit/${role}/_index"
  else
    echo "ROLE=audit/${role}"
  fi
}

[[ $# -lt 1 ]] && usage

if [[ "${1:-}" == "--interactive" ]]; then
  echo "=== Modo interactivo ==="
  echo ""
  printf "Adaptador/lenguaje (python|bash): "
  read -r adapter
  printf "Rol legacy (ej: 01_security/_index): "
  read -r role_legacy
  printf "Ejecutar el nuevo comando? [s/N]: "
  read -r execute

  new_role=$(convert_role "$role_legacy")
  new_cmd="DISC=engineering make compose ADAPTER=${adapter} ${new_role}"

  echo ""
  printf "${YELLOW}Comando legacy:${RESET}  make compose ADAPTER=${adapter} ROLE=${role_legacy}\n"
  printf "${GREEN}Comando nuevo:${RESET}   ${new_cmd}\n"

  if [[ "${execute,,}" == "s" ]]; then
    echo ""
    echo "Ejecutando..."
    eval "$new_cmd"
  fi
  exit 0
fi

# Modo línea de comandos: parsear el comando pasado como argumento
cmd="$1"
dry_run=0
[[ "${2:-}" == "--dry-run" ]] && dry_run=1

# Extraer ADAPTER/LANG y ROLE del comando
adapter=$(echo "$cmd" | grep -oE '(ADAPTER|LANG)=[^ ]+' | head -1 | sed 's/.*=//')
role=$(echo "$cmd" | grep -oE 'ROLE=[^ ]+' | head -1 | sed 's/ROLE=//')

if [[ -z "$adapter" ]] || [[ -z "$role" ]]; then
  echo "Error: no se pudo parsear ADAPTER/LANG y ROLE del comando." >&2
  echo "Formato esperado: make compose ADAPTER=python ROLE=01_security/_index" >&2
  exit 1
fi

new_role=$(convert_role "$role")
new_cmd="DISC=engineering make compose ADAPTER=${adapter} ${new_role}"

echo ""
printf "${YELLOW}Legacy:${RESET}  %s\n" "$cmd"
printf "${GREEN}Nuevo:${RESET}   %s\n" "$new_cmd"
echo ""

if [[ $dry_run -eq 0 ]]; then
  printf "¿Ejecutar el nuevo comando? [s/N]: "
  read -r confirm
  if [[ "${confirm,,}" == "s" ]]; then
    echo "Ejecutando..."
    eval "$new_cmd"
  fi
fi
