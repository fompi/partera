# audit-prompts

> Prompts componibles para auditoría técnica de código con LLMs.
>
> Última actualización: febrero 2026

## Qué es esto

Un sistema modular de prompts de auditoría que se compone en tres capas:

```
_base_audit.md  →  Contrato universal (anti-alucinación, CoT, plantilla de hallazgo)
  + lang/*.md   →  Adaptador idiomático (Python, Bash, ...)
    + 0N_role   →  Rol funcional (seguridad, rendimiento, ...)
```

Funciona con cualquier LLM: Claude, ChatGPT, Gemini, Ollama, Antigravity, Cursor,
o cualquier API compatible OpenAI.

## Instalación

```bash
# Clonar
git clone https://github.com/<tu-usuario>/audit-prompts.git
cd audit-prompts

# Requisitos: bash, make, jq (solo para targets de API)
# macOS:
brew install jq
# Debian/Ubuntu:
sudo apt install jq make
# Windows (WSL):
sudo apt install jq make
```

No tiene dependencias de runtime. Los prompts son texto plano.

## Uso con tu proyecto

Hay tres formas de usar `audit-prompts` con un proyecto:

**A) Desde fuera (recomendado)**: clona el repo en cualquier sitio y apunta a tu proyecto.

```bash
# Clonar una vez
git clone https://github.com/<tu-usuario>/audit-prompts.git ~/audit-prompts

# Usar desde cualquier proyecto
cd ~/audit-prompts
make claude LANG=python ROLE=01_security/_index CODE=~/my-project/src/
make cursor LANG=python ROLE=03_architecture PROJECT=~/my-project
```

**B) Como subdirectorio**: clona dentro del proyecto para tener todo junto.

```bash
cd ~/my-project
git clone https://github.com/<tu-usuario>/audit-prompts.git audit-prompts
# O como submodule:
git submodule add https://github.com/<tu-usuario>/audit-prompts.git audit-prompts

# Usar
cd audit-prompts && make claude LANG=python ROLE=01_security/_index CODE=../src/
```

**C) Como Skill instalado**: para IDEs agent-first (Cursor, Antigravity).

```bash
cd ~/audit-prompts
make cursor LANG=python ROLE=01_security/_index PROJECT=~/my-project
make antigravity LANG=python ROLE=01_security/_index PROJECT=~/my-project
```

---

## Quick Start

```bash
# Componer y copiar al portapapeles
./compose.sh python 01_security/_index --clipboard

# Componer y redirigir a fichero
./compose.sh bash 03_architecture > /tmp/audit_prompt.md

# Usar el Makefile (recomendado)
make compose LANG=python ROLE=01_security/_index
make claude  LANG=python ROLE=01_security/_index CODE=~/my-project/src/
make ollama  LANG=bash   ROLE=04_correctness/_index CODE=~/my-project/scripts/
```

---

## Estructura del repositorio

```
.
├── README.md                          ← este fichero
├── Makefile                           ← automatización multiplataforma
├── compose.sh                         ← ensamblador de prompts
├── .gitignore
├── _base_audit.md                     ← contrato universal
├── 00_orchestrator.md                 ← mapa + triage + síntesis
├── 01_security/                       ← auditoría de seguridad
│   ├── _index.md                      ← modo quick (1 pass)
│   ├── 01a_injection_surfaces.md      ← inyección, path traversal, SSRF
│   ├── 01b_auth_access_control.md     ← auth, sesiones, IDOR
│   ├── 01c_secrets_crypto.md          ← secretos, criptografía
│   └── 01d_supply_chain.md            ← dependencias, CVEs
├── 02_performance/                    ← auditoría de rendimiento
│   ├── _index.md                      ← modo quick
│   ├── 02a_algorithmic_complexity.md  ← Big-O, estructuras de datos
│   ├── 02b_io_network_concurrency.md  ← I/O, N+1, async, locks
│   └── 02c_memory_resources.md        ← memoria, leaks, caching
├── 03_architecture.md                 ← arquitectura (no subdividido)
├── 04_correctness/                    ← caza de bugs y edge cases
│   ├── _index.md                      ← modo quick
│   ├── 04a_edge_cases_contracts.md    ← contratos, boundaries
│   ├── 04b_concurrency_state.md       ← race conditions, deadlocks
│   └── 04c_error_handling.md          ← errores silenciosos, recovery
├── 05_quality/                        ← calidad y DX
│   ├── _index.md                      ← modo quick
│   ├── 05a_testing_quality.md         ← calidad de tests
│   ├── 05b_observability_ops.md       ← logging, métricas, tracing
│   └── 05c_code_maintainability.md    ← duplicación, naming, docs
├── lang/                              ← adaptadores idiomáticos
│   ├── python.md
│   └── bash.md
└── _archive/                          ← prompts originales (histórico)
```

---

## Modos de uso

| Modo | Cuándo usarlo | Composición | Passes |
|------|---------------|-------------|--------|
| Triage rápido | Evaluar un repo nuevo | base + lang + `00_orchestrator` | 1 |
| Auditoría dirigida | Foco en un área concreta | base + lang + `0N_role/_index` | 1 |
| Deep-dive | Máxima profundidad en un sub-área | base + lang + `0N_role/0Na_subtask` | 1 por subtask |
| Auditoría completa | Revisión exhaustiva | Orchestrator primero, luego cada rol | 6-15 |

### Por tamaño de codebase

- **< 500 líneas**: triage rápido o auditoría dirigida.
- **500 – 5K líneas**: roles completos (`_index.md`); subtasks para security y quality.
- **> 5K líneas**: subtasks para todo; seccionar el codebase por módulo/dominio.

---

## Ejemplos detallados por escenario

### Escenario 1: Triage rápido de un proyecto Python desconocido

Objetivo: entender la arquitectura y decidir qué auditar primero.

```bash
make compose LANG=python ROLE=00_orchestrator > /tmp/triage.md
```

Resultado del prompt compuesto (~220 líneas, ~3.500 tokens):

```
[_base_audit.md]     — principios, CoT, plantilla de hallazgo
---
[lang/python.md]     — detección de versión, PEPs, tooling Python
---
[00_orchestrator.md] — mapeo, superficies de riesgo, triage, plan por fases
```

Cómo usarlo: pega el prompt como system/instrucción + el código en el chat.
El modelo devuelve: resumen ejecutivo, diagrama de arquitectura, matriz de triage
recomendando qué roles activar, y top 10 acciones priorizadas.

### Escenario 2: Auditoría de seguridad dirigida de una API FastAPI

Objetivo: 1 pass rápido de seguridad sobre todos los endpoints.

```bash
make compose LANG=python ROLE=01_security/_index > /tmp/security.md
```

Resultado (~192 líneas, ~3.000 tokens). El modelo busca inyecciones, auth débil,
secretos expuestos y dependencias vulnerables en un solo pass.

### Escenario 3: Deep-dive de inyección en una app Django

Objetivo: rastrear todos los flujos de datos contaminados (tainted input → sinks).

```bash
make compose LANG=python ROLE=01_security/01a_injection_surfaces > /tmp/injection.md
```

Resultado (~186 líneas, ~2.800 tokens). Prompt enfocado exclusivamente en inyección:
SQL, comandos, templates, path traversal, SSRF, deserialización. Traza flujos
taint desde entry points hasta sinks con evaluación de saneamiento.

### Escenario 4: Análisis de rendimiento de scripts Bash de CI/CD

```bash
make compose LANG=bash ROLE=02_performance/_index > /tmp/perf_bash.md
```

Resultado (~222 líneas). El adaptador Bash inyecta conocimiento específico:
builtins vs externos, subshells innecesarias, `find -exec +` vs `xargs`,
paralelismo con `&` + `wait`. El rol de rendimiento añade la metodología
de hotspots, Big-O y trade-offs.

### Escenario 5: Auditoría completa de un proyecto Python

6 passes secuenciales, cada uno con un rol distinto:

```bash
# Generar todos los prompts de golpe
make full-audit LANG=python CODE=~/my-project/src/ PLATFORM=claude

# Ejecutar uno a uno (o en paralelo si el modelo lo permite)
make claude LANG=python ROLE=00_orchestrator           CODE=~/my-project/src/
make claude LANG=python ROLE=01_security/_index        CODE=~/my-project/src/
make claude LANG=python ROLE=02_performance/_index     CODE=~/my-project/src/
make claude LANG=python ROLE=03_architecture           CODE=~/my-project/src/
make claude LANG=python ROLE=04_correctness/_index     CODE=~/my-project/src/
make claude LANG=python ROLE=05_quality/_index         CODE=~/my-project/src/
```

### Escenario 6: Deep-dive de seguridad completo (4 passes)

Para un codebase mediano-grande donde quieres máxima profundidad:

```bash
make claude LANG=python ROLE=01_security/01a_injection_surfaces    CODE=~/my-project/src/
make claude LANG=python ROLE=01_security/01b_auth_access_control   CODE=~/my-project/src/
make claude LANG=python ROLE=01_security/01c_secrets_crypto        CODE=~/my-project/src/
make claude LANG=python ROLE=01_security/01d_supply_chain          CODE=~/my-project/src/
```

Cada pass se enfoca en un modelo mental distinto:
- `01a`: rastreo de flujos de datos contaminados (taint analysis).
- `01b`: mapeo de fronteras de autenticación y verificación de enforcement.
- `01c`: scan de patrones de secretos + evaluación de elecciones criptográficas.
- `01d`: revisión de dependencias, lockfiles, versiones pinned.

### Escenario 7: Instalar como Skill en Antigravity

```bash
make antigravity LANG=python ROLE=01_security/_index
```

Genera `.agent/skills/audit-01_security/SKILL.md` con frontmatter YAML
compatible con [SKILL.md spec](https://www.mdskills.ai/specs/skill-md).
Antigravity, Cursor, Claude Code y Gemini CLI lo detectan automáticamente.

### Escenario 8: Estimar consumo de tokens antes de ejecutar

```bash
make token-estimate LANG=python ROLE=01_security/_index
```

Salida:

```
Prompt compuesto: python + 01_security/_index
  Líneas:          192
  Caracteres:      7640
  Tokens (est.):   ~1910

Contexto restante por modelo:
  Claude Opus/Sonnet 4.6 (200K):  ~198090 tokens libres
  Claude 4.6 beta (1M):           ~998090 tokens libres
  GPT-5.2 (400K):                 ~398090 tokens libres
  Gemini 3.1 Pro (1M):            ~998090 tokens libres
```

---

## Guía por plataforma

### Claude (Anthropic)

**Modelos actuales** (feb 2026):

| Modelo | Contexto | Input/1M tokens | Output/1M tokens | Mejor para |
|--------|----------|-----------------|-------------------|------------|
| [Claude Opus 4.6](https://www.anthropic.com/claude/opus) | 200K (1M beta) | $5.00 | $25.00 | Security, architecture — mayor tasa de remediación ([60% fix rate](https://ofriperetz.dev/articles/we-ranked-5-ai-models-by-security-the-leaderboard-is-wrong)) |
| [Claude Sonnet 4.6](https://claudefa.st/blog/models/claude-sonnet-4-6) | 200K (1M beta) | $3.00 | $15.00 | Mejor relación calidad/coste — [preferido sobre Opus 4.5 en 59% de tareas de código](https://claudefa.st/blog/models/claude-sonnet-4-6) |
| [Claude Haiku 4.6](https://docs.anthropic.com/en/docs/about-claude/models) | 200K | $0.80 | $4.00 | Pre-screening rápido — [menor tasa de vulnerabilidad global (49%)](https://ofriperetz.dev/articles/we-ranked-5-ai-models-by-security-the-leaderboard-is-wrong) |

Sonnet 4.6 es la opción por defecto. Para auditorías de seguridad críticas,
Opus 4.6 tiene el mayor fix rate de la industria. Ambos soportan
[prompt caching](https://docs.anthropic.com/en/docs/build-with-claude/prompt-caching)
(90% ahorro en lecturas cacheadas) y [batch API](https://docs.anthropic.com/en/docs/build-with-claude/batch-processing)
(50% descuento).

**Web** ([claude.ai](https://claude.ai)):

1. Crea un **Proyecto** → Settings → Custom Instructions.
2. Pega el prompt compuesto como instrucción del proyecto.
3. Sube los ficheros del codebase al proyecto (drag & drop).
4. En el chat: *"Ejecuta la auditoría según las instrucciones del proyecto."*

**API**:

```bash
make claude LANG=python ROLE=01_security/_index CODE=~/my-project/src/
```

**Docs**: [docs.anthropic.com/en/api](https://docs.anthropic.com/en/api) |
[Pricing](https://www.anthropic.com/pricing)

---

### ChatGPT / OpenAI

**Modelos actuales** (feb 2026):

| Modelo | Contexto | Input/1M tokens | Output/1M tokens | Mejor para |
|--------|----------|-----------------|-------------------|------------|
| [GPT-5.2](https://platform.openai.com/docs/models/gpt-5.2) | 400K | $1.75 | $14.00 | Mejor precio/token en código, [74.9% SWE-bench](https://gitautoreview.com/blog/claude-vs-gemini-vs-chatgpt-code-review) |
| [GPT-5.2-Codex](https://platform.openai.com/docs/models/gpt-5.2-codex) | 400K | $1.75 | $14.00 | Variante optimizada para código |
| [o4-mini](https://platform.openai.com/docs/models) | 200K | $4.00 | $16.00 | Razonamiento profundo (chain-of-thought) para security |

GPT-5.2 ofrece el input más barato ($1.75/M) entre los modelos frontier,
con ventana de 400K tokens — la más grande entre los no-Gemini.

**Web** ([chatgpt.com](https://chatgpt.com)):

1. Crea un **Proyecto** → pega el prompt compuesto en las instrucciones.
2. Sube ficheros o pega código en el chat.
3. Escribe: *"Ejecuta la auditoría."*

**API**:

```bash
make chatgpt LANG=python ROLE=02_performance/_index CODE=~/my-project/src/
```

**Docs**: [platform.openai.com/docs](https://platform.openai.com/docs) |
[Pricing](https://openai.com/api/pricing)

---

### Gemini (Google)

**Modelos actuales** (feb 2026):

| Modelo | Contexto | Input/1M tokens | Output/1M tokens | Mejor para |
|--------|----------|-----------------|-------------------|------------|
| [Gemini 3.1 Pro](https://ai.google.dev/gemini-api/docs) | **1M** | $2.00 (≤200K) / $4.00 (>200K) | $12.00 / $18.00 | Codebases enormes sin seccionar — [77.4% SWE-bench (líder)](https://gitautoreview.com/blog/claude-vs-gemini-vs-chatgpt-code-review) |
| Gemini 3.1 Flash | 1M | $0.15 | $0.60 | Pre-screening masivo a coste mínimo |

Gemini 3.1 Pro lidera [SWE-bench Verified](https://www.swebench.com/) con 77.4%
y tiene el contexto más grande (1M tokens = ~50K líneas de código de golpe).
Ideal para `03_architecture` donde la visión holística importa.
[Thinking tokens](https://ai.google.dev/gemini-api/docs/thinking) (CoT interno)
se facturan como output — tenerlo en cuenta en el coste.

**AI Studio** ([aistudio.google.com](https://aistudio.google.com)):

1. Crea un nuevo prompt → System Instructions → pega el prompt compuesto.
2. Sube ficheros (soporta carga masiva).
3. Ejecuta.

**API**:

```bash
make gemini LANG=python ROLE=03_architecture CODE=~/my-project/src/
```

**Docs**: [ai.google.dev/gemini-api/docs](https://ai.google.dev/gemini-api/docs) |
[Pricing](https://ai.google.dev/gemini-api/docs/pricing)

---

### Antigravity (Google)

[Antigravity](https://antigravity.codes/) es el IDE agent-first de Google.
Los agentes operan autónomamente sobre editor, terminal y navegador, generando
[Artifacts](https://www.gend.co/blog/google-antigravity) (planes, diffs,
screenshots) que puedes revisar y comentar.

**Integración via Skills** ([SKILL.md spec](https://www.mdskills.ai/specs/skill-md)):

```bash
make antigravity LANG=python ROLE=01_security/_index
```

Genera un Skill en `.agent/skills/` con frontmatter YAML. Antigravity lo
detecta automáticamente y lo activa cuando el usuario pide auditar código.
El formato SKILL.md es compatible con [27+ agentes](https://www.mdskills.ai/specs/skill-md)
incluyendo Cursor, Claude Code, Codex, Gemini CLI y VS Code Copilot.

**Uso directo** (sin Skill):

1. Abre Antigravity y carga el repositorio.
2. En el Manager, crea una tarea y pega el prompt compuesto como instrucción.
3. El agente planifica, ejecuta y genera Artifacts con los hallazgos.

**Modelo por defecto**: Gemini 3 Pro (con soporte opcional para Claude y GPT).

**Docs**: [antigravity.codes/tutorial](https://antigravity.codes/tutorial) |
[Skills](https://codelabs.developers.google.com/getting-started-with-antigravity-skills)

---

### Cursor

**Como regla de proyecto** (persistente, recomendado):

```bash
# Instala la regla en el proyecto que quieras auditar
make cursor LANG=python ROLE=01_security/_index PROJECT=~/my-project
```

Genera `~/my-project/.cursor/rules/audit_01_security.md` con el prompt compuesto.
La regla se activa automáticamente cuando abres ese proyecto en Cursor.

**Como prompt ad-hoc** (en el chat):

Si clonaste `audit-prompts` dentro del proyecto (ej: como `audit-prompts/`):

```
Siguiendo las instrucciones de @audit-prompts/_base_audit.md
y @audit-prompts/lang/python.md y @audit-prompts/01_security/_index.md,
audita @src/
```

O si lo prefieres, compón el prompt con `make compose` y pégalo directamente.

**Auditoría completa en Cursor** (6 prompts secuenciales):

```
@audit-prompts/_base_audit.md @audit-prompts/lang/python.md @audit-prompts/00_orchestrator.md
Haz triage de @src/ e indica qué roles activar.
```

Luego, para cada rol que recomiende el orchestrator:

```
@audit-prompts/_base_audit.md @audit-prompts/lang/python.md @audit-prompts/01_security/_index.md
Audita la seguridad de @src/
```

---

### Herramientas open-source

#### Ollama (Linux, Mac, Windows)

[Ollama](https://ollama.com/) ejecuta modelos localmente. Sin APIs, sin coste
por token, sin enviar código a terceros.

```bash
# Instalar
# Linux/Mac:
curl -fsSL https://ollama.com/install.sh | sh
# Windows: descargar desde https://ollama.com/download

# Descargar modelo
ollama pull qwen2.5-coder:32b

# Ejecutar auditoría directamente
make ollama LANG=python ROLE=01_security/_index CODE=~/my-project/src/
```

**Modelos recomendados para Ollama** (feb 2026):

| Modelo | Ollama tag | Params activos | VRAM (Q4) | HumanEval | Notas |
|--------|-----------|----------------|-----------|-----------|-------|
| [Qwen 2.5 Coder 32B](https://ollama.com/library/qwen2.5-coder:32b) | `qwen2.5-coder:32b` | 32B | 20 GB | [92%](https://localaimaster.com/blog/best-open-source-llms-2026) | Mejor relación calidad/tamaño para auditoría |
| [DeepSeek V3.2](https://ollama.com/library/deepseek-v3) | `deepseek-v3:32b` | 37B (MoE) | 22 GB | [89.4%](https://whatllm.org/blog/best-open-source-models-february-2026) | Excelente en razonamiento — [líder LiveCodeBench](https://whatllm.org/blog/best-open-source-models-february-2026) |
| [DeepSeek R1 32B](https://ollama.com/library/deepseek-r1:32b) | `deepseek-r1:32b` | 32B | 20 GB | — | Chain-of-thought largo, ideal para security deep-dive |
| [Llama 4 Scout](https://ollama.com/library/llama4:scout) | `llama4:scout` | 17B (MoE 109B) | 12 GB | — | Contexto de [10M tokens](https://www.gocodeo.com/post/llama-4-models-architecture-benchmarks-more) — repos completos |
| [Qwen 2.5 Coder 7B](https://ollama.com/library/qwen2.5-coder:7b) | `qwen2.5-coder:7b` | 7B | 6 GB | 84% | Para hardware limitado (<16 GB RAM) |

Guía de selección:
- **GPU con 24+ GB VRAM**: Qwen 2.5 Coder 32B (mejor calidad general).
- **GPU con 12-16 GB VRAM**: Llama 4 Scout (MoE eficiente, contexto masivo).
- **Solo CPU / <16 GB RAM**: Qwen 2.5 Coder 7B (calidad menor pero funcional).
- **Security deep-dive**: DeepSeek R1 32B (razonamiento extendido tipo CoT).

#### llm (Simon Willison)

[llm](https://llm.datasette.io/) es un CLI multi-backend que abstrae
la diferencia entre APIs y modelos locales.

```bash
pip install llm

# Plugins de backend
llm install llm-claude-3     # Anthropic
llm install llm-gemini        # Google
llm install llm-ollama         # modelos locales via Ollama

# Auditoría con Claude
PROMPT=$(./compose.sh python 03_architecture)
cat ~/my-project/src/*.py | llm -s "$PROMPT" -m claude-sonnet-4.6

# Auditoría con modelo local
cat ~/my-project/src/*.py | llm -s "$PROMPT" -m qwen2.5-coder:32b

# Guardar resultado
cat ~/my-project/src/*.py | llm -s "$PROMPT" -m claude-sonnet-4.6 > audit_architecture.md
```

**Docs**: [llm.datasette.io](https://llm.datasette.io/) |
[Plugins](https://llm.datasette.io/en/stable/plugins/directory.html)

#### aider

[aider](https://aider.chat/) es un asistente de código con integración git.
Útil para aplicar las correcciones que proponga la auditoría directamente.

```bash
pip install aider-chat

# Auditoría read-only
PROMPT=$(./compose.sh python 01_security/_index)
cd ~/my-project
PROMPT=$(~/audit-prompts/compose.sh python 01_security/_index)
aider --message "$PROMPT — Audita los ficheros del proyecto." \
  --no-auto-commits \
  --model anthropic/claude-sonnet-4.6 \
  src/*.py

# Aplicar correcciones (modo escritura)
aider --message "Aplica las correcciones SEC-001 y SEC-002 del informe anterior." \
  --model anthropic/claude-sonnet-4.6 \
  src/auth.py src/api.py
```

**Docs**: [aider.chat/docs](https://aider.chat/docs/)

#### Open WebUI + LM Studio

Para quienes prefieren interfaz gráfica:

**[Open WebUI](https://docs.openwebui.com/)** (web local con Docker):

```bash
docker run -d -p 3000:8080 \
  --add-host=host.docker.internal:host-gateway \
  -v open-webui:/app/backend/data \
  ghcr.io/open-webui/open-webui:main
# Abrir http://localhost:3000, crear Model File con el prompt compuesto
```

**[LM Studio](https://lmstudio.ai/)** (GUI nativa Linux/Mac/Windows):

1. Descargar e instalar.
2. Buscar `Qwen2.5-Coder-32B-Instruct` (GGUF).
3. En Chat → System Prompt: pegar output de `make compose`.
4. También expone API compatible OpenAI en `http://localhost:1234/v1`.

#### curl directo (API genérica OpenAI-compatible)

Funciona con cualquier proveedor que exponga la interfaz
[OpenAI Chat Completions](https://platform.openai.com/docs/api-reference/chat):

```bash
PROMPT=$(./compose.sh bash 04_correctness/_index)
API_BASE="http://localhost:1234/v1"          # LM Studio local
# API_BASE="http://localhost:11434/v1"       # Ollama (modo API)
# API_BASE="https://api.together.xyz/v1"     # Together AI
# API_BASE="https://api.groq.com/openai/v1"  # Groq
# API_BASE="https://openrouter.ai/api/v1"    # OpenRouter (multi-modelo)

curl -s "$API_BASE/chat/completions" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d "$(jq -n \
    --arg system "$PROMPT" \
    --arg code "$(cat ~/my-project/deploy.sh)" \
    '{model: "qwen2.5-coder-32b",
      messages: [
        {role: "system", content: $system},
        {role: "user",
         content: ("Ejecuta la auditoría:\n\n" + $code)}]}')"
```

Proveedores recomendados:
- [Together AI](https://www.together.ai/) — modelos open-source en cloud, DeepSeek V3.2 disponible.
- [Groq](https://groq.com/) — inferencia ultra-rápida en hardware LPU, ideal para passes múltiples.
- [OpenRouter](https://openrouter.ai/) — broker multi-modelo, útil para comparar resultados entre modelos.

---

## Modelos recomendados por rol (feb 2026)

### Modelos de pago

| Rol | Modelo recomendado | Alternativa | Por qué |
|-----|-------------------|-------------|---------|
| 00 Orchestrator | [Claude Sonnet 4.6](https://claudefa.st/blog/models/claude-sonnet-4-6) ($3/$15) | Gemini 3.1 Pro | Visión holística + buena relación coste/calidad |
| 01 Security | [Claude Opus 4.6](https://www.anthropic.com/claude/opus) ($5/$25) | o4-mini | [Mayor fix rate (60%)](https://ofriperetz.dev/articles/we-ranked-5-ai-models-by-security-the-leaderboard-is-wrong), menor tasa de error en control flow [(55/M líneas)](https://gitautoreview.com/blog/claude-vs-gemini-vs-chatgpt-code-review) |
| 02 Performance | [GPT-5.2](https://platform.openai.com/docs/models/gpt-5.2) ($1.75/$14) | Claude Sonnet 4.6 | Input más barato, contexto de 400K para trazar I/O entre módulos |
| 03 Architecture | [Gemini 3.1 Pro](https://ai.google.dev/gemini-api/docs) ($2/$12) | Claude Opus 4.6 (1M beta) | 1M tokens nativos = repo completo sin seccionar, [77.4% SWE-bench](https://gitautoreview.com/blog/claude-vs-gemini-vs-chatgpt-code-review) |
| 04 Correctness | [Claude Sonnet 4.6](https://claudefa.st/blog/models/claude-sonnet-4-6) ($3/$15) | GPT-5.2 | Razonamiento adversarial de calidad con coste moderado |
| 05 Quality/DX | [GPT-5.2](https://platform.openai.com/docs/models/gpt-5.2) ($1.75/$14) | Gemini 3.1 Flash ($0.15/$0.60) | Menos exigente cognitivamente; Flash para pre-screening masivo |

**Benchmarks de referencia** (feb 2026):

| Modelo | [SWE-bench Verified](https://www.swebench.com/) | [HumanEval](https://github.com/openai/human-eval) | Contexto | Vuln. rate ([700 funciones](https://ofriperetz.dev/articles/we-ranked-5-ai-models-by-security-the-leaderboard-is-wrong)) |
|--------|------------|-----------|----------|------------|
| Gemini 3.1 Pro | **77.4%** | 91% | 1M | 58% |
| Claude Opus 4.6 | 76.8% | 93% | 200K-1M | 52% |
| Claude Sonnet 4.6 | 75.2% | 92% | 200K-1M | 54% |
| GPT-5.2 | 74.9% | 90% | 400K | 61% |
| Claude Haiku 4.6 | 68% | 85% | 200K | **49%** |

Nota: [ambos Opus 4.6 y Gemini 3 Pro puntúan 95/100 en tests de ataque,
pero fallan en categorías diferentes](https://www.pwnclaw.com/blog/frontier-models-same-score-different-blindspots) —
usar ambos en paralelo maximiza cobertura.

### Modelos open-source (Ollama / local)

| Rol | Modelo recomendado | VRAM mínima | Por qué |
|-----|--------------------|-------------|---------|
| 00 Orchestrator | [Qwen 2.5 Coder 32B](https://ollama.com/library/qwen2.5-coder:32b) | 20 GB | [92% HumanEval](https://localaimaster.com/blog/best-open-source-llms-2026), supera GPT-4o |
| 01 Security | [DeepSeek R1 32B](https://ollama.com/library/deepseek-r1:32b) | 20 GB | CoT extendido para rastreo de flujos de datos |
| 02 Performance | Qwen 2.5 Coder 32B | 20 GB | Algorítmica bien cubierta |
| 03 Architecture | [Llama 4 Scout](https://ollama.com/library/llama4:scout) | 12 GB | [10M tokens de contexto](https://www.gocodeo.com/post/llama-4-models-architecture-benchmarks-more) = repo completo |
| 04 Correctness | [DeepSeek V3.2 32B](https://ollama.com/library/deepseek-v3) | 22 GB | [Líder LiveCodeBench](https://whatllm.org/blog/best-open-source-models-february-2026) |
| 05 Quality/DX | [Qwen 2.5 Coder 7B](https://ollama.com/library/qwen2.5-coder:7b) | 6 GB | Suficiente para calidad/DX, corre en cualquier máquina |

### Coste estimado de una auditoría completa

6 passes (orchestrator + 5 roles quick) sobre un codebase de 3K líneas (~12K tokens de código):

| Plataforma | Modelo | Tokens input total | Tokens output est. | Coste total est. |
|------------|--------|--------------------|--------------------|-----------------|
| Claude | Sonnet 4.6 | ~80K | ~30K | **~$0.69** |
| Claude | Opus 4.6 | ~80K | ~30K | **~$1.15** |
| OpenAI | GPT-5.2 | ~80K | ~30K | **~$0.56** |
| Google | Gemini 3.1 Pro | ~80K | ~30K | **~$0.52** |
| Google | Gemini 3.1 Flash | ~80K | ~30K | **~$0.03** |
| Ollama | Qwen 2.5 Coder 32B | — | — | **$0.00** (local) |

---

## Makefile — referencia rápida

```bash
make help              # Muestra todos los targets y variables
make list-roles        # Lista roles y subtasks disponibles
make list-langs        # Lista adaptadores idiomáticos

make compose    LANG=<lang> ROLE=<rol>                    # Imprime prompt compuesto
make clipboard  LANG=<lang> ROLE=<rol>                    # Copia al portapapeles

make claude     LANG=<lang> ROLE=<rol> CODE=<ruta>              # Genera curl para Claude API
make chatgpt    LANG=<lang> ROLE=<rol> CODE=<ruta>              # Genera curl para OpenAI API
make gemini     LANG=<lang> ROLE=<rol> CODE=<ruta>              # Genera curl para Gemini API
make ollama     LANG=<lang> ROLE=<rol> CODE=<ruta>              # Ejecuta con Ollama local
make cursor     LANG=<lang> ROLE=<rol> PROJECT=<proyecto>       # Genera regla .cursor/rules/
make antigravity LANG=<lang> ROLE=<rol> PROJECT=<proyecto>      # Genera Skill .agent/skills/

make full-audit LANG=<lang> CODE=<ruta> PLATFORM=<plat>         # Auditoría completa (6 passes)
make token-estimate LANG=<lang> ROLE=<rol>                # Estima tokens del prompt
make clean                                                 # Limpia archivos generados
```

---

## Añadir un nuevo lenguaje

1. Crear `lang/<lenguaje>.md` siguiendo la estructura de `lang/python.md`.
2. Ningún otro fichero necesita cambios.
3. Usar: `make compose LANG=<lenguaje> ROLE=<rol>`.

## Añadir un nuevo rol

1. Crear `0N_<nombre>/` con `_index.md` y subtasks opcionales.
2. Seguir la estructura: Persona → Alcance → Metodología → Checklist.
3. Referenciar `_base_audit.md` para la plantilla de hallazgo (no duplicarla).
4. El Makefile lo detecta automáticamente.

---

## Requisitos

- **bash** (4.0+) — para `compose.sh` y el Makefile.
- **make** (GNU Make) — para el Makefile.
- **jq** — solo para los targets de API (`claude`, `chatgpt`, `gemini`).
- **Ollama** — solo para el target `ollama` (ejecución local).

En macOS todo viene instalado excepto `jq` (`brew install jq`).
En Windows, usar [WSL](https://learn.microsoft.com/en-us/windows/wsl/install).

## Licencia

MIT. Usa, modifica y redistribuye libremente.
