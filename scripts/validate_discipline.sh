#!/usr/bin/env bash
# validate_discipline.sh — Valida la integridad de una disciplina completa
# Uso: ./scripts/validate_discipline.sh <discipline>
# Ejemplo: ./scripts/validate_discipline.sh engineering
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

DISCIPLINE="${1:-}"
if [[ -z "$DISCIPLINE" ]]; then
  echo "Uso: $0 <discipline>" >&2
  echo "Ejemplo: $0 engineering" >&2
  exit 1
fi

DISC_DIR="$REPO_DIR/layers/02_disciplines/$DISCIPLINE"
if [[ ! -d "$DISC_DIR" ]]; then
  echo "ERROR: Disciplina '$DISCIPLINE' no encontrada en $DISC_DIR" >&2
  exit 1
fi

RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RESET='\033[0m'

errors=0
warnings=0

log_error() { printf "${RED}ERROR${RESET}  %s\n" "$1" >&2; errors=$((errors+1)); }
log_warn()  { printf "${YELLOW}WARN${RESET}   %s\n" "$1"; warnings=$((warnings+1)); }
log_ok()    { printf "${GREEN}OK${RESET}     %s\n" "$1"; }
log_info()  { printf "${BLUE}INFO${RESET}   %s\n" "$1"; }

# Extrae el valor de un campo del front-matter
get_field() {
  local file="$1" field="$2"
  awk '/^---$/{found++; next} found==1{print} found==2{exit}' "$file" \
    | grep "^${field}:" | head -1 | sed 's/^[^:]*: *//'
}

# Extrae valores de lista YAML (formato: [a, b, c] o multiline con -)
get_list_field() {
  local file="$1" field="$2"
  awk '/^---$/{found++; next} found==1{print} found==2{exit}' "$file" \
    | awk "/^${field}:/{found=1; next} found && /^  - /{print \$2; next} found && /^[^ ]/{exit}" \
    | cat
  # También manejar formato inline [a, b, c]
  awk '/^---$/{found++; next} found==1{print} found==2{exit}' "$file" \
    | grep "^${field}:" | head -1 | sed 's/^[^:]*: *//' \
    | tr -d '[]' | tr ',' '\n' | tr -d ' ' | grep -v '^$' || true
}

has_frontmatter() {
  head -1 "$1" | grep -q '^---$'
}

# Recopila todos los IDs de roles de la disciplina
declare -a ALL_ROLE_IDS=()
collect_role_ids() {
  while IFS= read -r -d '' file; do
    if has_frontmatter "$file"; then
      local id
      id=$(get_field "$file" "id")
      if [[ -n "$id" ]]; then
        ALL_ROLE_IDS+=("$id")
      fi
    fi
  done < <(find "$DISC_DIR/06_roles" -name "_index.md" -print0 2>/dev/null | sort -z)
}

id_exists() {
  local target="$1"
  for id in "${ALL_ROLE_IDS[@]}"; do
    [[ "$id" == "$target" ]] && return 0
  done
  return 1
}

# ─── 1. Verificar _base.md ───────────────────────────────────────────────────
echo ""
log_info "Verificando estructura de disciplina: $DISCIPLINE"
echo "────────────────────────────────────────────────────────────"

if [[ -f "$DISC_DIR/_base.md" ]]; then
  log_ok "_base.md existe"
else
  log_error "_base.md no encontrado en $DISC_DIR"
fi

# ─── 2. Verificar adaptadores ────────────────────────────────────────────────
echo ""
log_info "Verificando adaptadores..."
adapter_count=0
if [[ -d "$DISC_DIR/03_adapters" ]]; then
  while IFS= read -r -d '' file; do
    rel="${file#$REPO_DIR/}"
    adapter_count=$((adapter_count+1))
    if ! has_frontmatter "$file"; then
      log_error "$rel — sin front-matter"
      continue
    fi
    local_type=$(get_field "$file" "type")
    local_disc=$(get_field "$file" "discipline")
    if [[ "$local_type" != "adapter" ]]; then
      log_warn "$rel — type='$local_type' (esperado: adapter)"
    fi
    if [[ -z "$local_disc" ]]; then
      log_warn "$rel — campo 'discipline' ausente"
    fi
    log_ok "$rel"
  done < <(find "$DISC_DIR/03_adapters" -name "*.md" -not -name "README.md" -print0 2>/dev/null | sort -z)
fi
if [[ $adapter_count -eq 0 ]]; then
  log_warn "No se encontraron adaptadores en $DISC_DIR/03_adapters/"
else
  log_info "$adapter_count adaptador(es) verificado(s)"
fi

# ─── 3. Recopilar IDs de roles ───────────────────────────────────────────────
echo ""
log_info "Recopilando IDs de roles..."
collect_role_ids
log_info "${#ALL_ROLE_IDS[@]} rol(es) encontrado(s)"

# ─── 4. Verificar roles ──────────────────────────────────────────────────────
echo ""
log_info "Verificando roles..."
role_count=0
orphan_count=0

while IFS= read -r -d '' file; do
  rel="${file#$REPO_DIR/}"
  role_count=$((role_count+1))

  if ! has_frontmatter "$file"; then
    log_error "$rel — sin front-matter"
    continue
  fi

  # Campos obligatorios para roles
  for field in id type discipline task_type name version description; do
    val=$(get_field "$file" "$field")
    if [[ -z "$val" ]]; then
      log_error "$rel — campo obligatorio '$field' ausente"
    fi
  done

  role_id=$(get_field "$file" "id")
  task_type=$(get_field "$file" "task_type")

  # Verificar connects_to apuntan a IDs existentes
  while IFS= read -r -d '' connects_file; do
    connects_raw=$(get_field "$connects_file" "connects_to")
    # Extraer IDs individuales del campo multilinea o inline
    connects_ids=$(awk '/^---$/{found++; next} found==1{print} found==2{exit}' "$file" \
      | awk '/^connects_to:/{found=1; next} found && /^  - /{print $2; next} found && /^[^ ]/{exit}' \
      | cat)
    inline_connects=$(get_field "$file" "connects_to" | tr -d '[]' | tr ',' '\n' | tr -d ' ' | grep -v '^$' || true)
    all_connects=$(printf "%s\n%s" "$connects_ids" "$inline_connects" | grep -v '^$' || true)

    while IFS= read -r target_id; do
      [[ -z "$target_id" ]] && continue
      if ! id_exists "$target_id"; then
        log_warn "$rel — connects_to apunta a ID inexistente: '$target_id'"
      fi
    done <<< "$all_connects"
  done < <(echo "$file" | tr '\n' '\0')

  # Detectar roles huérfanos (sin connects_to ni connects_from, excluyendo terminales obvios)
  has_connects_to=$(awk '/^---$/{found++; next} found==1{print} found==2{exit}' "$file" \
    | grep -c "^connects_to:" || true)
  has_connects_from=$(awk '/^---$/{found++; next} found==1{print} found==2{exit}' "$file" \
    | grep -c "^connects_from:" || true)

  connects_to_empty=$(awk '/^---$/{found++; next} found==1{print} found==2{exit}' "$file" \
    | grep "^connects_to:" | grep -c "\[\]" || true)
  connects_from_empty=$(awk '/^---$/{found++; next} found==1{print} found==2{exit}' "$file" \
    | grep "^connects_from:" | grep -c "\[\]" || true)

  if [[ "$connects_to_empty" -gt 0 && "$connects_from_empty" -gt 0 ]]; then
    log_warn "$rel — rol huérfano: connects_to=[] y connects_from=[]"
    orphan_count=$((orphan_count+1))
  fi

  log_ok "$rel (id=$role_id, task_type=$task_type)"

done < <(find "$DISC_DIR/roles" -name "_index.md" -print0 2>/dev/null | sort -z)

log_info "$role_count rol(es) verificado(s), $orphan_count huérfano(s)"

# ─── 5. Verificar referencias a capabilities/protocols/sources ───────────────
echo ""
log_info "Verificando referencias a capabilities, protocols y sources..."
ref_warnings=0

while IFS= read -r -d '' file; do
  rel="${file#$REPO_DIR/}"

  # capabilities_required
  caps_req=$(awk '/^---$/{found++; next} found==1{print} found==2{exit}' "$file" \
    | awk '/^capabilities_required:/{found=1; next} found && /^  - /{print $2; next} found && /^[^ ]/{exit}')
  while IFS= read -r cap; do
    [[ -z "$cap" ]] && continue
    if [[ ! -f "$REPO_DIR/layers/11_capabilities/$cap.md" && ! -d "$REPO_DIR/layers/11_capabilities/$cap" ]]; then
      log_warn "$rel — capabilities_required '$cap' no encontrado en layers/11_capabilities/"
      ref_warnings=$((ref_warnings+1))
    fi
  done <<< "$caps_req"

  # protocols_recommended
  protos=$(awk '/^---$/{found++; next} found==1{print} found==2{exit}' "$file" \
    | awk '/^protocols_recommended:/{found=1; next} found && /^  - /{print $2; next} found && /^[^ ]/{exit}')
  inline_protos=$(get_field "$file" "protocols_recommended" | tr -d '[]' | tr ',' '\n' | tr -d ' ' | grep -v '^$' || true)
  all_protos=$(printf "%s\n%s" "$protos" "$inline_protos" | grep -v '^$' | sort -u || true)
  while IFS= read -r proto; do
    [[ -z "$proto" ]] && continue
    if [[ ! -f "$REPO_DIR/layers/10_protocols/$proto.md" && ! -d "$REPO_DIR/layers/10_protocols/$proto" ]]; then
      log_warn "$rel — protocols_recommended '$proto' no encontrado en layers/10_protocols/"
      ref_warnings=$((ref_warnings+1))
    fi
  done <<< "$all_protos"

done < <(find "$DISC_DIR/06_roles" -name "_index.md" -print0 2>/dev/null | sort -z)

if [[ $ref_warnings -eq 0 ]]; then
  log_ok "Todas las referencias a capabilities/protocols resueltas"
fi

# ─── Resumen ─────────────────────────────────────────────────────────────────
echo ""
echo "════════════════════════════════════════════════════════════"
printf "Disciplina: ${BLUE}%s${RESET}\n" "$DISCIPLINE"
printf "Roles:      %d\n" "$role_count"
printf "Adaptadores: %d\n" "$adapter_count"
printf "Errores:    ${RED}%d${RESET}  |  Advertencias: ${YELLOW}%d${RESET}\n" "$errors" "$warnings"
echo "════════════════════════════════════════════════════════════"

if [[ $errors -gt 0 ]]; then
  printf "${RED}FALLO: %d error(es) en disciplina '%s'${RESET}\n" "$errors" "$DISCIPLINE"
  exit 1
else
  printf "${GREEN}OK: disciplina '%s' válida${RESET}\n" "$DISCIPLINE"
  exit 0
fi
