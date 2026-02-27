# Fase 1 completada — Fundamentos del Sistema

## Qué se creó

### Archivos nuevos

| Archivo | Descripción |
|---|---|
| `_base.md` | Base universal con front-matter YAML (extraída de `_base_audit.md`) |
| `scripts/validate_frontmatter.sh` | Valida front-matter YAML en todos los `.md` del repo |
| `scripts/list_by_type.sh` | Lista piezas del sistema por tipo/disciplina |
| `scripts/test_compose_legacy.sh` | Tests de regresión de compatibilidad legacy |
| `.gitattributes` | Configuración de diff y detección de lenguaje para `.md` |
| `docs/phase1-completed.md` | Este documento |

### Estructura de directorios

```
disciplines/
  engineering/  adapters/  roles/{audit,generate,plan}/
  content/      adapters/  roles/{generate,audit}/
  design/       adapters/  roles/create/
  business/     adapters/  roles/plan/
  management/   adapters/  roles/plan/
techniques/
  security/  performance/  correctness/  scalability/
  maintainability/  devex/  resilience/
knowledge/  modifiers/{audience,depth,industry}/
sources/  protocols/  capabilities/  runtimes/
tools/{schemas,wrappers}/  patterns/  chains/
meta/  docs/  scripts/
```

## Qué cambió

### `compose.sh`
- Añadido **modo dual**: detecta automáticamente `DISC` para activar el modo nuevo
- Flag `--legacy` para forzar modo legacy aunque `DISC` esté definido
- Modo nuevo: resuelve `_base.md`, `disciplines/$DISC/adapters/`, `disciplines/$DISC/roles/`
- Soporte para `EXT=` (extensiones adicionales en modo nuevo)
- Validación de disciplina coherente entre adaptador y rol (vía front-matter)

### `Makefile`
- `ADAPTER=` como alias de `LANG=` (ambos funcionan)
- Nuevos targets: `validate-frontmatter`, `list-disciplines`, `list-adapters`, `list-roles`, `list-techniques`, `list-sources`, `list-protocols`, `list-capabilities`, `test-legacy`
- `list-roles` es contexto-sensitivo: sin `DISC` muestra legacy, con `DISC=<disciplina>` usa el script nuevo

## Tests de regresión ejecutados

```
make test-legacy
```

**Resultado**: 19/19 tests pasados

Comandos verificados:
- `make compose LANG=python ROLE=01_security/_index`
- `make compose LANG=bash ROLE=02_performance/_index`
- `make compose ADAPTER=python ROLE=01_security/_index`
- `make compose ADAPTER=bash ROLE=00_orchestrator/_index`
- `bash compose.sh python 00_orchestrator/_index`
- `bash compose.sh python 01_security/_index`
- `bash compose.sh bash 02_performance/_index`
- `bash compose.sh python 04_correctness/_index`
- `bash compose.sh --meta improve_prompt`
- `bash compose.sh --meta evaluate_coverage`
- Subtasks: `01_security/01a_injection_surfaces`, `02_performance/02a_algorithmic_complexity`

## Comandos disponibles

```bash
# Validación
make validate-frontmatter

# Listado
make list-disciplines
make list-adapters                  # todos
make list-adapters DISC=engineering  # por disciplina
make list-roles                     # legacy
make list-roles DISC=engineering    # nueva arquitectura
make list-techniques
make list-sources
make list-protocols
make list-capabilities

# Tests de regresión
make test-legacy

# Compose (legacy, sin cambios)
make compose LANG=python ROLE=01_security/_index
make compose ADAPTER=python ROLE=01_security/_index

# Compose (nuevo modo)
DISC=engineering make compose ADAPTER=python ROLE=audit/01_security/_index
```

## Sin tocar

Los siguientes archivos **no fueron modificados**:

- `_base_audit.md` (se archivará en Fase 2)
- `lang/python.md`, `lang/bash.md`
- `00_orchestrator/`, `01_security/`, `02_performance/`, `03_architecture/`, `04_correctness/`, `05_quality/`
- `meta/` (meta-prompts existentes)

## Siguiente fase

**Fase 2**: Migración de piezas existentes a la nueva arquitectura
- Crear `disciplines/engineering/adapters/python.md` y `bash.md` con front-matter
- Migrar roles existentes a `disciplines/engineering/roles/audit/`
- Crear técnicas en `techniques/`
- Archivar `_base_audit.md` como `_archive/_base_audit.md`
