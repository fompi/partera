#!/usr/bin/env bash
# validate_all_disciplines.sh — Valida todas las disciplinas y genera reporte consolidado
# Uso: ./scripts/validate_all_disciplines.sh
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
BOLD='\033[1m'
RESET='\033[0m'

DISCIPLINES=(engineering content design business management)

total_errors=0
total_warnings=0

# Parallel arrays (bash 3 compatible)
statuses=()
disc_err_counts=()
disc_warn_counts=()

echo ""
printf "${BOLD}═══════════════════════════════════════════════════════════════${RESET}\n"
printf "${BOLD}  Validación completa del sistema de disciplinas${RESET}\n"
printf "${BOLD}═══════════════════════════════════════════════════════════════${RESET}\n"

for disc in "${DISCIPLINES[@]}"; do
  echo ""
  printf "${BLUE}▶ Validando disciplina: %s${RESET}\n" "$disc"
  echo "───────────────────────────────────────────────────────────────"

  set +e
  output=$("$SCRIPT_DIR/validate_discipline.sh" "$disc" 2>&1)
  exit_code=$?
  set -e

  echo "$output"

  # Extraer contadores (strip ANSI codes primero para compatibilidad macOS)
  clean=$(echo "$output" | sed 's/\x1b\[[0-9;]*m//g')
  errors=$(echo "$clean" | grep 'Errores:' | tail -1 | sed 's/.*Errores:[^0-9]*\([0-9]*\).*/\1/')
  warnings=$(echo "$clean" | grep 'Advertencias:' | tail -1 | sed 's/.*Advertencias:[^0-9]*\([0-9]*\).*/\1/')

  errors="${errors:-0}"
  warnings="${warnings:-0}"

  disc_err_counts+=("$errors")
  disc_warn_counts+=("$warnings")
  total_errors=$((total_errors + errors))
  total_warnings=$((total_warnings + warnings))

  if [[ $exit_code -eq 0 ]]; then
    statuses+=("OK")
  else
    statuses+=("FAIL")
  fi
done

# ─── Reporte consolidado ─────────────────────────────────────────────────────
echo ""
printf "${BOLD}═══════════════════════════════════════════════════════════════${RESET}\n"
printf "${BOLD}  REPORTE CONSOLIDADO${RESET}\n"
printf "${BOLD}═══════════════════════════════════════════════════════════════${RESET}\n"
echo ""
printf "  %-20s  %-8s  %-8s  %-8s\n" "Disciplina" "Estado" "Errores" "Warnings"
printf "  %-20s  %-8s  %-8s  %-8s\n" "────────────────────" "────────" "────────" "────────"

for i in "${!DISCIPLINES[@]}"; do
  disc="${DISCIPLINES[$i]}"
  status="${statuses[$i]}"
  errors="${disc_err_counts[$i]}"
  warns="${disc_warn_counts[$i]}"

  if [[ "$status" == "OK" ]]; then
    printf "  %-20s  ${GREEN}%-8s${RESET}  %-8s  %-8s\n" "$disc" "$status" "$errors" "$warns"
  else
    printf "  %-20s  ${RED}%-8s${RESET}  %-8s  %-8s\n" "$disc" "$status" "$errors" "$warns"
  fi
done

echo ""
printf "  ${BOLD}Total errores: ${RED}%d${RESET}  |  ${BOLD}Total warnings: ${YELLOW}%d${RESET}\n" \
  "$total_errors" "$total_warnings"
echo ""

if [[ $total_errors -gt 0 ]]; then
  printf "${RED}${BOLD}FALLO: %d error(es) en el sistema. Revisar disciplinas marcadas como FAIL.${RESET}\n" \
    "$total_errors"
  echo ""
  exit 1
else
  printf "${GREEN}${BOLD}OK: Todas las disciplinas válidas.${RESET}\n"
  if [[ $total_warnings -gt 0 ]]; then
    printf "${YELLOW}  %d warning(s) — revisar referencias a capabilities/protocols (normal en Fase 4).${RESET}\n" \
      "$total_warnings"
  fi
  echo ""
  exit 0
fi
