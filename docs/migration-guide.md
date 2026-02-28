# Historial de migraciones

**Propósito**: Registrar cambios que afectan a la **sintaxis de uso** o al comportamiento esperado del sistema (p. ej. eliminación de modos legacy, cambios en variables de entorno). Consulta este documento si un comando que antes funcionaba deja de hacerlo o si actualizas desde una versión antigua.

## Eliminación del modo legacy (feb 2026)

Se eliminó el modo legacy (v1) que permitía sintaxis antigua (`LANG=`, roles planos). El sistema usa exclusivamente la arquitectura de disciplinas:

- **DISC** (obligatorio): disciplina (engineering, content, design, business, management)
- **ADAPTER**: adaptador (python, bash, technical, web, agile, ...)
- **ROLE**: rol con path completo (audit/0001_security/_index, generate/0002_implementer/_index, ...)

```bash
# Sintaxis actual (obligatoria desde feb 2026)
make compose DISC=engineering ADAPTER=python ROLE=audit/0001_security/_index
```

**Comprobar que usas la sintaxis actual**: si `make compose` sin `DISC`, `ADAPTER` y `ROLE` falla con "DISC requerido" (o similar), estás usando la sintaxis correcta. El sistema ya no acepta `LANG=` ni rutas de rol planas.

Ver [architecture.md](architecture.md) para el diseño del sistema.
