#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

usage() {
  cat <<'USAGE'
Compone un prompt de auditoría concatenando: base + lang + rol.

Uso:
  ./compose.sh <lenguaje> <rol> [--clipboard]
  ./compose.sh --meta <meta-prompt> [--clipboard]

Ejemplos:
  ./compose.sh python 01_security/_index
  ./compose.sh bash   03_architecture/_index      --clipboard
  ./compose.sh python 01_security/01a_injection_surfaces --clipboard
  ./compose.sh --meta improve_prompt
  ./compose.sh --meta evaluate_coverage            --clipboard

Lenguajes disponibles: los ficheros en lang/ (sin extensión).
Roles disponibles:     00_orchestrator/_index, 01_security/_index, ...
Meta-prompts:          improve_prompt, evaluate_coverage, generate_lang_adapter, generate_role

Con --clipboard copia al portapapeles en vez de imprimir a stdout.
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

[[ $# -lt 1 ]] && usage

if [[ "$1" == "--meta" ]]; then
  [[ $# -lt 2 ]] && usage

  meta_prompt="$2"
  clipboard="${3:-}"

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

  if [[ "$clipboard" == "--clipboard" ]]; then
    copy_to_clipboard "$output"
  else
    printf '%s\n' "$output"
  fi
  exit 0
fi

[[ $# -lt 2 ]] && usage

lang="$1"
role="$2"
clipboard="${3:-}"

lang_file="$SCRIPT_DIR/lang/${lang}.md"
role_file="$SCRIPT_DIR/${role}"
[[ "$role_file" != *.md ]] && role_file="${role_file}.md"
base_file="$SCRIPT_DIR/_base_audit.md"

for f in "$base_file" "$lang_file" "$role_file"; do
  if [[ ! -f "$f" ]]; then
    echo "Error: no existe $f" >&2
    exit 1
  fi
done

output=$(cat "$base_file" <(printf '\n---\n\n') "$lang_file" <(printf '\n---\n\n') "$role_file")

if [[ "$clipboard" == "--clipboard" ]]; then
  copy_to_clipboard "$output"
else
  printf '%s\n' "$output"
fi
