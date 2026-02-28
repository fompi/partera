---
id: engineering.adapter.bash
type: adapter
discipline: engineering
name: "Adaptador Bash"
version: 1.0.0
description: "Convenciones, anti-patterns y tooling idiomático para Bash/shell scripting"
tags: [bash, shell, adapter, engineering, idioms]
sfia_category: "Programming/software development"
estimated_tokens: 380
migrated_from: "lang/bash.md"
---

# Adaptador Idiomático: Bash

## Detección de contexto

Antes de analizar, identifica y declara:

- **Shebang**: `#!/bin/bash`, `#!/usr/bin/env bash`, `#!/bin/sh` (POSIX), otro.
- **Versión objetivo**: Bash 4, Bash 5, POSIX sh puro.
- **Entorno de ejecución**: CI/CD (GitHub Actions, GitLab CI…), cron, contenedor, script de sistema, CLI interactivo.
- **Dependencias externas**: qué comandos asume disponibles (jq, curl, awk, sed, GNU vs BSD coreutils…).

Si no puedes determinarlo, declara supuestos y continúa.

## Convenciones del lenguaje

Evalúa conformidad con:

- **Quoting**: toda variable entre comillas dobles salvo expansiones intencionalmente sin comillas.
- **Tests**: `[[ ]]` para Bash, `[ ]` para POSIX. Nunca test sin corchetes.
- **Aritmética**: `$(( ))` en vez de `expr` o `let`.
- **Funciones**: declarar con `nombre() {`, usar `local` para variables internas.
- **Naming**: `UPPER_SNAKE` para constantes y variables de entorno, `lower_snake` para locales y funciones.
- **Exit codes**: semánticos (0 éxito, 1 error genérico, 2 uso incorrecto). Documentar valores no estándar.

## Anti-patterns específicos

Busca activamente:

- Variables sin comillas: `$var` en vez de `"$var"` (word splitting + globbing).
- `cd dir` sin `|| exit` / `|| return` (continúa en directorio incorrecto si falla).
- Parsear salida de `ls` (usar globbing o `find`).
- `cat file | grep` (UUOC — usar `grep pattern file` directamente).
- `eval` con input no controlado.
- Heredocs con indentación incorrecta (tabs vs spaces con `<<-`).
- `for f in $(find ...)` (usar `find -exec` o `while IFS= read -r` con process substitution).
- `[ -z $var ]` sin comillas (falla si `$var` tiene espacios o está vacío).
- Funciones sin `local` que contaminan el scope global.
- `kill -9` como primera opción (intentar SIGTERM primero).

## Errores y robustez

Verifica:

- **`set -euo pipefail`**: ¿está presente? ¿Es apropiado para el script? (en scripts interactivos o con manejo explícito de errores, `-e` puede ser contraproducente).
- **`trap`** para cleanup de ficheros temporales, procesos hijos, locks.
- **Detección de dependencias**: `command -v <cmd> &>/dev/null || { echo "…"; exit 1; }`.
- **Ficheros temporales**: creados con `mktemp` (nunca rutas hardcoded en `/tmp`).
- **Señales**: manejo correcto de SIGINT/SIGTERM en scripts de larga duración.
- **Stdin/stdout/stderr**: uso correcto (mensajes de error a `>&2`, datos a stdout).

## Seguridad específica

Además del checklist general de seguridad, busca:

- Inyección de comandos vía variables no sanitizadas en `eval`, `$()`, backticks.
- Credenciales en argumentos de CLI (visibles en `/proc/*/cmdline` y `ps`). Usar variables de entorno o ficheros con permisos restrictivos.
- Ficheros temporales sin `mktemp` (race condition / symlink attack).
- Permisos: `umask` no configurado, ficheros creados con permisos excesivos.
- Expansión de variables en contextos SQL, curl, o queries sin escapar.
- Scripts con SUID/SGID (casi siempre un error de seguridad).
- `source` o `.` de ficheros no confiables.
- `curl | bash` sin verificación de integridad.

## Rendimiento

Evalúa eficiencia:

- **Builtins vs externos**: `${var%%pattern}` vs `sed`/`awk` para manipulación simple de strings. Builtins evitan fork+exec.
- **Subshells innecesarias**: `$(cat file)` → `$(<file)`. Pipes que fuerzan subshells cuando un redirect basta.
- **Loops con comandos externos**: `while read` llamando a `awk`/`sed` por línea → una sola invocación de `awk` procesando todo el flujo.
- **`find -exec {} +`** vs `xargs` (batch) vs `find -exec {} \;` (uno a uno).
- **Paralelismo**: `&` + `wait` para tareas independientes. GNU `parallel` para procesamiento masivo.
- **Arrays**: uso de arrays para evitar re-parseo de datos.

## Portabilidad

Marca incompatibilidades si el script debe correr fuera de Bash:

- Arrays (`declare -a`): solo Bash (no POSIX sh, no dash).
- `[[ ]]`, `=~`, `<()`: bashismos.
- `${var,,}` / `${var^^}` (case conversion): Bash 4+.
- `mapfile` / `readarray`: Bash 4+.
- `&>` (redirect ambos): Bash (POSIX: `>file 2>&1`).
- Associative arrays (`declare -A`): Bash 4+.

## Tooling de referencia

Verifica si el proyecto usa (y recomienda si no):

- **ShellCheck**: obligatorio. Referenciar códigos SC específicos en hallazgos.
- **shfmt**: formateo consistente.
- **bats-core**: framework de testing para scripts Bash.
- **`bash -n script.sh`**: syntax check sin ejecutar.
- **`set -x`** / `PS4='+ ${BASH_SOURCE}:${LINENO}: '`: debugging con trazas.

## Campo extra por hallazgo

Cuando uses la plantilla de hallazgo del archivo base, añade este campo:

- **Portabilidad**: POSIX | Bash 4+ | Bash 5+ | GNU-only
