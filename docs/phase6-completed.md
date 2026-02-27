# Fase 6: Sources, Protocols, Capabilities — Completada

## Resumen

Esta fase añade las capas de comportamiento del agente: restricciones de conocimiento (sources), modos de interacción (protocols) y declaraciones de herramientas (capabilities).

---

## Sources creados (5)

| ID | Archivo | Nivel |
|----|---------|-------|
| `source.official-docs-only` | `sources/official-docs-only.md` | strict |
| `source.user-provided` | `sources/user-provided.md` | strict |
| `source.blogs-included` | `sources/blogs-included.md` | moderate |
| `source.academic` | `sources/academic.md` | strict |
| `source.internal-only` | `sources/internal-only.md` | strict |

## Protocols creados (5)

| ID | Archivo | Interaction level |
|----|---------|-------------------|
| `protocol.autonomous` | `protocols/autonomous.md` | minimal |
| `protocol.supervised` | `protocols/supervised.md` | moderate |
| `protocol.strict-input` | `protocols/strict-input.md` | high |
| `protocol.collaborative` | `protocols/collaborative.md` | high |
| `protocol.teaching` | `protocols/teaching.md` | high |

## Capabilities creadas (6)

| ID | Archivo | Soporte nativo |
|----|---------|----------------|
| `capability.vision` | `capabilities/vision.md` | claude, openai, gemini |
| `capability.web-search` | `capabilities/web-search.md` | claude-with-extension |
| `capability.code-execution` | `capabilities/code-execution.md` | claude-code-execution |
| `capability.file-analysis` | `capabilities/file-analysis.md` | claude, openai, gemini |
| `capability.calculation` | `capabilities/calculation.md` | requiere wrapper |
| `capability.diagram-generation` | `capabilities/diagram-generation.md` | requiere wrapper |

---

## Orden de composición (actualizado)

```
base universal → disc base → adapter → knowledge → rol → técnicas → modifiers → sources → protocols → capabilities
```

## Uso

```bash
# Solo source
make compose DISC=engineering ADAPTER=python ROLE=audit/01_security/_index \
  EXT="sources/official-docs-only"

# Solo protocol
make compose DISC=engineering ADAPTER=python ROLE=generate/02_implementer/_index \
  EXT="protocols/supervised"

# Solo capability
make compose DISC=engineering ADAPTER=python ROLE=generate/05_frontend-dev/_index \
  EXT="capabilities/vision"

# Combo completo
make compose DISC=engineering ADAPTER=python ROLE=generate/02_implementer/_index \
  EXT="knowledge/engineering-basics modifiers/audience/technical sources/official-docs-only protocols/supervised capabilities/code-execution"
```

## Cómo combinar sources, protocols y capabilities

- **Source** restringe qué información puede usar el agente (conocimiento)
- **Protocol** define cómo interactúa el agente con el usuario (comportamiento)
- **Capability** declara qué herramientas puede invocar (herramientas)

Son ortogonales: cualquier combinación es válida. Ejemplo de configuración para un auditor de seguridad estricto:

```
sources/official-docs-only   → Solo documentación oficial
protocols/strict-input       → Pide toda la info antes de proceder
capabilities/code-execution  → Puede ejecutar código para verificar
```

## Validación de referencias

```bash
./scripts/validate_references.sh
# Verifica que capabilities_required/optional, protocols_recommended y
# sources_recommended en todos los roles apuntan a archivos existentes.
```

Resultado: 21 roles revisados, 0 errores, 0 advertencias.

---

## Notas importantes

- Las **capabilities** son declaraciones, no implementaciones. La implementación de tool calling será en Fase 11 (runtimes).
- Los **protocols** son guías de comportamiento; el enforcement depende del runtime.
- Los **sources** son restricciones; el enforcement depende del sistema que consume los prompts.

## Siguiente fase

Fase 7: Runtimes y tool calling real.
