#!/usr/bin/env bash
# compose.sh — Compone un prompt concatenando piezas del sistema de auditoría
# Soporta modo legacy (estructura actual) y modo nuevo (disciplines/).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

usage() {
  cat <<'USAGE'
Compone un prompt concatenando: base + adaptador + rol [+ extensiones].

=== Modo legacy ===
  ./compose.sh <lang> <rol> [--clipboard]
  ./compose.sh --meta <meta-prompt> [--clipboard]

  Ejemplos:
    ./compose.sh python 01_security/_index
    ./compose.sh bash   03_architecture/_index --clipboard
    ./compose.sh --meta improve_prompt

=== Modo nuevo (disciplines/) ===
  DISC=<disciplina> ./compose.sh <adapter> <rol> [--clipboard]
  DISC=<disciplina> EXT="<ext1> <ext2>" ./compose.sh <adapter> <rol>

  Ejemplos:
    DISC=engineering ./compose.sh python audit/01_security/_index
    DISC=engineering EXT="techniques/security/injection-analysis" ./compose.sh python audit/01_security/_index

=== Flags ===
  --legacy    Fuerza modo legacy aunque DISC esté definido
  --clipboard Copia al portapapeles en vez de imprimir a stdout

Lenguajes/adaptadores:
  Legacy:  ficheros en lang/ (sin extensión)
  Nuevo:   ficheros en disciplines/<DISC>/adapters/ (sin extensión)
USAGE
  exit 1
}

copy_to_clipboard() {
  if command -v pbcopy &>/dev/null; then
    printf '%s' "$1" | pbcopy
  elif command -v xclip &>/dev/null; then
    printf '%s' "$1" | xclip -selection clipboard
  elif command -v xsel &>/dev/null; then
    printf '%s' "$1" | xsel --clipboard --input
  elif command -v clip.exe &>/dev/null; then
    printf '%s' "$1" | clip.exe
  else
    echo "Error: no se encontró utilidad de portapapeles (pbcopy/xclip/xsel/clip.exe)" >&2
    exit 1
  fi
  lines=$(printf '%s' "$1" | wc -l | tr -d ' ')
  echo "Copiado al portapapeles ($lines líneas)"
}

# Extrae el valor de un campo del front-matter de un archivo .md
get_frontmatter_field() {
  local file="$1" field="$2"
  awk '/^---$/{found++; next} found==1{print} found==2{exit}' "$file" \
    | grep "^${field}:" | head -1 | sed 's/^[^:]*: *//'
}

[[ $# -lt 1 ]] && usage

# --- Detectar flags globales ---
FORCE_LEGACY=0
CLIPBOARD=""
NEW_ARGS=()
for arg in "$@"; do
  case "$arg" in
    --legacy)    FORCE_LEGACY=1 ;;
    --clipboard) CLIPBOARD="--clipboard" ;;
    *)           NEW_ARGS+=("$arg") ;;
  esac
done
set -- "${NEW_ARGS[@]:-}"

# --- Meta-prompts (invariante de modo) ---
if [[ "${1:-}" == "--meta" ]]; then
  [[ $# -lt 2 ]] && usage

  meta_prompt="$2"
  base_file="$SCRIPT_DIR/meta/_base_meta.md"
  meta_file="$SCRIPT_DIR/meta/${meta_prompt}"
  [[ "$meta_file" != *.md ]] && meta_file="${meta_file}.md"

  for f in "$base_file" "$meta_file"; do
    if [[ ! -f "$f" ]]; then
      echo "Error: no existe $f" >&2
      exit 1
    fi
  done

  output=$(cat "$base_file" <(printf '\n---\n\n') "$meta_file")

  if [[ -n "$CLIPBOARD" ]]; then
    copy_to_clipboard "$output"
  else
    printf '%s\n' "$output"
  fi
  exit 0
fi

[[ $# -lt 2 ]] && usage

ADAPTER="$1"
ROLE="$2"

# --- Determinar modo ---
DISC="${DISC:-}"
if [[ $FORCE_LEGACY -eq 1 ]] || [[ -z "$DISC" ]]; then
  MODE="legacy"
else
  MODE="new"
fi

# ============================================================
# MODO LEGACY
# ============================================================
if [[ "$MODE" == "legacy" ]]; then
  lang_file="$SCRIPT_DIR/lang/${ADAPTER}.md"
  role_file="$SCRIPT_DIR/${ROLE}"
  [[ "$role_file" != *.md ]] && role_file="${role_file}.md"
  base_file="$SCRIPT_DIR/_base_audit.md"

  for f in "$base_file" "$lang_file" "$role_file"; do
    if [[ ! -f "$f" ]]; then
      echo "Error: no existe $f" >&2
      exit 1
    fi
  done

  output=$(cat "$base_file" <(printf '\n---\n\n') "$lang_file" <(printf '\n---\n\n') "$role_file")

  if [[ -n "$CLIPBOARD" ]]; then
    copy_to_clipboard "$output"
  else
    printf '%s\n' "$output"
  fi
  exit 0
fi

# ============================================================
# MODO NUEVO (disciplines/)
# ============================================================

# Validar que la disciplina existe
disc_dir="$SCRIPT_DIR/disciplines/$DISC"
if [[ ! -d "$disc_dir" ]]; then
  echo "Error: disciplina '$DISC' no encontrada en disciplines/" >&2
  echo "Disciplinas disponibles:" >&2
  ls "$SCRIPT_DIR/disciplines/" >&2
  exit 1
fi

# Base universal
base_file="$SCRIPT_DIR/_base.md"
if [[ ! -f "$base_file" ]]; then
  # Fallback a _base_audit.md si _base.md no existe aún
  base_file="$SCRIPT_DIR/_base_audit.md"
fi

# Base de la disciplina (opcional)
disc_base_file="$disc_dir/_base.md"

# Adaptador de la disciplina
adapter_file="$disc_dir/adapters/${ADAPTER}.md"
if [[ ! -f "$adapter_file" ]]; then
  echo "Error: adaptador '$ADAPTER' no encontrado en disciplines/$DISC/adapters/" >&2
  echo "Adaptadores disponibles:" >&2
  ls "$disc_dir/adapters/" 2>/dev/null | grep '\.md$' | sed 's/\.md$//' || echo "  (ninguno)" >&2
  exit 1
fi

# Rol de la disciplina
role_file="$disc_dir/roles/${ROLE}"
[[ "$role_file" != *.md ]] && role_file="${role_file}.md"
if [[ ! -f "$role_file" ]]; then
  echo "Error: rol '$ROLE' no encontrado en disciplines/$DISC/roles/" >&2
  exit 1
fi

# Validar que adaptador y rol pertenecen a la misma disciplina
adapter_disc=$(get_frontmatter_field "$adapter_file" "discipline" 2>/dev/null || echo "")
role_disc=$(get_frontmatter_field "$role_file" "discipline" 2>/dev/null || echo "")

if [[ -n "$adapter_disc" ]] && [[ -n "$role_disc" ]] && [[ "$adapter_disc" != "$role_disc" ]]; then
  echo "Error: disciplina del adaptador ('$adapter_disc') != disciplina del rol ('$role_disc')" >&2
  exit 1
fi

# Construir lista de archivos a concatenar
parts=()
parts+=("$base_file")
[[ -f "$disc_base_file" ]] && parts+=(/dev/stdin <(printf '\n---\n\n') "$disc_base_file")
parts+=(/dev/stdin <(printf '\n---\n\n') "$adapter_file")
parts+=(/dev/stdin <(printf '\n---\n\n') "$role_file")

# Extensiones (EXT="path1 path2 ...")
EXT="${EXT:-}"
ext_files=()
if [[ -n "$EXT" ]]; then
  for ext_path in $EXT; do
    ext_file="$SCRIPT_DIR/${ext_path}"
    [[ "$ext_file" != *.md ]] && ext_file="${ext_file}.md"
    if [[ ! -f "$ext_file" ]]; then
      echo "Error: extensión '$ext_path' no encontrada ($ext_file)" >&2
      exit 1
    fi
    ext_files+=("$ext_file")
  done
fi

# Concatenar todo
{
  cat "$base_file"
  if [[ -f "$disc_base_file" ]]; then
    printf '\n---\n\n'
    cat "$disc_base_file"
  fi
  printf '\n---\n\n'
  cat "$adapter_file"
  printf '\n---\n\n'
  cat "$role_file"
  for ext_file in "${ext_files[@]:-}"; do
    printf '\n---\n\n'
    cat "$ext_file"
  done
} | {
  output=$(cat)
  if [[ -n "$CLIPBOARD" ]]; then
    copy_to_clipboard "$output"
  else
    printf '%s\n' "$output"
  fi
}
