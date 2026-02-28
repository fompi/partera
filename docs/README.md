# Documentación técnica — Partera

Este directorio contiene la documentación técnica del sistema de prompts modulares: decisiones de diseño, convenciones y guías de uso.

## Documentos

| Documento | Propósito |
| ---------- | --------- |
| [**architecture.md**](architecture.md) | Arquitectura del sistema: las 11 capas, orden de composición, almas, decisiones de diseño y comparación con otros sistemas. **Empieza aquí** si quieres entender cómo está construido el sistema. |
| [**migration-guide.md**](migration-guide.md) | Historial de cambios que afectan a la sintaxis o al uso (p. ej. eliminación del modo legacy). Consulta antes de actualizar desde una versión antigua. |
| [**cross-discipline-compatibility.md**](cross-discipline-compatibility.md) | Matriz de compatibilidad entre disciplinas y adaptadores: qué combinaciones son válidas, flujos de trabajo multi-disciplinares y reglas de validación. |
| [**sfia-mapping.md**](sfia-mapping.md) | Mapeo de roles y técnicas del sistema al framework SFIA 9 (Skills Framework for the Information Age) para trazabilidad de competencias. |
| [**chains-and-patterns.md**](chains-and-patterns.md) | Diseño y uso de **chains** (flujos multi-paso) y **patterns** (estilos de razonamiento: CoT, Plan-and-Solve, etc.). |

## Convenciones de esta documentación

- **Rutas**: Las rutas a archivos o directorios se dan relativas a la raíz del repositorio (donde está `compose.sh` y `Makefile`), salvo que se indique lo contrario.
- **Términos clave**: Disciplina, adaptador, rol, técnica, modifier, source, protocol, capability, runtime y alma se definen en [architecture.md](architecture.md) y en el [README principal](../README.md) (sección Arquitectura / Glosario).
- **Ejemplos**: Los ejemplos de `make` y `./compose.sh` están probados contra la versión actual del sistema; si algo falla, ejecuta `make validate` y revisa [migration-guide.md](migration-guide.md).
