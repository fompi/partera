#!/usr/bin/env bash
# compose.sh — Compone un prompt concatenando piezas del sistema modular
# Uso: DISC=<disc> ./compose.sh <adapter> <rol>
#      ./compose.sh --alma <alma> <adapter> [--clipboard]
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

usage() {
  cat <<'USAGE'
Compone un prompt concatenando: base + disciplina + adaptador + rol [+ extensiones].

  DISC=<disciplina> ./compose.sh <adapter> <rol> [--clipboard]
  DISC=<disciplina> EXT="<ext1> <ext2>" ./compose.sh <adapter> <rol>
  DISC=<disciplina> RUNTIME=<runtime> ./compose.sh <adapter> <rol>

  Almas (composiciones declarativas):
    ./compose.sh --alma v02/security-deep python
    ./compose.sh --alma engineering/security-fintech bash --clipboard

  Ejemplos:
    DISC=engineering ./compose.sh python audit/0001_security/_index
    DISC=engineering EXT="techniques/security/injection-analysis" ./compose.sh python audit/0001_security/_index
    DISC=engineering RUNTIME=claude ./compose.sh python generate/0002_implementer/_index
    DISC=content ./compose.sh technical generate/0001_doc-writer/_index

  Meta-prompts (sin DISC):
    ./compose.sh --meta improve_prompt [--clipboard]

Flags:
  --alma <name>     Usa un alma (composición declarativa YAML) en vez de DISC+ROLE
  --clipboard       Copia al portapapeles en vez de imprimir a stdout
  --runtime <name>  Añade instrucciones del runtime
                    Runtimes: claude|openai|gemini|ollama|crewai|langchain|autogen
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
CLIPBOARD=""
RUNTIME="${RUNTIME:-}"
ALMA_NAME=""
INJECT_BEFORE="${INJECT_BEFORE:-}"
INJECT_AFTER="${INJECT_AFTER:-}"
NEW_ARGS=()
_next_is_runtime=0
_next_is_alma=0
for arg in "$@"; do
  if [[ $_next_is_runtime -eq 1 ]]; then
    RUNTIME="$arg"
    _next_is_runtime=0
    continue
  fi
  if [[ $_next_is_alma -eq 1 ]]; then
    ALMA_NAME="$arg"
    _next_is_alma=0
    continue
  fi
  case "$arg" in
    --clipboard) CLIPBOARD="--clipboard" ;;
    --runtime)   _next_is_runtime=1 ;;
    --runtime=*) RUNTIME="${arg#--runtime=}" ;;
    --alma)      _next_is_alma=1 ;;
    --alma=*)    ALMA_NAME="${arg#--alma=}" ;;
    *)           NEW_ARGS+=("$arg") ;;
  esac
done
set -- "${NEW_ARGS[@]:-}"

# --- Resolver alma si se proporcionó ---
if [[ -n "$ALMA_NAME" ]]; then
  if [[ $# -lt 1 ]]; then
    echo "Error: adapter requerido después de --alma. Ej: ./compose.sh --alma v02/security-deep python" >&2
    usage
  fi

  RESOLVE_SCRIPT="$SCRIPT_DIR/scripts/resolve_alma.sh"
  if [[ ! -x "$RESOLVE_SCRIPT" ]]; then
    echo "Error: scripts/resolve_alma.sh no encontrado o no ejecutable" >&2
    exit 1
  fi

  eval "$("$RESOLVE_SCRIPT" "$ALMA_NAME")"

  ADAPTER="$1"
  shift
  # DISC, ROLE, EXT, RUNTIME, INJECT_BEFORE, INJECT_AFTER ya están en el entorno
fi

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

# Si --alma ya resolvió ADAPTER y ROLE, saltar asignación manual
if [[ -z "$ALMA_NAME" ]]; then
  [[ $# -lt 2 ]] && usage
  ADAPTER="$1"
  ROLE="$2"
fi

# --- Validar DISC ---
DISC="${DISC:-}"
if [[ -z "$DISC" ]]; then
  echo "Error: DISC (disciplina) requerido. Ej: DISC=engineering ./compose.sh python audit/0001_security/_index" >&2
  usage
fi

# Validar que la disciplina existe
disc_dir="$SCRIPT_DIR/layers/02_disciplines/$DISC"
if [[ ! -d "$disc_dir" ]]; then
  echo "Error: disciplina '$DISC' no encontrada en layers/02_disciplines/" >&2
  echo "Disciplinas disponibles:" >&2
  ls "$SCRIPT_DIR/layers/02_disciplines/" >&2
  exit 1
fi

# Base universal (modo slave)
base_file="$SCRIPT_DIR/layers/01_modes/slave.md"
if [[ ! -f "$base_file" ]]; then
  echo "Error: no existe layers/01_modes/slave.md" >&2
  exit 1
fi

# Base de la disciplina (opcional)
disc_base_file="$disc_dir/_base.md"

# Adaptador de la disciplina
adapter_file="$disc_dir/03_adapters/${ADAPTER}.md"
if [[ ! -f "$adapter_file" ]]; then
  echo "Error: adaptador '$ADAPTER' no encontrado en layers/02_disciplines/$DISC/03_adapters/" >&2
  echo "Adaptadores disponibles:" >&2
  ls "$disc_dir/03_adapters/" 2>/dev/null | grep '\.md$' | sed 's/\.md$//' || echo "  (ninguno)" >&2
  exit 1
fi

# Rol de la disciplina
role_file="$disc_dir/06_roles/${ROLE}"
[[ "$role_file" != *.md ]] && role_file="${role_file}.md"
if [[ ! -f "$role_file" ]]; then
  echo "Error: rol '$ROLE' no encontrado en layers/02_disciplines/$DISC/06_roles/" >&2
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

# Extensiones (EXT="path1 path2 ...") — rutas lógicas; se resuelven a layers/
# Orden de composición (ver docs/chains-and-patterns.md):
#   base → discipline_base → adapter → [patterns] → [knowledge] → role → [techniques] → [modifiers] → [sources] → [protocols] → [capabilities] → [runtime]
resolve_ext_file() {
  local ext_path="$1"
  local f
  case "$ext_path" in
    patterns/*)      f="$SCRIPT_DIR/layers/04_patterns/${ext_path#patterns/}" ;;
    knowledge/*)     f="$SCRIPT_DIR/layers/05_knowledge/${ext_path#knowledge/}" ;;
    techniques/*)    f="$SCRIPT_DIR/layers/07_techniques/${ext_path#techniques/}" ;;
    modifiers/*)     f="$SCRIPT_DIR/layers/08_modifiers/${ext_path#modifiers/}" ;;
    sources/*)       f="$SCRIPT_DIR/layers/09_sources/${ext_path#sources/}" ;;
    protocols/*)     f="$SCRIPT_DIR/layers/10_protocols/${ext_path#protocols/}" ;;
    capabilities/*)  f="$SCRIPT_DIR/layers/11_capabilities/${ext_path#capabilities/}" ;;
    *)               f="$SCRIPT_DIR/layers/07_techniques/${ext_path}" ;;
  esac
  [[ "$f" != *.md ]] && f="${f}.md"
  echo "$f"
}
EXT="${EXT:-}"
pattern_files=()
knowledge_files=()
technique_files=()
modifier_files=()
source_files=()
protocol_files=()
capability_files=()
if [[ -n "$EXT" ]]; then
  for ext_path in $EXT; do
    ext_file=$(resolve_ext_file "$ext_path")
    if [[ ! -f "$ext_file" ]]; then
      echo "Error: extensión '$ext_path' no encontrada ($ext_file)" >&2
      exit 1
    fi
    case "$ext_path" in
      patterns/*)      pattern_files+=("$ext_file") ;;
      knowledge/*)     knowledge_files+=("$ext_file") ;;
      modifiers/*)     modifier_files+=("$ext_file") ;;
      sources/*)       source_files+=("$ext_file") ;;
      protocols/*)     protocol_files+=("$ext_file") ;;
      capabilities/*)  capability_files+=("$ext_file") ;;
      *)               technique_files+=("$ext_file") ;;
    esac
  done
fi

# --- Runtime (opcional) ---
runtime_file=""
if [[ -n "$RUNTIME" ]]; then
  runtime_file="$SCRIPT_DIR/layers/12_runtimes/${RUNTIME}.md"
  if [[ ! -f "$runtime_file" ]]; then
    echo "Error: runtime '$RUNTIME' no encontrado ($runtime_file)" >&2
    echo "Runtimes disponibles:" >&2
    ls "$SCRIPT_DIR/layers/12_runtimes/" 2>/dev/null | grep '\.md$' | sed 's/\.md$//' | sed 's/^/  /' >&2
    exit 1
  fi
  # Verificar compatibilidad de capabilities (advertencia si role requiere lo que runtime no soporta)
  role_caps=$(get_frontmatter_field "$role_file" "capabilities_required" 2>/dev/null | tr -d '[]"' | tr ',' ' ' || true)
  runtime_caps=$(get_frontmatter_field "$runtime_file" "supports_capabilities" 2>/dev/null | tr -d '[]"' | tr ',' ' ' || true)
  if [[ -n "$role_caps" ]] && [[ "$runtime_caps" != *"all"* ]]; then
    for cap in $role_caps; do
      cap=$(echo "$cap" | tr -d ' ')
      if [[ -n "$cap" ]] && [[ "$runtime_caps" != *"$cap"* ]]; then
        echo "Warning: capability '$cap' requerida por el rol no es nativa en runtime '$RUNTIME' (requiere wrapper)" >&2
      fi
    done
  fi
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
  for ext_file in "${pattern_files[@]+"${pattern_files[@]}"}"; do
    printf '\n---\n\n'
    cat "$ext_file"
  done
  for ext_file in "${knowledge_files[@]+"${knowledge_files[@]}"}"; do
    printf '\n---\n\n'
    cat "$ext_file"
  done
  if [[ -n "${INJECT_BEFORE:-}" ]]; then
    printf '\n---\n\n'
    printf '%s\n' "$INJECT_BEFORE"
  fi
  printf '\n---\n\n'
  cat "$role_file"
  if [[ -n "${INJECT_AFTER:-}" ]]; then
    printf '\n---\n\n'
    printf '%s\n' "$INJECT_AFTER"
  fi
  for ext_file in "${technique_files[@]+"${technique_files[@]}"}"; do
    printf '\n---\n\n'
    cat "$ext_file"
  done
  for ext_file in "${modifier_files[@]+"${modifier_files[@]}"}"; do
    printf '\n---\n\n'
    cat "$ext_file"
  done
  for ext_file in "${source_files[@]+"${source_files[@]}"}"; do
    printf '\n---\n\n'
    cat "$ext_file"
  done
  for ext_file in "${protocol_files[@]+"${protocol_files[@]}"}"; do
    printf '\n---\n\n'
    cat "$ext_file"
  done
  for ext_file in "${capability_files[@]+"${capability_files[@]}"}"; do
    printf '\n---\n\n'
    cat "$ext_file"
  done
  if [[ -n "$runtime_file" ]]; then
    printf '\n---\n\n'
    cat "$runtime_file"
  fi
} | {
  output=$(cat)
  if [[ -n "$CLIPBOARD" ]]; then
    copy_to_clipboard "$output"
  else
    printf '%s\n' "$output"
  fi
}
