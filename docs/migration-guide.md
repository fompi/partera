# Historial de Migraciones

Este documento recoge cambios arquitectónicos relevantes del sistema.

## Eliminación del modo legacy (feb 2026)

Se eliminó el modo legacy (v1) que permitía sintaxis antigua (`LANG=`, roles planos). El sistema usa exclusivamente la arquitectura de disciplinas:

- **DISC** (obligatorio): disciplina (engineering, content, design, business, management)
- **ADAPTER**: adaptador (python, bash, technical, web, agile, ...)
- **ROLE**: rol con path completo (audit/01_security/_index, generate/02_implementer/_index, ...)

```bash
# Sintaxis actual
make compose DISC=engineering ADAPTER=python ROLE=audit/01_security/_index
```

Ver [`docs/architecture.md`](architecture.md) para el diseño del sistema.
