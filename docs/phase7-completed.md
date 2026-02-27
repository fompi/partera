# Fase 7: Runtimes, Tools, Patterns — Completada

## Resumen

Fase 7 implementa las capas de integración con plataformas específicas: runtimes, tool schemas JSON, tool wrappers, y patterns de razonamiento.

---

## Artefactos creados

### Runtimes (7) — `runtimes/`

| ID | Nombre | Categoría | Tool Calling | System Prompt | Context |
|----|--------|-----------|:------------:|:-------------:|---------|
| `runtime.claude` | Claude (Anthropic) | direct | ✓ | ✓ | 200k |
| `runtime.openai` | OpenAI (GPT-4o) | direct | ✓ | ✓ | 128k |
| `runtime.gemini` | Google Gemini | direct | ✓ | ✓ | 1M |
| `runtime.ollama` | Ollama (Local) | direct | — | ✓ | varies |
| `runtime.crewai` | CrewAI | framework | ✓ | ✓ | — |
| `runtime.langchain` | LangChain | framework | ✓ | ✓ | — |
| `runtime.autogen` | AutoGen (Microsoft) | framework | ✓ | ✓ | — |

### Tool Schemas JSON (6) — `tools/schemas/`

| Archivo | Herramienta | Capability |
|---------|-------------|-----------|
| `web_search.json` | `web_search` | web-search |
| `code_execution.json` | `execute_code` | code-execution |
| `image_analysis.json` | `analyze_image` | vision |
| `file_read.json` | `read_file` | file-analysis |
| `calculator.json` | `calculate` | — |
| `diagram_render.json` | `render_diagram` | — |

Todos los schemas usan formato Anthropic (`input_schema`). Para convertir a OpenAI, renombrar `input_schema` → `parameters`.

### Tool Wrappers (3 + README) — `tools/wrappers/`

- `web_search.sh` — DuckDuckGo CLI o Tavily API
- `image_analysis.py` — Claude Vision (base64)
- `README.md` — Instalación, uso y guía de extensión

### Patterns de razonamiento (6) — `patterns/`

| ID | Nombre | Aplicable a |
|----|--------|-------------|
| `pattern.react` | ReAct (Reason + Act) | all-roles |
| `pattern.cot` | Chain of Thought | all-roles |
| `pattern.tot` | Tree of Thoughts | planning, architecture, design |
| `pattern.toolformer` | Toolformer | all-roles (con tools) |
| `pattern.reflection` | Reflection | audit, review, quality |
| `pattern.plan-and-solve` | Plan-and-Solve | generate, plan, architecture |

---

## Modificaciones

### `compose.sh` — Soporte `RUNTIME` / `--runtime`

Nueva variable: `RUNTIME` (env) o flag `--runtime <nombre>`

- Lee `runtimes/<runtime>.md` y lo añade al final del prompt compuesto
- Verifica compatibilidad de capabilities: warning si el rol requiere capability no nativa en el runtime
- Compatible con env var `RUNTIME=` y flag `--runtime`

**Orden de composición actualizado**:
```
base universal → disc base → adapter → knowledge → rol → técnicas →
modifiers → sources → protocols → capabilities → [runtime]
```

### `Makefile` — Targets runtime-specific y nuevos

**Nuevos targets**:
```
runtime-claude     Compone con instrucciones runtime Claude
runtime-openai     Compone con instrucciones runtime OpenAI
runtime-gemini     Compone con instrucciones runtime Gemini
runtime-ollama     Compone con instrucciones runtime Ollama
runtime-crewai     Compone con instrucciones runtime CrewAI
runtime-langchain  Compone con instrucciones runtime LangChain
runtime-autogen    Compone con instrucciones runtime AutoGen
generate-crewai    Genera código Python de CrewAI desde un rol
list-runtimes      Lista runtimes disponibles
list-patterns      Lista patterns de razonamiento disponibles
```

### `scripts/generate_crewai.sh` — Generador de código CrewAI

Lee el front-matter de un rol y genera código Python listo para usar con CrewAI.

---

## Ejemplos de uso

### Componer con runtime

```bash
# Runtime Claude
DISC=engineering RUNTIME=claude ./compose.sh python generate/02_implementer/_index

# Runtime Gemini via make
make runtime-gemini DISC=engineering ADAPTER=python ROLE=audit/01_security/_index

# Runtime Ollama (advertirá si el rol requiere tool calling)
DISC=engineering RUNTIME=ollama ./compose.sh python audit/01_security/_index
```

### Incluir pattern en composición

```bash
# ReAct para auditoría de seguridad
DISC=engineering EXT="patterns/react" ./compose.sh python audit/01_security/_index

# CoT + reflection para revisión profunda
DISC=engineering EXT="patterns/cot patterns/reflection" ./compose.sh python audit/01_security/_index

# Plan-and-Solve para generación de código
DISC=engineering EXT="patterns/plan-and-solve" ./compose.sh python generate/02_implementer/_index
```

### Runtime + Pattern combinados

```bash
DISC=engineering RUNTIME=claude EXT="patterns/react" ./compose.sh python audit/01_security/_index
```

### Generar código CrewAI

```bash
./scripts/generate_crewai.sh engineering python generate/02_implementer/_index > implementer_agent.py
make generate-crewai DISC=engineering ADAPTER=python ROLE=generate/02_implementer/_index
```

### Validar schemas JSON

```bash
for schema in tools/schemas/*.json; do
  jq . "$schema" > /dev/null && echo "OK: $schema"
done
```

### Listar recursos

```bash
make list-runtimes
make list-patterns
```

---

## Compatibilidad runtime-capability

| Runtime | vision | web-search | code-execution | file-analysis |
|---------|:------:|:----------:|:--------------:|:-------------:|
| Claude | ✓ | ✓ | ✓ | ✓ |
| OpenAI | ✓ | — | ✓ | ✓ |
| Gemini | ✓ | — | — | ✓ |
| Ollama | wrapper | — | — | — |
| CrewAI | all | all | all | all |
| LangChain | all | all | all | all |
| AutoGen | all | all | all | all |

`compose.sh` emite `Warning:` si el rol requiere capability no nativa en el runtime seleccionado.

---

## Siguiente fase

**Fase 8** (propuesta): Testing automatizado, CI/CD integration, y métricas de calidad de prompts.
