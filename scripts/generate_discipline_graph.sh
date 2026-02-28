#!/usr/bin/env bash
# generate_discipline_graph.sh — Genera un diagrama Mermaid de relaciones de una disciplina
# Uso: ./scripts/generate_discipline_graph.sh <discipline> [> output.mermaid]
# Ejemplo: ./scripts/generate_discipline_graph.sh engineering > docs/engineering-graph.mermaid
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"

DISCIPLINE="${1:-}"
if [[ -z "$DISCIPLINE" ]]; then
  echo "Uso: $0 <discipline>" >&2
  echo "Ejemplo: $0 engineering > docs/engineering-graph.mermaid" >&2
  exit 1
fi

DISC_DIR="$REPO_DIR/layers/02_disciplines/$DISCIPLINE"
if [[ ! -d "$DISC_DIR" ]]; then
  echo "ERROR: Disciplina '$DISCIPLINE' no encontrada en $DISC_DIR" >&2
  exit 1
fi

# Extrae el valor de un campo del front-matter
get_field() {
  local file="$1" field="$2"
  awk '/^---$/{found++; next} found==1{print} found==2{exit}' "$file" \
    | grep "^${field}:" | head -1 | sed 's/^[^:]*: *//'
}

# Extrae lista de connects_to desde front-matter (multiline o inline)
get_connects_to() {
  local file="$1"
  # Formato multiline:  - id.foo
  awk '/^---$/{found++; next} found==1{print} found==2{exit}' "$file" \
    | awk '/^connects_to:/{found=1; next} found && /^  - /{print $2; next} found && /^[^ ]/{exit}'
  # Formato inline: [id.foo, id.bar]
  awk '/^---$/{found++; next} found==1{print} found==2{exit}' "$file" \
    | grep "^connects_to:" | head -1 | sed 's/^[^:]*: *//' \
    | tr -d '[]' | tr ',' '\n' | tr -d ' ' | grep -v '^$' | grep '\.' || true
}

# Devuelve el color de relleno según el task_type
task_type_color() {
  case "$1" in
    audit)    echo "#dbeafe";;  # azul claro
    generate) echo "#dcfce7";;  # verde claro
    plan)     echo "#fef9c3";;  # amarillo claro
    *)        echo "#f3f4f6";;  # gris
  esac
}

# Convierte un id a un nodo válido para Mermaid (reemplaza puntos y _ por guiones)
safe_node_id() {
  echo "$1" | tr '.' '_' | tr '-' '_'
}

# ─── Colección de datos ───────────────────────────────────────────────────────
declare -a ROLE_IDS=()
declare -a ROLE_NAMES=()
declare -a ROLE_TASK_TYPES=()
declare -a ROLE_FILES=()
declare -a EDGE_SRCS=()
declare -a EDGE_DSTS=()

idx=0
while IFS= read -r -d '' file; do
  if ! head -1 "$file" | grep -q '^---$'; then
    continue
  fi

  role_id=$(get_field "$file" "id")
  role_name=$(get_field "$file" "name" | tr -d '"')
  task_type=$(get_field "$file" "task_type")

  [[ -z "$role_id" ]] && continue

  ROLE_IDS+=("$role_id")
  ROLE_NAMES+=("$role_name")
  ROLE_TASK_TYPES+=("$task_type")
  ROLE_FILES+=("$file")

  # Recopilar edges desde connects_to
  while IFS= read -r target; do
    [[ -z "$target" ]] && continue
    EDGE_SRCS+=("$role_id")
    EDGE_DSTS+=("$target")
  done < <(get_connects_to "$file")

  idx=$((idx+1))
done < <(find "$DISC_DIR/06_roles" -name "_index.md" -print0 2>/dev/null | sort -z)

# ─── Generar Mermaid ──────────────────────────────────────────────────────────
echo "graph LR"
echo ""
echo "    %% Disciplina: $DISCIPLINE"
echo "    %% Generado por scripts/generate_discipline_graph.sh"
echo "    %% task_type: audit=azul | generate=verde | plan=amarillo"
echo ""

# Subgraphs por task_type
declare -a TASK_TYPES_SEEN=()

for tt in audit plan generate; do
  nodes_in_tt=""
  for i in "${!ROLE_IDS[@]}"; do
    [[ "${ROLE_TASK_TYPES[$i]}" != "$tt" ]] && continue
    node_id=$(safe_node_id "${ROLE_IDS[$i]}")
    role_name="${ROLE_NAMES[$i]}"
    nodes_in_tt="$nodes_in_tt    $node_id"
  done
  [[ -z "$nodes_in_tt" ]] && continue

  echo "    subgraph $tt"
  for i in "${!ROLE_IDS[@]}"; do
    [[ "${ROLE_TASK_TYPES[$i]}" != "$tt" ]] && continue
    node_id=$(safe_node_id "${ROLE_IDS[$i]}")
    role_name="${ROLE_NAMES[$i]}"
    echo "        $node_id[\"$role_name\"]"
  done
  echo "    end"
  echo ""
done

# Edges
if [[ ${#EDGE_SRCS[@]} -gt 0 ]]; then
  echo "    %% Conexiones entre roles"
  for i in "${!EDGE_SRCS[@]}"; do
    src=$(safe_node_id "${EDGE_SRCS[$i]}")
    dst=$(safe_node_id "${EDGE_DSTS[$i]}")
    echo "    $src --> $dst"
  done
  echo ""
fi

# Estilos por task_type
echo "    %% Estilos"
for i in "${!ROLE_IDS[@]}"; do
  node_id=$(safe_node_id "${ROLE_IDS[$i]}")
  tt="${ROLE_TASK_TYPES[$i]}"
  color=$(task_type_color "$tt")
  echo "    style $node_id fill:$color,stroke:#6b7280,color:#111827"
done
