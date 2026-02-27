#!/usr/bin/env bash
# run_chain.sh — Compone y muestra los prompts de un chain paso a paso
# Uso: ./scripts/run_chain.sh <chain-name> [adapter]
# Ejemplo: ./scripts/run_chain.sh nl-to-code python
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
COMPOSE="$SCRIPT_DIR/compose.sh"

usage() {
  cat <<'USAGE'
Compone y muestra los prompts de un chain paso a paso.

Uso:
  ./scripts/run_chain.sh <chain> [adapter]

Argumentos:
  chain    — nombre del chain (sin extensión), ej: nl-to-code
  adapter  — adaptador a usar en compose (opcional, ej: python)

Ejemplos:
  ./scripts/run_chain.sh nl-to-code python
  ./scripts/run_chain.sh full-audit python
  ./scripts/run_chain.sh idea-to-project saas
  ./scripts/run_chain.sh content-pipeline marketing

El script leerá chains/<chain>.chain, extraerá los steps del front-matter
y mostrará cada prompt compuesto con un header descriptivo.
USAGE
  exit 1
}

[[ $# -lt 1 ]] && usage

CHAIN_NAME="$1"
ADAPTER="${2:-}"
CHAIN_FILE="$SCRIPT_DIR/chains/${CHAIN_NAME}.chain"

if [[ ! -f "$CHAIN_FILE" ]]; then
  echo "Error: chain '$CHAIN_NAME' no encontrado ($CHAIN_FILE)" >&2
  echo "Chains disponibles:" >&2
  for f in "$SCRIPT_DIR/chains/"*.chain; do
    echo "  $(basename "$f" .chain)"
  done
  exit 1
fi

# Extraer metadatos del front-matter
get_field() {
  local file="$1" field="$2"
  awk '/^---$/{found++; next} found==1{print} found==2{exit}' "$file" \
    | grep "^${field}:" | head -1 | sed 's/^[^:]*: *//' | tr -d '"'
}

CHAIN_DISPLAY_NAME=$(get_field "$CHAIN_FILE" "name")
CHAIN_DESC=$(get_field "$CHAIN_FILE" "description")
CHAIN_EST_TOKENS=$(get_field "$CHAIN_FILE" "estimated_tokens")

# Parsear steps del front-matter YAML
# Extraemos: role, name, input_description, output_description
parse_steps() {
  local file="$1"
  awk '/^---$/{found++; next} found==2{exit} found==1{print}' "$file" \
    | awk '
      /^steps:/ { in_steps=1; next }
      in_steps && /^[a-z]/ { in_steps=0 }
      in_steps && /^  - role:/ {
        if (role != "") {
          print role "|" name "|" input_from "|" input_desc "|" output_to "|" output_desc
        }
        role=$0; sub(/.*role: */, "", role); gsub(/"/, "", role)
        name=""; input_from=""; input_desc=""; output_to=""; output_desc=""
      }
      in_steps && /^    name:/ { name=$0; sub(/.*name: */, "", name); gsub(/"/, "", name) }
      in_steps && /^    input_from:/ { input_from=$0; sub(/.*input_from: */, "", input_from); gsub(/"/, "", input_from) }
      in_steps && /^    input_description:/ { input_desc=$0; sub(/.*input_description: */, "", input_desc); gsub(/"/, "", input_desc) }
      in_steps && /^    output_to:/ { output_to=$0; sub(/.*output_to: */, "", output_to); gsub(/"/, "", output_to) }
      in_steps && /^    output_description:/ { output_desc=$0; sub(/.*output_description: */, "", output_desc); gsub(/"/, "", output_desc) }
      END {
        if (role != "") {
          print role "|" name "|" input_from "|" input_desc "|" output_to "|" output_desc
        }
      }
    '
}

# Derivar DISC y role_path de un role_id como "engineering.audit.01_security"
# Devuelve: DISC|role_path
# role_path = "audit/01_security/_index"
resolve_role() {
  local role_id="$1"
  local disc role_path subpath

  disc=$(echo "$role_id" | cut -d. -f1)
  subpath=$(echo "$role_id" | cut -d. -f2-)
  # Convertir puntos restantes en /
  role_path=$(echo "$subpath" | tr '.' '/')
  # Los roles viven en <verb>/<name>/_index — siempre añadir /_index
  role_path="${role_path}/_index"

  echo "${disc}|${role_path}"
}

separator() {
  printf '\n%s\n\n' "$(printf '=%.0s' {1..80})"
}

# Cabecera del chain
printf '\n'
printf '╔══════════════════════════════════════════════════════════════════════════════╗\n'
printf '║  CHAIN: %-68s ║\n' "$CHAIN_DISPLAY_NAME"
printf '╠══════════════════════════════════════════════════════════════════════════════╣\n'
printf '║  %s\n' "$CHAIN_DESC"
printf '║  Tokens estimados: %s\n' "$CHAIN_EST_TOKENS"
[[ -n "$ADAPTER" ]] && printf '║  Adaptador: %s\n' "$ADAPTER"
printf '╚══════════════════════════════════════════════════════════════════════════════╝\n'
printf '\n'

# Procesar cada step
step_num=0
while IFS='|' read -r role name input_from input_desc output_to output_desc; do
  step_num=$((step_num + 1))

  printf '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n'
  printf 'PASO %d: %s\n' "$step_num" "${name:-$role}"
  printf '  Rol:     %s\n' "$role"
  printf '  Recibe:  %s\n' "${input_desc:-$input_from}"
  printf '  Produce: %s\n' "${output_desc:-$output_to}"
  printf '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n'
  printf '\n'

  # Componer el prompt para este step
  resolved=$(resolve_role "$role")
  step_disc=$(echo "$resolved" | cut -d'|' -f1)
  step_role=$(echo "$resolved" | cut -d'|' -f2)

  # Intentar compose si el rol existe; mostrar aviso si no
  role_file="$SCRIPT_DIR/disciplines/$step_disc/roles/${step_role}.md"
  if [[ -f "$role_file" ]]; then
    if [[ -n "$ADAPTER" ]]; then
      DISC="$step_disc" "$COMPOSE" "$ADAPTER" "$step_role" 2>/dev/null || {
        echo "[AVISO: No se pudo componer el prompt para DISC=$step_disc ADAPTER=$ADAPTER ROLE=$step_role]"
        echo "  Verifica que el adaptador '$ADAPTER' existe en disciplines/$step_disc/adapters/"
      }
    else
      echo "[AVISO: ADAPTER no especificado — no se puede componer el prompt]"
      echo "  Usa: ./scripts/run_chain.sh $CHAIN_NAME <adapter>"
    fi
  else
    printf '[ROL NO IMPLEMENTADO: %s]\n' "$role_file"
    printf '  Este rol aún no existe en la disciplina %s.\n' "$step_disc"
    printf '  Cuando exista, se compondrá automáticamente.\n'
  fi

  printf '\n'

done < <(parse_steps "$CHAIN_FILE")

printf '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n'
printf 'FIN DEL CHAIN: %s (%d pasos)\n' "$CHAIN_DISPLAY_NAME" "$step_num"
printf '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n'
