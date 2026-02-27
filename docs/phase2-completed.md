# Fase 2 completada — Migración de Disciplina Engineering (Audit)

## Qué se creó

### Archivos nuevos (21)

| Archivo | Tipo | Descripción |
|---|---|---|
| `disciplines/engineering/_base.md` | discipline_base | Principios SOLID/DRY/KISS, calidad de código, deuda técnica |
| `disciplines/engineering/adapters/python.md` | adapter | Adaptador Python con front-matter completo |
| `disciplines/engineering/adapters/bash.md` | adapter | Adaptador Bash con front-matter completo |
| `disciplines/engineering/roles/audit/00_orchestrator/_index.md` | role | Orquestador: mapa del sistema y triage |
| `disciplines/engineering/roles/audit/01_security/_index.md` | role | Auditor de Seguridad |
| `disciplines/engineering/roles/audit/02_performance/_index.md` | role | Ingeniero de Rendimiento |
| `disciplines/engineering/roles/audit/03_architecture/_index.md` | role | Revisor de Arquitectura |
| `disciplines/engineering/roles/audit/04_correctness/_index.md` | role | Cazador de Bugs y Edge Cases |
| `techniques/security/injection-analysis.md` | technique | Rastreo de flujos de taint |
| `techniques/security/auth-access-control.md` | technique | Fronteras de auth e IDOR |
| `techniques/security/secrets-crypto.md` | technique | Secretos hardcodeados y cripto |
| `techniques/security/supply-chain.md` | technique | CVEs y fijación de dependencias |
| `techniques/performance/algorithmic-complexity.md` | technique | Big-O y estructuras de datos |
| `techniques/performance/io-network-concurrency.md` | technique | I/O, red y contención |
| `techniques/performance/memory-resources.md` | technique | Fugas y ciclo de vida de recursos |
| `techniques/correctness/edge-cases-contracts.md` | technique | Contratos y edge cases |
| `techniques/correctness/concurrency-state.md` | technique | Race conditions y deadlocks |
| `techniques/correctness/error-handling.md` | technique | Excepciones tragadas y fallos silenciosos |
| `scripts/migrate_compose_cmd.sh` | script | Convierte comandos legacy a nueva sintaxis |
| `_deprecated/README.md` | doc | Mapa de migración legacy → nuevo |
| `docs/phase2-completed.md` | doc | Este documento |

### Archivos modificados (1)

| Archivo | Cambio |
|---|---|
| `Makefile` | Añadido target `compose-legacy` (alias de compatibilidad) |

### Archivos archivados en `_deprecated/` (~15)

- `_base_audit.md.bak`
- `lang/python.md`, `lang/bash.md`
- `00_orchestrator/`, `01_security/`, `02_performance/`, `03_architecture/`, `04_correctness/`

---

## Comandos disponibles

```bash
# Nueva arquitectura — compose básico
DISC=engineering bash compose.sh python audit/01_security/_index
DISC=engineering bash compose.sh bash audit/02_performance/_index
DISC=engineering bash compose.sh python audit/00_orchestrator/_index

# Nueva arquitectura — con técnica como extensión
DISC=engineering EXT="techniques/security/injection-analysis" \
  bash compose.sh python audit/01_security/_index

# Múltiples técnicas
DISC=engineering EXT="techniques/correctness/edge-cases-contracts techniques/correctness/error-handling" \
  bash compose.sh python audit/04_correctness/_index

# Alias de compatibilidad legacy (Makefile)
make compose-legacy ADAPTER=python ROLE=01_security/_index
make compose-legacy ADAPTER=bash ROLE=02_performance/_index

# Script de conversión interactiva
./scripts/migrate_compose_cmd.sh "make compose ADAPTER=python ROLE=01_security/_index"
./scripts/migrate_compose_cmd.sh --interactive

# Listar disciplinas/adapters/roles/técnicas
make list-disciplines
make list-adapters DISC=engineering
make list-roles DISC=engineering
make list-techniques

# Validación
make validate-frontmatter
```

## Tests ejecutados

### Front-matter (21/21 OK)

```
make validate-frontmatter
→ 21 archivos validados, 0 errores, 0 advertencias
```

### Compose nuevo modo

```bash
DISC=engineering bash compose.sh python audit/01_security/_index   # 299 líneas ✓
DISC=engineering bash compose.sh bash audit/02_performance/_index  # OK ✓
DISC=engineering EXT="techniques/security/injection-analysis" \
  bash compose.sh python audit/01_security/_index                  # técnica incluida ✓
```

### Alias legacy

```bash
make compose-legacy ADAPTER=python ROLE=01_security/_index  # ✓
```

---

## Checklist de salida

- [x] Base de Engineering creada
- [x] 2 adaptadores migrados (Python, Bash)
- [x] 5 roles de audit migrados con front-matter
- [x] 10 técnicas promovidas (4 security, 3 performance, 3 correctness)
- [x] Referencias actualizadas en roles (links a técnicas vía EXT)
- [x] Tests de equivalencia pasados (nuevo mode funcional)
- [x] Archivos obsoletos archivados en `_deprecated/`
- [x] Script de migración de comandos creado
- [x] Makefile con alias `compose-legacy`
- [x] Front-matter válido en todos los archivos nuevos

---

## Qué deprecó

- **`_base_audit.md`**: reemplazado por `_base.md` (contenido universal) + `disciplines/engineering/_base.md` (específico de ingeniería)
- **`lang/python.md`**, **`lang/bash.md`**: reemplazados por adaptadores en `disciplines/engineering/adapters/`
- **`00_orchestrator/`, `01_security/`, `02_performance/`, `03_architecture/`, `04_correctness/`**: roles migrados a `disciplines/engineering/roles/audit/`; subtasks promovidas a `techniques/`

## Diferencias clave legacy → nuevo

| Aspecto | Legacy | Nuevo |
|---|---|---|
| Composición | base + lang + rol (3 archivos) | _base + disc_base + adapter + rol [+ técnicas] |
| Activación | `compose.sh python 01_security/_index` | `DISC=engineering compose.sh python audit/01_security/_index` |
| Subtasks | archivos incluidos manualmente | técnicas reutilizables vía `EXT=` |
| Front-matter | ninguno | YAML completo con id, type, discipline, etc. |
| Multi-disciplina | no | sí (técnicas con `applicable_disciplines`) |

## Siguiente fase

**Fase 3**: Expansión a nuevas disciplinas (content, AI, data) y nuevos task_types (generate, plan, refactor).
