# Sistema Universal de Prompts Modulares

> **En 30 segundos:** Un sistema de instrucciones modulares para asistentes IA (Claude, GPT, Gemini, Ollama…) que cubre 5 disciplinas profesionales — ingeniería, contenido, diseño, negocio y gestión. Combinas piezas según tu necesidad; el sistema monta el prompt completo por ti.
>
> Última actualización: febrero 2026

---

## Índice

- [Características](#características)
- [Quick Start](#quick-start)
- [Arquitectura — las 11 capas](#arquitectura--las-11-capas)
- [Fórmula de composición](#fórmula-de-composición)
- [Disciplinas disponibles](#disciplinas-disponibles)
- [Estructura de directorios](#estructura-de-directorios)
- [Cheat Sheet](#cheat-sheet)
- [Chains (workflows complejos)](#chains-workflows-complejos)
- [Comparación con otros sistemas](#comparación-con-otros-sistemas)
- [Automejora y extensión](#automejora-y-extensión)
- [Guía por plataforma](#guía-por-plataforma)
- [Roadmap](#roadmap)
- [Contribuir](#contribuir)
- [Licencia](#licencia)

---

## Características

- **11 tipos de capas composables**: base, disciplina, adaptador, knowledge, rol, técnicas, modifiers, sources, protocols, capabilities, runtime
- **5 disciplinas profesionales**: engineering, content, design, business, management (expandible)
- **Cross-disciplinar by design**: técnicas y knowledge packs reutilizables entre disciplinas
- **Runtime-agnostic**: Claude, OpenAI, Gemini, Ollama, LangChain, CrewAI, AutoGen
- **SFIA-mapped**: trazabilidad al framework de competencias profesionales SFIA 9
- **Validación automática**: scripts validan front-matter, referencias y consistencia
- **Chains declarativas**: workflows multi-paso con front-matter YAML

---

## Quick Start

### Instalación

```bash
git clone https://github.com/<usuario>/partera.git
cd partera
```

Requisitos: `bash`, `make`. Opcional: `jq` para funciones avanzadas.

### Uso básico

```bash
# Auditoría de seguridad en código Python
make compose DISC=engineering ADAPTER=python ROLE=audit/01_security/_index

# Generación de documentación técnica
make compose DISC=content ADAPTER=technical ROLE=generate/01_doc-writer/_index

# Diseño web con conocimiento de ingeniería básica
make compose DISC=design ADAPTER=web ROLE=create/00_web-designer/_index \
  EXT="knowledge/engineering-basics"

# Planificación de proyecto con metodología ágil
make compose DISC=management ADAPTER=agile ROLE=plan/00_project-manager/_index

# Auditoría con audiencia ejecutiva y fuentes oficiales
make compose DISC=engineering ADAPTER=python ROLE=audit/01_security/_index \
  EXT="modifiers/audience/executive sources/official-docs-only"
```

El resultado se imprime en stdout — cópialo y pégalo en tu asistente IA favorito, o usa `make clipboard` para copiarlo directamente.

### Con runtime específico

```bash
# Adaptado para Claude (usa Extended Thinking si está disponible)
make runtime-claude DISC=engineering ADAPTER=python ROLE=audit/01_security/_index

# Adaptado para CrewAI (genera definición de agente)
make generate-crewai DISC=engineering ADAPTER=python ROLE=generate/02_implementer/_index
```

---

## Arquitectura — las 11 capas

El sistema compone prompts concatenando capas ordenadas. Cada capa aporta contexto específico sin duplicar el de otras:

| # | Tipo | Directorio | Descripción |
|---|------|-----------|-------------|
| 1 | `base` | `_base.md` | Contrato universal: anti-alucinación, CoT, formato de hallazgo |
| 2 | `discipline_base` | `disciplines/<disc>/_base.md` | Principios, estándares y ética de la disciplina |
| 3 | `adapter` | `disciplines/<disc>/adapters/` | Contexto específico: lenguaje, plataforma, modelo de negocio |
| 4 | `knowledge` | `knowledge/` | Conocimiento de referencia curado (opcional) |
| 5 | `role` | `disciplines/<disc>/roles/<verb>/<name>/` | Rol funcional con persona y metodología |
| 6 | `technique` | `techniques/<area>/` | Técnicas reutilizables cross-disciplinares (opcional) |
| 7 | `modifier` | `modifiers/<type>/` | Ajusta audiencia, profundidad o industria (opcional) |
| 8 | `source` | `sources/` | Restringe fuentes de información (opcional) |
| 9 | `protocol` | `protocols/` | Modo de ejecución: autónomo, supervisado, colaborativo (opcional) |
| 10 | `capability` | `capabilities/` | Capacidades requeridas del LLM: visión, código, web (opcional) |
| 11 | `runtime` | `runtimes/` | Adaptaciones específicas del runtime/framework (opcional) |

---

## Fórmula de composición

```
PROMPT = base + discipline_base + adapter
       + [knowledge] + role + [techniques]
       + [modifiers] + [sources] + [protocols]
       + [capabilities] + [runtime]
```

Las capas en `[corchetes]` son opcionales. Se activan via `EXT=` o flags específicos:

```bash
DISC=engineering \
RUNTIME=claude \
EXT="knowledge/security-awareness techniques/security/injection-analysis modifiers/depth/deep" \
./compose.sh python audit/01_security/_index
```

---

## Disciplinas disponibles

### Engineering
Roles de auditoría, generación de código, revisión y planificación técnica.

| Task type | Roles disponibles |
|-----------|-------------------|
| `audit`   | orchestrator, security, performance, architecture, correctness |
| `generate`| spec-writer, tech-advisor, implementer, reviewer, documenter, frontend-dev |
| `plan`    | tech-estimator |

Adaptadores: `python`, `bash`

### Content
Creación y auditoría de contenido profesional.

| Task type | Roles disponibles |
|-----------|-------------------|
| `audit`   | content-auditor |
| `generate`| clickbait-writer, doc-writer, ops-procedures, copywriter |

Adaptadores: `technical`, `marketing`, `news`, `internal`

### Design
Diseño de producto y experiencia de usuario.

| Task type | Roles disponibles |
|-----------|-------------------|
| `create`  | web-designer, ux-researcher |

Adaptadores: `web`, `mobile`

### Business
Análisis de negocio, presales y estrategia.

| Task type | Roles disponibles |
|-----------|-------------------|
| `plan`    | presales |

Adaptadores: `saas`, `ecommerce`

### Management
Gestión de proyectos y equipos.

| Task type | Roles disponibles |
|-----------|-------------------|
| `plan`    | project-manager |

Adaptadores: `agile`, `waterfall`

---

## Estructura de directorios

```
partera/
├── _base.md                    # Capa 1: base universal
├── disciplines/                # Capa 2+3: disciplinas y adaptadores
│   ├── engineering/
│   │   ├── _base.md
│   │   ├── adapters/           # python.md, bash.md
│   │   └── roles/
│   │       ├── audit/
│   │       ├── generate/
│   │       └── plan/
│   ├── content/ design/ business/ management/
├── knowledge/                  # Capa 4: packs de conocimiento
├── techniques/                 # Capa 6: técnicas reutilizables
│   ├── security/ performance/ correctness/
│   ├── maintainability/ resilience/ scalability/ devex/
├── modifiers/                  # Capa 7: audience/ depth/ industry/
├── sources/                    # Capa 8
├── protocols/                  # Capa 9
├── capabilities/               # Capa 10
├── runtimes/                   # Capa 11
├── patterns/                   # Patrones de razonamiento (CoT, ReAct...)
├── chains/                     # Workflows multi-paso
├── tools/schemas/ tools/wrappers/  # Schemas JSON y wrappers de herramientas
├── meta/                       # Meta-prompts para extender el sistema
├── scripts/                    # Herramientas de validación y composición
├── docs/                       # Documentación técnica
└── compose.sh / Makefile
```

---

## Cheat Sheet

```bash
# Composición básica
make compose DISC=<disc> ADAPTER=<adapter> ROLE=<verb>/<name>/_index

# Con capas opcionales
make compose DISC=engineering ADAPTER=python ROLE=audit/01_security/_index \
  EXT="knowledge/engineering-basics modifiers/audience/executive"

# Con runtime
make runtime-claude DISC=engineering ADAPTER=python ROLE=generate/02_implementer/_index
make runtime-openai DISC=content ADAPTER=technical ROLE=generate/01_doc-writer/_index

# Chains
make chain CHAIN=nl-to-code ADAPTER=python
make chain CHAIN=full-audit ADAPTER=python
make list-chains

# Listados
make list-runtimes
make list-patterns
make list-by-type TYPE=role
make list-by-type TYPE=technique

# Validación
make validate
make validate-discipline DISC=engineering

```

---

## Chains (workflows complejos)

Las chains encadenan múltiples roles en un workflow declarativo:

```bash
# NL → spec → código → tests
make chain CHAIN=nl-to-code ADAPTER=python

# Auditoría completa (orquestador → security → performance → architecture → correctness)
make chain CHAIN=full-audit ADAPTER=python

# Idea → propuesta → plan → implementación
make chain CHAIN=idea-to-project ADAPTER=python

# Pipeline de contenido (brief → borrador → revisión → publicación)
make chain CHAIN=content-pipeline ADAPTER=technical
```

Ver `chains/*.chain` para definiciones completas.

---

## Comparación con otros sistemas

| Aspecto | Este sistema | Fabric | CrewAI | LangChain |
|---------|-------------|--------|--------|-----------|
| Estructura | 11 capas composables | Biblioteca plana | Agentes con roles | Chains de código |
| Disciplinas | 5 (expandible) | Principalmente ingeniería | Sin disciplinas | Sin disciplinas |
| Metadata | YAML front-matter | Sin metadata | Código Python | Sin metadata |
| Chains | Declarativas YAML | Ad-hoc | Código Python | Código Python |
| SFIA mapping | Sí | No | No | No |
| Runtime-agnostic | Sí | Sí | No (propio) | No (propio) |
| Validación | Scripts automáticos | No | No | No |
| Cross-disciplinar | Sí (técnicas compartidas) | No | Parcial | No |

Ver [`docs/architecture.md`](docs/architecture.md) para análisis profundo.

---

## Automejora y extensión

El directorio `meta/` contiene prompts para extender el propio sistema:

| Meta-prompt | Uso |
|-------------|-----|
| `meta/generate_role.md` | Crear un nuevo rol en cualquier disciplina |
| `meta/generate_adapter.md` | Crear un adaptador para cualquier disciplina |
| `meta/generate_discipline.md` | Crear una nueva disciplina completa |
| `meta/generate_technique.md` | Crear una técnica cross-disciplinar |
| `meta/evaluate_coverage.md` | Evaluar gaps y cobertura del sistema |
| `meta/improve_prompt.md` | Mejorar un prompt existente |

Ejemplo — generar un nuevo rol de auditoría de compliance:

```bash
# 1. Componer el meta-prompt
cat meta/_base_meta.md meta/generate_role.md > /tmp/meta-gen-role.txt

# 2. Pegar en el LLM junto con la descripción del rol deseado
# Input: "Rol de auditoría de compliance GDPR para engineering, Python"
# Output: disciplines/engineering/roles/audit/06_compliance/_index.md
```

---

## Guía por plataforma

### Claude (claude.ai / API)

1. Genera el prompt: `make compose DISC=engineering ADAPTER=python ROLE=audit/01_security/_index`
2. En Claude.ai: crea un Proyecto → pega en *Custom Instructions*
3. En el chat: sube o pega tu código → "Ejecuta la auditoría según las instrucciones"
4. Para API: usa como `system` prompt

### ChatGPT (chatgpt.com / API)

1. Genera el prompt y cópialo
2. Crea un Proyecto → pega en instrucciones del proyecto
3. En el chat: sube/pega código → "Ejecuta la auditoría"

### Cursor / Windsurf / Copilot

1. Genera el prompt
2. Pégalo en el archivo `.cursorrules` o en "Custom Instructions" del IDE
3. Úsalo directamente en el editor

### Ollama (local)

```bash
# Genera el prompt para Ollama
RUNTIME=ollama make compose DISC=engineering ADAPTER=python ROLE=audit/01_security/_index

# Úsalo con ollama
ollama run llama3.3 "$(cat /tmp/prompt.txt)\n\n<código aquí>"
```

### API directa (cualquier proveedor)

```python
prompt = open("output.txt").read()
# Usa como system message en la API de tu elección
```

---

## Roadmap

### Próximas disciplinas
- `data` — análisis de datos, BI, visualización (DTAN, VISL, BUAN)
- `ai` — ingeniería de ML, LLMops, evaluación de modelos (MLNG, AISF)

### Próximos adaptadores
- Engineering: `typescript`, `go`, `rust`
- Content: `social-media`, `email`
- Design: `print`, `brand`

### Próximas técnicas
- `stakeholder-mapping`, `gap-analysis`, `user-story-mapping`

### Próximas chains
- `code-review-pr`, `content-audit-and-improve`, `design-critique`

---

## Contribuir

1. Fork el repositorio
2. Crea una rama para tu contribución
3. Sigue las convenciones de front-matter YAML
4. Ejecuta `make validate` antes de hacer PR
5. Incluye test de uso en el PR

Ver [`docs/architecture.md`](docs/architecture.md) para decisiones de diseño y convenciones.

---

## Licencia

MIT — ver [LICENSE](LICENSE)
