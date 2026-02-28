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
- [Glosario](#glosario)
- [Disciplinas disponibles](#disciplinas-disponibles)
- [Estructura de directorios](#estructura-de-directorios)
- [Cheat Sheet](#cheat-sheet)
- [Almas (composiciones declarativas)](#almas-composiciones-declarativas)
- [Chains (workflows complejos)](#chains-workflows-complejos)
- [Comparación con otros sistemas](#comparación-con-otros-sistemas)
- [Automejora y extensión](#automejora-y-extensión)
- [Guía por plataforma](#guía-por-plataforma)
- [Roadmap](#roadmap)
- [Si algo falla](#si-algo-falla)
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
- **Almas**: composiciones declarativas YAML — guarda y reutiliza combinaciones complejas de capas

---

## Quick Start

### Instalación

```bash
git clone https://github.com/<usuario>/partera.git
cd partera
```

**Requisitos**: `bash` (entorno Unix/macOS/Linux), `make`. Sin ellos no se puede componer ni validar.

**Opcional**: `yq` (para invocar y validar almas); `jq` (para funciones avanzadas de listado). Si no tienes `yq`, el resto del sistema funciona con `make compose` y `./compose.sh` usando DISC, ADAPTER y ROLE.

### Uso básico

```bash
# Auditoría de seguridad en código Python
make compose DISC=engineering ADAPTER=python ROLE=audit/0001_security/_index

# Generación de documentación técnica
make compose DISC=content ADAPTER=technical ROLE=generate/0001_doc-writer/_index

# Diseño web con conocimiento de ingeniería básica
make compose DISC=design ADAPTER=web ROLE=create/0000_web-designer/_index \
  EXT="knowledge/engineering-basics"

# Planificación de proyecto con metodología ágil
make compose DISC=management ADAPTER=agile ROLE=plan/0000_project-manager/_index

# Auditoría con audiencia ejecutiva y fuentes oficiales
make compose DISC=engineering ADAPTER=python ROLE=audit/0001_security/_index \
  EXT="modifiers/audience/executive sources/official-docs-only"
```

El resultado se imprime en stdout. Cópialo y pégalo en tu asistente IA favorito, o usa `make clipboard` (con DISC, ADAPTER y ROLE) para copiarlo al portapapeles.

### Con runtime específico

```bash
# Adaptado para Claude (usa Extended Thinking si está disponible)
make runtime-claude DISC=engineering ADAPTER=python ROLE=audit/0001_security/_index

# Adaptado para CrewAI (genera definición de agente)
make generate-crewai DISC=engineering ADAPTER=python ROLE=generate/0002_implementer/_index
```

---

## Arquitectura — las 11 capas

El sistema compone prompts concatenando capas ordenadas. Cada capa aporta contexto específico sin duplicar el de otras:

| # | Tipo | Directorio | Descripción |
| - | ---- | ---------- | ----------- |
| 1 | `base` | `layers/01_modes/<base>.md` | Contrato de salida/ejecución; por defecto `slave`. Seleccionable con `BASE=` (ver [Bases disponibles](#bases-disponibles)). |
| 2 | `discipline_base` | `layers/02_disciplines/<disc>/_base.md` | Principios, estándares y ética de la disciplina |
| 3 | `adapter` | `layers/02_disciplines/<disc>/03_adapters/` | Contexto específico: lenguaje, plataforma, modelo de negocio |
| 4 | `knowledge` | `layers/05_knowledge/` | Conocimiento de referencia curado (opcional) |
| 5 | `role` | `layers/02_disciplines/<disc>/06_roles/<verb>/<name>/` | Rol funcional con persona y metodología |
| 6 | `technique` | `layers/07_techniques/<area>/` | Técnicas reutilizables cross-disciplinares (opcional) |
| 7 | `modifier` | `layers/08_modifiers/<type>/` | Ajusta audiencia, profundidad o industria (opcional) |
| 8 | `source` | `layers/09_sources/` | Restringe fuentes de información (opcional) |
| 9 | `protocol` | `layers/10_protocols/` | Modo de ejecución: autónomo, supervisado, colaborativo (opcional) |
| 10 | `capability` | `layers/11_capabilities/` | Capacidades requeridas del LLM: visión, código, web (opcional) |
| 11 | `runtime` | `layers/12_runtimes/` | Adaptaciones específicas del runtime/framework (opcional) |

---

## Fórmula de composición

```text
PROMPT = base + discipline_base + adapter
       + [knowledge] + role + [techniques]
       + [modifiers] + [sources] + [protocols]
       + [capabilities] + [runtime]
```

Las capas en `[corchetes]` son opcionales. Se activan con `EXT=` o con flags específicos (p. ej. `RUNTIME=`). Para usar una base distinta de la por defecto: `BASE=<base>` (ej. `BASE=streaming`).

```bash
DISC=engineering \
RUNTIME=claude \
EXT="knowledge/security-awareness techniques/security/injection-analysis modifiers/depth/deep" \
./compose.sh python audit/0001_security/_index
```

### Bases disponibles

La capa 1 (`base`) elige el **contrato de salida**. Por defecto se usa `slave`. Con `BASE=<nombre>` o con `compose.base` en un alma se puede elegir otro modo:

| Base | Uso principal |
| ------ | ---------------- |
| `slave` | Informes de auditoría, compliance, trazabilidad SFIA (un resultado al final, plantilla de hallazgo) |
| `streaming` | Feedback en vivo: emite cada hallazgo en cuanto está listo; cancelación y pipelines incrementales |
| `conversational` | Tutor, exploración guiada, discovery, FAQ (turnos de conversación, formato libre) |
| `lightweight` | Borradores, brainstorming, prototipos (menos rigor, suposiciones marcadas) |
| `pedagogical` | Onboarding, documentación didáctica (cada resultado + bloque de explicación) |
| `regulated` | Sectores regulados, auditorías con estándar fijo (universal + refs normativas, lenguaje controlado) |

---

## Glosario

| Término | Significado |
| ------- | ----------- |
| **Base** | Capa de contrato de salida/ejecución (`layers/01_modes/`). Se elige entre varias: `slave` (universal, por defecto), `streaming`, `conversational`, `lightweight`, `pedagogical`, `regulated`. Define formato de output, nivel de rigor y si hay plantilla de hallazgo. |
| **Disciplina** | Área profesional: engineering, content, design, business, management, chat. Cada una tiene su `_base.md` en `layers/02_disciplines/<disc>/` y sus roles en `06_roles/`. |
| **Adaptador** | Contexto concreto dentro de una disciplina: lenguaje (python, bash), plataforma (web, mobile), metodología (agile, waterfall), etc. |
| **Rol** | Persona funcional que realiza una tarea (auditar seguridad, generar documentación, planificar proyecto). La instrucción activa del prompt. |
| **Técnica** | Metodología reutilizable entre disciplinas (p. ej. análisis de inyección, manejo de errores). Se añade opcionalmente con `EXT=`. |
| **Modifier** | Ajuste de salida: audiencia (ejecutiva, técnica, junior), profundidad (quick, deep), industria (fintech, healthcare). |
| **Source** | Restricción de fuentes de información (solo documentación oficial, solo fuentes internas, etc.). |
| **Protocol** | Modo de ejecución: autónomo, supervisado, colaborativo, pedagógico. |
| **Capability** | Capacidad requerida del LLM: visión, ejecución de código, búsqueda web, diagramas. |
| **Runtime** | Adaptación al entorno de ejecución: Claude, OpenAI, Gemini, Ollama, CrewAI, LangChain, AutoGen. |
| **Alma** | Composición declarativa en YAML que fija disciplina, rol y capas opcionales; se invoca por nombre y siempre con un adaptador. |

Rutas en `EXT=` son lógicas (p. ej. `knowledge/engineering-basics`, `modifiers/depth/deep`) y se resuelven a `layers/05_knowledge/`, `layers/08_modifiers/`, etc.

---

## Disciplinas disponibles

### Engineering

Roles de auditoría, generación de código, revisión y planificación técnica.

| Task type | Roles disponibles |
| --------- | ----------------- |
| `audit` | orchestrator, security, performance, architecture, correctness |
| `generate` | spec-writer, tech-advisor, implementer, reviewer, documenter, frontend-dev |
| `plan` | tech-estimator |

Adaptadores: `python`, `bash`

### Content

Creación y auditoría de contenido profesional.

| Task type | Roles disponibles |
| --------- | ----------------- |
| `audit` | content-auditor |
| `generate` | clickbait-writer, doc-writer, ops-procedures, copywriter |

Adaptadores: `technical`, `marketing`, `news`, `internal`

### Design

Diseño de producto y experiencia de usuario.

| Task type | Roles disponibles |
| --------- | ----------------- |
| `create` | web-designer, ux-researcher |

Adaptadores: `web`, `mobile`

### Business

Análisis de negocio, presales y estrategia.

| Task type | Roles disponibles |
| --------- | ----------------- |
| `plan` | presales |

Adaptadores: `saas`, `ecommerce`

### Management

Gestión de proyectos y equipos.

| Task type | Roles disponibles |
| --------- | ----------------- |
| `plan` | project-manager |

Adaptadores: `agile`, `waterfall`

---

## Estructura de directorios

```text
partera/
├── layers/                     # Capas de composición (orden numérico)
│   ├── 01_modes/               # Capa 1: bases (slave, streaming, conversational, …)
│   ├── 02_disciplines/         # Capa 2: disciplinas
│   │   ├── engineering/
│   │   │   ├── _base.md
│   │   │   ├── 03_adapters/   # python.md, bash.md
│   │   │   └── 06_roles/
│   │   │       ├── audit/
│   │   │       ├── generate/
│   │   │       └── plan/
│   │   ├── content/ design/ business/ management/
│   ├── 04_patterns/           # Patrones de razonamiento (CoT, ReAct...)
│   ├── 05_knowledge/
│   ├── 07_techniques/
│   ├── 08_modifiers/
│   ├── 09_sources/
│   ├── 10_protocols/
│   ├── 11_capabilities/
│   └── 12_runtimes/
├── almas/                      # Composiciones declarativas YAML
├── chains/                     # Workflows multi-paso
├── meta/                       # Meta-prompts para extender el sistema
├── scripts/                    # Herramientas de validación y composición
├── docs/                       # Documentación técnica
├── tools/                      # Schemas JSON y wrappers
└── compose.sh / Makefile
```

---

## Cheat Sheet

```bash
# Composición básica
make compose DISC=<disc> ADAPTER=<adapter> ROLE=<verb>/<name>/_index

# Con capas opcionales
make compose DISC=engineering ADAPTER=python ROLE=audit/0001_security/_index \
  EXT="knowledge/engineering-basics modifiers/audience/executive"

# Con runtime
make runtime-claude DISC=engineering ADAPTER=python ROLE=generate/0002_implementer/_index
make runtime-openai DISC=content ADAPTER=technical ROLE=generate/0001_doc-writer/_index

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

## Almas (composiciones declarativas)

Un **alma** es un archivo YAML que captura una composición específica de capas como entidad nombrada y versionable. En lugar de recordar invocaciones complejas, defines un alma una vez y la invocas por nombre.

### Uso

```bash
# Invocar un alma (siempre requiere ADAPTER)
make alma ALMA=v02/security-deep ADAPTER=python
./compose.sh --alma engineering/security-fintech bash

# Copiar al portapapeles
make alma-clipboard ALMA=v02/security-deep ADAPTER=python

# Listar almas disponibles
make list-almas

# Validar todas las almas
make validate-almas
```

### Almas incluidas

**Engineering (audit)** — `v02/security-deep`, `v02/performance-deep`, `v02/correctness-deep`, `engineering/audit-orchestrator`, `engineering/security-executive`, `engineering/security-fintech`, `engineering/security-healthcare`, `engineering/security-quick`, `engineering/architecture-review`, `engineering/architecture-teaching`, `engineering/quality-audit`

**Engineering (generate)** — `engineering/spec-writer`, `engineering/spec-writer-pedagogical`, `engineering/tech-advisor`, `engineering/implementer-claude`, `engineering/implementer-ollama`, `engineering/implementer-crewai`, `engineering/reviewer`, `engineering/reviewer-correctness`, `engineering/reviewer-junior`, `engineering/documenter`, `engineering/frontend-dev`

**Engineering (plan)** — `engineering/tech-estimator`, `engineering/tech-estimator-agile`

**Content** — `content/doc-writer`, `content/doc-writer-official-sources`, `content/doc-writer-junior`, `content/ops-procedures`, `content/content-auditor`, `content/content-auditor-seo`, `content/clickbait-writer`, `content/copywriter-deep`, `content/copywriter-marketing`

**Design** — `design/web-designer`, `design/web-with-eng`, `design/ux-researcher`, `design/ux-researcher-accessibility`

**Business** — `business/presales`, `business/presales-research`, `business/presales-fintech`, `business/market-researcher`, `business/trend-analyst`, `business/content-strategist`

**Management** — `management/project-manager`, `management/project-manager-executive`

| Alma | Feature destacada |
| ---- | ----------------- |
| `v02/security-deep` | 4 técnicas de seguridad |
| `v02/performance-deep` | 3 técnicas de rendimiento |
| `v02/correctness-deep` | 3 técnicas de correctness |
| `engineering/audit-orchestrator` | Protocol autonomous, coordina auditoría completa |
| `engineering/security-executive` | Informe para dirección (audience/executive) |
| `engineering/security-fintech` | Herencia v02 + industry/fintech + official-docs-only |
| `engineering/security-healthcare` | industry/healthcare + official-docs-only |
| `engineering/security-quick` | depth/quick + 2 técnicas |
| `engineering/architecture-review` | Técnicas scalability + maintainability |
| `engineering/architecture-teaching` | Protocol teaching + audience/junior |
| `engineering/quality-audit` | tech-debt, documentation-standards, code-organization |
| `engineering/spec-writer` | Base NL→código |
| `engineering/spec-writer-pedagogical` | teaching + audience/junior |
| `engineering/tech-advisor` | Protocol collaborative |
| `engineering/implementer-claude` | Runtime Claude + code-execution + autonomous |
| `engineering/implementer-ollama` | Runtime Ollama + model hint codellama |
| `engineering/implementer-crewai` | Runtime CrewAI + code-execution |
| `engineering/reviewer` | Protocol collaborative |
| `engineering/reviewer-correctness` | 3 técnicas correctness |
| `engineering/reviewer-junior` | audience/junior + teaching |
| `engineering/documenter` | maintainability/documentation-standards |
| `engineering/frontend-dev` | Base frontend |
| `engineering/tech-estimator` | Base estimación |
| `engineering/tech-estimator-agile` | knowledge/management-basics |
| `content/doc-writer` | Base documentación |
| `content/doc-writer-official-sources` | official-docs-only + depth/deep |
| `content/doc-writer-junior` | audience/junior + teaching |
| `content/ops-procedures` | internal-only |
| `content/content-auditor` | Base auditoría contenido |
| `content/content-auditor-seo` | depth/deep + inject criterios SEO |
| `content/clickbait-writer` | Base titulares/engagement |
| `content/copywriter-deep` | depth/deep + inject SEO |
| `content/copywriter-marketing` | depth/deep |
| `design/web-designer` | Base diseño web |
| `design/web-with-eng` | knowledge engineering-basics + security-awareness |
| `design/ux-researcher` | Base investigación UX |
| `design/ux-researcher-accessibility` | design-basics + inject WCAG/accesibilidad |
| `business/presales` | Base presales |
| `business/presales-research` | Capabilities + sources |
| `business/presales-fintech` | industry/fintech + official-docs-only |
| `business/market-researcher` | web-search |
| `business/trend-analyst` | web-search |
| `business/content-strategist` | web-search |
| `management/project-manager` | Base planificación |
| `management/project-manager-executive` | audience/executive |

### Crear un alma nueva

Crea un archivo con extensión `.alma.yaml` en `almas/<disciplina>/` (ej. `almas/engineering/mi-auditoria.alma.yaml`):

```yaml
id: alma.engineering.mi-alma
type: alma
name: "Mi Alma Personalizada"
version: 1.0.0
description: "Descripción de lo que hace"
tags: [engineering, audit]

compose:
  discipline: engineering
  role: audit/0001_security/_index
  techniques:
    - security/injection-analysis
  modifiers:
    - depth/deep
```

Ver `almas/_schema.yaml` para el esquema completo.

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
| ------- | ------------ | ------ | ------ | ---------- |
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
| ----------- | --- |
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
# Output: layers/02_disciplines/engineering/06_roles/audit/06_compliance/_index.md
```

---

## Guía por plataforma

### Claude (claude.ai / API)

1. Genera el prompt: `make compose DISC=engineering ADAPTER=python ROLE=audit/0001_security/_index`
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
RUNTIME=ollama make compose DISC=engineering ADAPTER=python ROLE=audit/0001_security/_index

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

## Si algo falla

- **"Error: DISC requerido" / "ADAPTER requerido" / "ROLE requerido"**: La composición básica exige `DISC`, `ADAPTER` y `ROLE`. Con almas, solo hace falta `ALMA` y `ADAPTER`. Ver [migration-guide.md](docs/migration-guide.md) si vienes de una versión antigua.
- **Rol o adaptador no encontrado**: Comprueba que el path del rol sea relativo a `layers/02_disciplines/<disc>/06_roles/` (ej. `audit/0001_security/_index`) y que el adaptador exista en `layers/02_disciplines/<disc>/03_adapters/<adapter>.md`. Usa `make list-roles DISC=engineering` y `make list-adapters DISC=engineering`.
- **Alma no encontrada**: El nombre del alma es la ruta relativa a `almas/` sin extensión (ej. `v02/security-deep`, `engineering/security-fintech`). Lista almas con `make list-almas`.
- **Validación**: Ejecuta `make validate` para comprobar front-matter, referencias y disciplinas; `make validate-almas` para validar solo las almas (requiere `yq`).

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
