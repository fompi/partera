#!/usr/bin/env bash
# validate_system.sh — Validación exhaustiva de todo el sistema
# Uso: ./scripts/validate_system.sh [--quiet] [--report]
#
# Opciones:
#   --quiet    Suprimir output detallado, solo mostrar resumen
#   --report   Generar reporte en /tmp/system-validation-report.txt

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ROOT_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"

QUIET=false
REPORT=false
REPORT_FILE="/tmp/system-validation-report.txt"

ERRORS=0
WARNINGS=0

# Colores
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
BOLD='\033[1m'
RESET='\033[0m'

for arg in "$@"; do
  case "$arg" in
    --quiet) QUIET=true ;;
    --report) REPORT=true ;;
  esac
done

log()   { [[ "$QUIET" == false ]] && echo -e "$1" || true; }
info()  { log "${BLUE}  $1${RESET}"; }
ok()    { log "${GREEN}  ✓ $1${RESET}"; }
warn()  { log "${YELLOW}  ⚠ $1${RESET}"; WARNINGS=$((WARNINGS + 1)); }
error() { log "${RED}  ✗ $1${RESET}"; ERRORS=$((ERRORS + 1)); }
section() { log "\n${BOLD}=== $1 ===${RESET}"; }

# ─── Paso 1: Front-matter ────────────────────────────────────────────────────

section "Validando Front-matter"

if [[ -x "$SCRIPT_DIR/validate_frontmatter.sh" ]]; then
  if "$SCRIPT_DIR/validate_frontmatter.sh" > /tmp/fm-output.txt 2>&1; then
    ok "Front-matter válido en chains"
  else
    warn "Algunos archivos tienen front-matter inválido (ver /tmp/fm-output.txt)"
    [[ "$QUIET" == false ]] && cat /tmp/fm-output.txt | head -20
  fi
else
  warn "validate_frontmatter.sh no encontrado o no ejecutable"
fi

# ─── Paso 2: Referencias ─────────────────────────────────────────────────────

section "Validando Referencias"

if [[ -x "$SCRIPT_DIR/validate_references.sh" ]]; then
  if "$SCRIPT_DIR/validate_references.sh" > /tmp/ref-output.txt 2>&1; then
    ok "Referencias válidas"
  else
    warn "Algunas referencias rotas (ver /tmp/ref-output.txt)"
    [[ "$QUIET" == false ]] && cat /tmp/ref-output.txt | head -20
  fi
else
  warn "validate_references.sh no encontrado o no ejecutable"
fi

# ─── Paso 3: Disciplinas ─────────────────────────────────────────────────────

section "Validando Disciplinas"

if [[ -x "$SCRIPT_DIR/validate_all_disciplines.sh" ]]; then
  if "$SCRIPT_DIR/validate_all_disciplines.sh" > /tmp/disc-output.txt 2>&1; then
    ok "Todas las disciplinas válidas"
  else
    warn "Algunas disciplinas tienen errores (ver /tmp/disc-output.txt)"
    [[ "$QUIET" == false ]] && cat /tmp/disc-output.txt | head -30
  fi
else
  warn "validate_all_disciplines.sh no encontrado o no ejecutable"
fi

# ─── Paso 4: Almas ───────────────────────────────────────────────────────────

section "Validando Almas"

if [[ -d "$ROOT_DIR/almas" ]]; then
  if [[ -x "$SCRIPT_DIR/validate_almas.sh" ]]; then
    if "$SCRIPT_DIR/validate_almas.sh" > /tmp/almas-output.txt 2>&1; then
      ALMA_COUNT=$(find "$ROOT_DIR/almas" -name "*.alma.yaml" 2>/dev/null | wc -l | tr -d ' ')
      ok "Almas válidas ($ALMA_COUNT almas)"
    else
      warn "Algunas almas tienen errores (ver /tmp/almas-output.txt)"
      [[ "$QUIET" == false ]] && cat /tmp/almas-output.txt | head -20
    fi
  else
    warn "validate_almas.sh no encontrado o no ejecutable"
  fi
else
  info "No hay directorio almas/ — omitiendo validación de almas"
fi

# ─── Paso 5: Chains ──────────────────────────────────────────────────────────

section "Validando Chains"

if [[ -d "$ROOT_DIR/chains" ]]; then
  if [[ -x "$SCRIPT_DIR/validate_chains.sh" ]]; then
    if "$SCRIPT_DIR/validate_chains.sh" > /tmp/chains-output.txt 2>&1; then
      CHAIN_COUNT=$(find "$ROOT_DIR/chains" -name "*.chain" 2>/dev/null | wc -l | tr -d ' ')
      ok "Chains válidos ($CHAIN_COUNT chains)"
    else
      warn "Algunos chains tienen errores (ver /tmp/chains-output.txt)"
      [[ "$QUIET" == false ]] && cat /tmp/chains-output.txt | head -20
    fi
  else
    warn "validate_chains.sh no encontrado o no ejecutable"
  fi
else
  info "No hay directorio chains/ — omitiendo validación de chains"
fi

# ─── Paso 6: Archivos requeridos ──────────────────────────────────────────────

section "Verificando Archivos Requeridos"

# Base universal
if [[ -f "$ROOT_DIR/_base.md" ]]; then
  ok "_base.md presente"
else
  error "_base.md no encontrado — requerido por el sistema"
fi

# compose.sh ejecutable
if [[ -x "$ROOT_DIR/compose.sh" ]]; then
  ok "compose.sh presente y ejecutable"
else
  error "compose.sh no encontrado o no ejecutable"
fi

# Disciplinas: cada una debe tener _base.md
DISCIPLINES=("engineering" "content" "design" "business" "management")
for disc in "${DISCIPLINES[@]}"; do
  disc_base="$ROOT_DIR/disciplines/$disc/_base.md"
  if [[ -f "$disc_base" ]]; then
    ok "disciplines/$disc/_base.md presente"
  else
    error "disciplines/$disc/_base.md no encontrado"
  fi
done

# Meta-prompts requeridos
META_FILES=(
  "meta/_base_meta.md"
  "meta/generate_role.md"
  "meta/generate_adapter.md"
  "meta/generate_discipline.md"
  "meta/generate_technique.md"
  "meta/evaluate_coverage.md"
)
for mf in "${META_FILES[@]}"; do
  if [[ -f "$ROOT_DIR/$mf" ]]; then
    ok "$mf presente"
  else
    error "$mf no encontrado"
  fi
done

# Documentación
DOCS_FILES=(
  "README.md"
  "docs/architecture.md"
  "docs/sfia-mapping.md"
  "docs/migration-guide.md"
)
for df in "${DOCS_FILES[@]}"; do
  if [[ -f "$ROOT_DIR/$df" ]]; then
    ok "$df presente"
  else
    warn "$df no encontrado (documentación recomendada)"
  fi
done

# ─── Paso 7: Inventario del sistema ──────────────────────────────────────────

section "Inventario del Sistema"

# Contar piezas por tipo
count_by_type() {
  local type="$1"
  local dir="$2"
  local ext="${3:-md}"
  find "$dir" -name "*.$ext" 2>/dev/null | xargs grep -l "^type: $type" 2>/dev/null | wc -l | tr -d ' '
}

ROLE_COUNT=$(count_by_type "role" "$ROOT_DIR/disciplines")
TECHNIQUE_COUNT=$(find "$ROOT_DIR/techniques" -name "*.md" 2>/dev/null | grep -v "^$ROOT_DIR/techniques$" | wc -l | tr -d ' ')
ADAPTER_COUNT=$(find "$ROOT_DIR/disciplines" -path "*/adapters/*.md" 2>/dev/null | wc -l | tr -d ' ')
KNOWLEDGE_COUNT=$(find "$ROOT_DIR/knowledge" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
MODIFIER_COUNT=$(find "$ROOT_DIR/modifiers" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
CHAIN_COUNT=$(find "$ROOT_DIR/chains" -name "*.chain" 2>/dev/null | wc -l | tr -d ' ')
RUNTIME_COUNT=$(find "$ROOT_DIR/runtimes" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
PATTERN_COUNT=$(find "$ROOT_DIR/patterns" -name "*.md" 2>/dev/null | wc -l | tr -d ' ')
ALMA_COUNT=$(find "$ROOT_DIR/almas" -name "*.alma.yaml" 2>/dev/null | wc -l | tr -d ' ')

info "Roles:        $ROLE_COUNT"
info "Técnicas:     $TECHNIQUE_COUNT"
info "Adaptadores:  $ADAPTER_COUNT"
info "Knowledge:    $KNOWLEDGE_COUNT"
info "Modifiers:    $MODIFIER_COUNT"
info "Chains:       $CHAIN_COUNT"
info "Runtimes:     $RUNTIME_COUNT"
info "Patterns:     $PATTERN_COUNT"
info "Almas:        $ALMA_COUNT"

# Verificar mínimos razonables
[[ "$ROLE_COUNT" -ge 5 ]]      && ok "Roles: suficientes ($ROLE_COUNT)" || warn "Pocos roles ($ROLE_COUNT)"
[[ "$TECHNIQUE_COUNT" -ge 5 ]] && ok "Técnicas: suficientes ($TECHNIQUE_COUNT)" || warn "Pocas técnicas ($TECHNIQUE_COUNT)"
[[ "$ADAPTER_COUNT" -ge 2 ]]   && ok "Adaptadores: suficientes ($ADAPTER_COUNT)" || warn "Pocos adaptadores ($ADAPTER_COUNT)"

# ─── Paso 8: Validación de IDs únicos ────────────────────────────────────────

section "Validando Unicidad de IDs"

# Extraer todos los IDs del sistema
IDS=$(grep -rh "^id: " "$ROOT_DIR/disciplines" "$ROOT_DIR/techniques" "$ROOT_DIR/meta" 2>/dev/null \
  | sed 's/^id: //' | sort)

TOTAL_IDS=$(echo "$IDS" | wc -l | tr -d ' ')
UNIQUE_IDS=$(echo "$IDS" | sort -u | wc -l | tr -d ' ')

if [[ "$TOTAL_IDS" -eq "$UNIQUE_IDS" ]]; then
  ok "IDs únicos: $UNIQUE_IDS IDs sin colisiones"
else
  DUPLICATES=$((TOTAL_IDS - UNIQUE_IDS))
  warn "$DUPLICATES IDs duplicados detectados"
  if [[ "$QUIET" == false ]]; then
    echo "$IDS" | sort | uniq -d | while read -r dup; do
      echo "    Duplicado: $dup"
    done
  fi
fi

# ─── Resumen ─────────────────────────────────────────────────────────────────

section "Resumen de Validación"

if [[ "$ERRORS" -eq 0 && "$WARNINGS" -eq 0 ]]; then
  log "\n${GREEN}${BOLD}✓ Sistema válido — sin errores ni advertencias${RESET}"
elif [[ "$ERRORS" -eq 0 ]]; then
  log "\n${YELLOW}${BOLD}⚠ Sistema válido con $WARNINGS advertencia(s)${RESET}"
else
  log "\n${RED}${BOLD}✗ Sistema inválido: $ERRORS error(es), $WARNINGS advertencia(s)${RESET}"
fi

info "Errores: $ERRORS | Advertencias: $WARNINGS"

# Generar reporte si se solicitó
if [[ "$REPORT" == true ]]; then
  {
    echo "# Reporte de Validación del Sistema"
    echo "Fecha: $(date -u +"%Y-%m-%dT%H:%M:%SZ")"
    echo ""
    echo "## Resumen"
    echo "- Errores: $ERRORS"
    echo "- Advertencias: $WARNINGS"
    echo ""
    echo "## Inventario"
    echo "- Roles: $ROLE_COUNT"
    echo "- Técnicas: $TECHNIQUE_COUNT"
    echo "- Adaptadores: $ADAPTER_COUNT"
    echo "- Knowledge packs: $KNOWLEDGE_COUNT"
    echo "- Modifiers: $MODIFIER_COUNT"
    echo "- Chains: $CHAIN_COUNT"
    echo "- Runtimes: $RUNTIME_COUNT"
    echo "- Patterns: $PATTERN_COUNT"
    echo "- Almas: $ALMA_COUNT"
  } > "$REPORT_FILE"
  info "Reporte guardado en $REPORT_FILE"
fi

# Exit code refleja el estado
[[ "$ERRORS" -eq 0 ]]
