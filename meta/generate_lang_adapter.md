---
id: meta.generate-lang-adapter
type: meta
name: "Generador de Adaptadores de Lenguaje"
version: 1.0.0
description: "Meta-prompt para crear adaptadores de contexto para lenguajes de programación (engineering)"
tags: [meta, generator, adapter, engineering, language]
input: "Nombre del lenguaje + especificaciones del contexto"
output: "Archivo de adaptador completo en disciplines/engineering/adapters/<nombre>.md"
estimated_tokens: 480
---

# Meta: Generar Adaptador de Lenguaje

Actúa como **Experto en el lenguaje objetivo** y como **Ingeniero de Prompts**. Tu objetivo es generar un adaptador de contexto completo **solo para lenguajes de programación** (disciplina engineering), siguiendo las convenciones del sistema.

Este meta aplica únicamente a adaptadores como: `python`, `typescript`, `bash`, `go`, `rust`, `java`, etc. Para otros tipos de adaptador (contenido, diseño, negocio, gestión) usa el meta genérico `generate_adapter.md`.

## Input esperado

1. **Nombre del adaptador**: identificador kebab-case del lenguaje (ej. `python`, `typescript`, `go`).
2. **Descripción del contexto**: qué caracteriza este lenguaje, versiones relevantes, ecosistema (frameworks, gestores de paquetes, convenciones de la comunidad).
3. Opcionalmente: un adaptador existente de la misma disciplina como referencia (ej. `python.md`, `bash.md`).

## Front-matter obligatorio

```yaml
---
id: engineering.adapter.<nombre>
type: adapter
discipline: engineering
name: "Adaptador <Nombre Formal del Lenguaje>"
version: 1.0.0
description: "Convenciones, anti-patterns y tooling idiomático para <Lenguaje>"
tags: [<nombre>, adapter, engineering, idioms]
estimated_tokens: <estimación>
---
```

## Estructura de contenido (secciones obligatorias, en este orden)

1. **Detección de contexto**: versión del lenguaje, framework principal, gestor de dependencias, configuración de linting/tipos. Si no se puede determinar, declarar supuestos.

2. **Convenciones del lenguaje**: guía de estilo canónica (PEP, estándares oficiales, RFCs), naming, formatting, idioms del lenguaje, sistema de tipos si aplica.

3. **Anti-patterns específicos**: mínimo 6-8 con ejemplo incorrecto → correcto, priorizados por impacto. Específicos del ecosistema, no genéricos.

4. **Rendimiento**: nivel algorítmico, nivel runtime/intérprete, nivel nativo/externo si aplica, herramientas de profiling. Enfatizar: medir antes de optimizar.

5. **Seguridad específica**: APIs peligrosas del lenguaje, patrones de inyección típicos del ecosistema, herramientas de auditoría y dependencias.

6. **Tooling de referencia**: linting, testing, profiling, seguridad/dependencias. Nombres concretos de herramientas usadas en el ecosistema.

## Restricciones

- Cada sección debe ser **específica del lenguaje** — nada genérico aplicable a cualquier lenguaje.
- Longitud objetivo: **50-80 líneas** de contenido (sin contar front-matter).
- No duplicar contenido de `_base.md` ni de `disciplines/engineering/_base.md`.
- Citar fuentes oficiales cuando existan (guías de estilo, PEPs, documentación oficial del lenguaje).
- El adaptador debe funcionar con **cualquier rol de engineering** (implementer, reviewer, security, etc.), no solo con uno.

## Entregables

1. **Fichero `disciplines/engineering/adapters/<nombre>.md`** completo, listo para copiar al repositorio.
2. **Notas de integración**: con qué roles de engineering interactúa mejor, consideraciones especiales para este lenguaje.
