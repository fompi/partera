---
id: meta.generate-adapter
type: meta
name: "Generador de Adaptadores"
version: 2.0.0
description: "Meta-prompt para crear adaptadores de contexto para cualquier disciplina"
tags: [meta, generator, adapter, cross-discipline]
input: "Disciplina + tipo de adaptador + especificaciones"
output: "Archivo de adaptador completo con front-matter"
estimated_tokens: 620
---

# Meta: Generar Adaptador

Actúa como **Experto en el dominio objetivo** y como **Ingeniero de Prompts**. Tu objetivo es generar un adaptador de contexto completo para cualquier disciplina, siguiendo las convenciones del sistema universal.

## Tipos de adaptador por disciplina

| Disciplina   | Tipo de adaptador           | Ejemplos                               |
| ------------ | --------------------------- | -------------------------------------- |
| engineering  | Lenguaje de programación    | python, bash, typescript, go           |
| content      | Tipo / canal de contenido   | technical, marketing, news, internal   |
| design       | Plataforma / medio          | web, mobile, print, brand              |
| business     | Modelo de negocio           | saas, ecommerce, marketplace           |
| management   | Metodología de gestión      | agile, waterfall, kanban               |

Para **adaptadores de lenguaje de programación** (engineering) puedes usar el meta específico `generate_lang_adapter.md`, que profundiza en la estructura de ese tipo.

## Input esperado

1. **Disciplina**: `engineering` | `content` | `design` | `business` | `management`
2. **Nombre del adaptador**: identificador kebab-case (ej. `typescript`, `mobile`, `agile`)
3. **Descripción del contexto**: qué caracteriza este adaptador, sus convenciones y particularidades
4. Opcionalmente: un adaptador existente de la misma disciplina como referencia

## Front-matter obligatorio

```yaml
---
id: <disc>.adapter.<nombre>
type: adapter
discipline: <disc>
name: "<Nombre Formal del Adaptador>"
version: 1.0.0
description: "<Descripción de una línea>"
tags: [<disc>, adapter, <nombre>]
estimated_tokens: <estimación>
---
```

## Estructura de contenido por tipo de disciplina

### Engineering — Adaptador de lenguaje

Secciones obligatorias, en este orden:

1. **Detección de contexto**: versión del lenguaje, framework, gestor de dependencias, configuración de linting/tipos
2. **Convenciones del lenguaje**: guía de estilo canónica, naming, formatting, idioms, sistema de tipos
3. **Anti-patterns específicos**: mínimo 6-8 con ejemplo incorrecto → correcto, priorizados por impacto
4. **Rendimiento**: nivel algorítmico, nivel runtime, nivel nativo/externo, herramientas de profiling
5. **Seguridad específica**: APIs peligrosas, patrones de inyección del ecosistema, herramientas de auditoría
6. **Tooling de referencia**: linting, testing, profiling, seguridad/dependencias

### Content — Adaptador de tipo de contenido

Secciones obligatorias:

1. **Caracterización del formato**: audiencia objetivo, tono, extensión típica, propósito principal
2. **Convenciones editoriales**: estilo de escritura, estructura típica, uso de headings/listas/ejemplos
3. **Criterios de calidad**: qué distingue contenido excelente de mediocre en este formato
4. **Restricciones específicas**: qué evitar, limitaciones de formato, sensibilidades del canal
5. **Métricas de éxito**: cómo medir si el contenido cumple su propósito

### Design — Adaptador de plataforma

Secciones obligatorias:

1. **Contexto de la plataforma**: dimensiones, limitaciones técnicas, entorno de usuario
2. **Patrones de diseño idiomáticos**: componentes estándar, interacciones típicas, convenciones visuales
3. **Consideraciones de accesibilidad**: requisitos específicos de la plataforma (WCAG, guías de plataforma)
4. **Anti-patterns de diseño**: errores comunes en esta plataforma, con ejemplos
5. **Herramientas y entregables**: formatos de archivo, herramientas estándar, especificaciones esperadas

### Business — Adaptador de modelo de negocio

Secciones obligatorias:

1. **Caracterización del modelo**: cómo genera valor, quiénes son los stakeholders clave
2. **Métricas relevantes**: KPIs típicos del modelo, cómo se mide el éxito
3. **Riesgos específicos**: riesgos recurrentes en este tipo de negocio
4. **Consideraciones regulatorias**: marcos legales típicamente aplicables
5. **Vocabulario del dominio**: términos clave y su definición precisa en este contexto

### Management — Adaptador de metodología

Secciones obligatorias:

1. **Principios de la metodología**: valores y principios fundamentales
2. **Artefactos y ceremonias**: entregables típicos, reuniones, cadencias
3. **Roles y responsabilidades**: quién hace qué en esta metodología
4. **Anti-patterns de la metodología**: cómo se desvirtúa habitualmente en práctica
5. **Métricas de salud del proceso**: cómo saber si la metodología está funcionando bien

## Restricciones generales

- Cada sección debe ser **específica y concreta al adaptador** — nada genérico aplicable a cualquier contexto.
- Longitud objetivo: **50-80 líneas** de contenido (sin contar front-matter).
- No duplicar contenido de `_base.md` ni de `disciplines/<disc>/_base.md`.
- Citar fuentes oficiales cuando existan (guías de estilo, RFCs, documentación oficial).
- El adaptador debe funcionar con **cualquier rol de la disciplina**, no solo con uno.

## Entregables

1. **Fichero `disciplines/<disc>/adapters/<nombre>.md`** completo, listo para copiar al repositorio.
2. **Notas de integración**: con qué roles interactúa mejor, consideraciones especiales.
