#!/usr/bin/env bash
# test_compose_legacy.sh — Tests de regresión para el modo legacy de compose.sh
# Verifica que los comandos existentes siguen produciendo el mismo output tras la migración.
# Uso: ./scripts/test_compose_legacy.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
COMPOSE="$REPO_DIR/compose.sh"

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
RESET='\033[0m'

passed=0
failed=0
skipped=0

run_test() {
  local description="$1"
  shift
  local cmd=("$@")

  printf "  Testing: %s ... " "$description"

  local output exit_code
  if output=$("${cmd[@]}" 2>&1); then
    exit_code=0
  else
    exit_code=$?
  fi

  if [[ $exit_code -ne 0 ]]; then
    printf "${RED}FAIL${RESET} (exit $exit_code)\n"
    printf "    Output: %s\n" "$(echo "$output" | head -3)"
    failed=$((failed+1))
    return
  fi

  # Verificar que el output no está vacío
  if [[ -z "$output" ]]; then
    printf "${RED}FAIL${RESET} (output vacío)\n"
    failed=$((failed+1))
    return
  fi

  # Verificar que contiene la sección de la base
  if ! echo "$output" | grep -q "Anti-alucinación"; then
    printf "${RED}FAIL${RESET} (no contiene contenido de base)\n"
    failed=$((failed+1))
    return
  fi

  local lines
  lines=$(echo "$output" | wc -l | tr -d ' ')
  printf "${GREEN}PASS${RESET} (%s líneas)\n" "$lines"
  passed=$((passed+1))
}

check_file_exists() {
  local description="$1" file="$2"
  printf "  Checking: %s ... " "$description"
  if [[ -f "$file" ]]; then
    printf "${GREEN}OK${RESET}\n"
    passed=$((passed+1))
  else
    printf "${RED}MISSING${RESET} ($file)\n"
    failed=$((failed+1))
  fi
}

echo "=== Tests de regresión — compose.sh legacy ==="
echo ""

echo "--- Archivos requeridos ---"
check_file_exists "_base_audit.md" "$REPO_DIR/_base_audit.md"
check_file_exists "lang/python.md" "$REPO_DIR/lang/python.md"
check_file_exists "lang/bash.md"   "$REPO_DIR/lang/bash.md"
check_file_exists "00_orchestrator/_index.md" "$REPO_DIR/00_orchestrator/_index.md"
check_file_exists "01_security/_index.md"     "$REPO_DIR/01_security/_index.md"
check_file_exists "02_performance/_index.md"  "$REPO_DIR/02_performance/_index.md"
check_file_exists "04_correctness/_index.md"  "$REPO_DIR/04_correctness/_index.md"
echo ""

echo "--- compose.sh (invocación directa) ---"
run_test "python + 00_orchestrator/_index" \
  bash "$COMPOSE" python 00_orchestrator/_index

run_test "python + 01_security/_index" \
  bash "$COMPOSE" python 01_security/_index

run_test "bash + 02_performance/_index" \
  bash "$COMPOSE" bash 02_performance/_index

run_test "python + 04_correctness/_index" \
  bash "$COMPOSE" python 04_correctness/_index
echo ""

echo "--- make compose (LANG=) ---"
# Test make targets using LANG= (old syntax, must still work)
run_test "make compose LANG=python ROLE=01_security/_index" \
  make -s -C "$REPO_DIR" compose LANG=python ROLE=01_security/_index

run_test "make compose LANG=bash ROLE=02_performance/_index" \
  make -s -C "$REPO_DIR" compose LANG=bash ROLE=02_performance/_index
echo ""

echo "--- make compose (ADAPTER=) ---"
# Test make targets using ADAPTER= (new syntax alias)
run_test "make compose ADAPTER=python ROLE=01_security/_index" \
  make -s -C "$REPO_DIR" compose ADAPTER=python ROLE=01_security/_index

run_test "make compose ADAPTER=bash ROLE=00_orchestrator/_index" \
  make -s -C "$REPO_DIR" compose ADAPTER=bash ROLE=00_orchestrator/_index
echo ""

echo "--- Subtasks legacy ---"
if [[ -f "$REPO_DIR/01_security/01a_injection_surfaces.md" ]]; then
  run_test "python + 01_security/01a_injection_surfaces" \
    bash "$COMPOSE" python 01_security/01a_injection_surfaces
else
  printf "  ${YELLOW}SKIP${RESET}  01_security/01a_injection_surfaces.md no existe\n"
  skipped=$((skipped+1))
fi

if [[ -f "$REPO_DIR/02_performance/02a_algorithmic_complexity.md" ]]; then
  run_test "python + 02_performance/02a_algorithmic_complexity" \
    bash "$COMPOSE" python 02_performance/02a_algorithmic_complexity
else
  printf "  ${YELLOW}SKIP${RESET}  02_performance/02a_algorithmic_complexity.md no existe\n"
  skipped=$((skipped+1))
fi
echo ""

echo "--- meta-prompts ---"
run_test "--meta improve_prompt" \
  bash "$COMPOSE" --meta improve_prompt
run_test "--meta evaluate_coverage" \
  bash "$COMPOSE" --meta evaluate_coverage
echo ""

echo "=== Resumen ==="
printf "  ${GREEN}Passed:${RESET}  %d\n" "$passed"
printf "  ${RED}Failed:${RESET}  %d\n"  "$failed"
printf "  ${YELLOW}Skipped:${RESET} %d\n" "$skipped"
echo ""

if [[ $failed -gt 0 ]]; then
  printf "${RED}FALLO: %d test(s) fallaron${RESET}\n" "$failed"
  exit 1
else
  printf "${GREEN}OK: todos los tests pasaron${RESET}\n"
  exit 0
fi
