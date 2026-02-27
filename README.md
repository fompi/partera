# audit-prompts

> **En 30 segundos:** Este repositorio te da *instrucciones listas para usar* que le pasas a un asistente de IA (Claude, ChatGPT, Gemini, etc.) para que **revise tu código** como un experto: encuentra fallos de seguridad, problemas de rendimiento, bugs y mejoras. No necesitas saber escribir prompts: tú eliges *qué* auditar (seguridad, rendimiento, etc.) y *en qué lenguaje* (Python, Bash…), y el sistema monta la instrucción por ti.
>
> Última actualización: febrero 2026

---

## Índice

- [¿Para quién es esto?](#para-quién-es-esto)
- [Glosario mínimo](#glosario-mínimo-para-no-perderse)
- [Tu primer uso en 5 minutos](#tu-primer-uso-en-5-minutos)
- [Qué rol y qué lenguaje usar](#qué-rol-y-qué-lenguaje-usar)
- [Cómo sacar el máximo partido](#cómo-sacar-el-máximo-partido-rutas-de-uso)
- [Estructura del repositorio](#estructura-del-repositorio)
- [Auditoría de sistemas de prompts modulares](#auditoría-de-sistemas-de-prompts-modulares)
- [Guía por plataforma](#guía-por-plataforma) (Claude, ChatGPT, Gemini, Cursor, Ollama, etc.)
- [Automejora](#automejora-mejorar-y-ampliar-este-repositorio) (mejorar y ampliar los prompts del repo)
- [Preguntas frecuentes](#preguntas-frecuentes-y-problemas-habituales)
- [Resumen de comandos](#resumen-de-comandos-cheat-sheet)

---

## ¿Para quién es esto?

- **No sabes qué es un “prompt” ni un “LLM”** — Este README te explica todo desde cero y te lleva paso a paso.
- **Quieres que una IA revise tu código** — Usas Claude, ChatGPT, Cursor u otra; aquí tienes instrucciones profesionales para que la revisión sea útil y ordenada.
- **Eres desarrollador o tech lead** — Puedes hacer triage de un repo nuevo, auditorías de seguridad, de rendimiento o completas, y hasta mejorar los propios prompts del repo (automejora).

---

## Glosario mínimo (para no perderse)

| Término | Significado en este repo |
|--------|---------------------------|
| **LLM** | Modelo de lenguaje (ej. Claude, GPT, Gemini): el “cerebro” del asistente con el que hablas. |
| **Prompt** | El texto de instrucciones que le das al LLM. Aquí los prompts son *modulares*: se combinan por piezas. |
| **Auditoría (de código)** | Revisión sistemática del código para encontrar vulnerabilidades, bugs, malas prácticas o mejoras. |
| **Rol** | Tipo de auditoría: seguridad, rendimiento, arquitectura, correctitud, calidad, etc. Cada rol es un conjunto de instrucciones. |
| **LANG** | Lenguaje de programación del código que vas a auditar: `python`, `bash` (por ahora). El prompt se adapta al lenguaje. |
| **ROLE** | El rol concreto que usas en un comando, ej. `01_security/_index` (seguridad en un solo pass) o `00_orchestrator/_index` (mapa y triage). |
| **Componer** | Unir las piezas (base + lenguaje + rol) en un único texto listo para pegar en el asistente. |
| **Meta-prompt** | Un prompt que sirve para *mejorar o ampliar* el propio sistema de prompts (automejora). |

---

## Tu primer uso en 5 minutos

Objetivo: **generar una instrucción de auditoría y usarla en la web** (sin instalar nada más que este repo).

### Paso 1: Clonar e instalar lo mínimo

```bash
git clone https://github.com/<tu-usuario>/audit-prompts.git
cd audit-prompts
```

En **macOS** instala `jq` si no lo tienes (solo hace falta para algunas opciones avanzadas):

```bash
brew install jq
```

En **Linux** (Debian/Ubuntu):

```bash
sudo apt install jq make
```

En **Windows** usa [WSL](https://learn.microsoft.com/en-us/windows/wsl/install) y luego como en Linux.

### Paso 2: Generar el “prompt” y copiarlo al portapapeles

Ejemplo: **auditoría de seguridad para código Python**.

```bash
make clipboard LANG=python ROLE=01_security/_index
```

Verás algo como: `Copiado al portapapeles (XXX líneas)`. Ese texto es la instrucción completa.

### Paso 3: Usarlo en Claude o ChatGPT

- **Claude:** [claude.ai](https://claude.ai) → crea un Proyecto → en *Custom Instructions* pega lo que copiaste → en el chat sube o pega tu código y escribe: *“Ejecuta la auditoría según las instrucciones del proyecto.”*
- **ChatGPT:** [chatgpt.com](https://chatgpt.com) → crea un Proyecto → pega el prompt en las instrucciones → sube/pega código y escribe: *“Ejecuta la auditoría.”*

La IA te devolverá un informe con hallazgos (vulnerabilidades, recomendaciones, prioridades).

**Siguiente paso:** en [Qué rol y qué lenguaje usar](#qué-rol-y-qué-lenguaje-usar) tienes una tabla para elegir otro tipo de auditoría (rendimiento, arquitectura, etc.) y en [Cómo sacar el máximo partido](#cómo-sacar-el-máximo-partido-rutas-de-uso) las rutas para triage, deep-dive o auditoría completa.

---

## Qué es esto (en detalle)

Un sistema **modular** de prompts: en vez de un solo texto enorme, tienes piezas que se combinan:

```
_base_audit.md  →  Reglas comunes (no inventar cosas, razonar paso a paso, formato de hallazgos)
  + lang/*.md   →  Adaptado a tu lenguaje (Python, Bash, …)
    + 0N_role   →  El tipo de auditoría (seguridad, rendimiento, arquitectura, …)
```

Eso permite usar **un mismo esquema** con cualquier LLM (Claude, ChatGPT, Gemini, Ollama, Cursor, Antigravity o APIs compatibles) y cambiar solo idioma y rol.

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
make cursor LANG=python ROLE=03_architecture/_index PROJECT=~/my-project
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

## Qué rol y qué lenguaje usar

### ¿Qué pongo en ROLE?

| Si quieres… | Usa este ROLE | Comando de ejemplo |
|-------------|----------------|--------------------|
| Ver un mapa del proyecto y qué auditar primero | `00_orchestrator/_index` | `make clipboard LANG=python ROLE=00_orchestrator/_index` |
| Revisar seguridad (vulnerabilidades, auth, secretos) | `01_security/_index` | `make clipboard LANG=python ROLE=01_security/_index` |
| Revisar rendimiento (lentitud, I/O, memoria) | `02_performance/_index` | `make clipboard LANG=python ROLE=02_performance/_index` |
| Revisar arquitectura (acoplamiento, deuda técnica) | `03_architecture/_index` | `make clipboard LANG=python ROLE=03_architecture/_index` |
| Buscar bugs y casos límite | `04_correctness/_index` | `make clipboard LANG=python ROLE=04_correctness/_index` |
| Revisar tests, logs y mantenibilidad | `05_quality/_index` | `make clipboard LANG=python ROLE=05_quality/_index` |

Para ver **todos** los roles (incluidos los “deep-dive” por subárea):

```bash
make list-roles
```

### ¿Qué pongo en LANG?

Es el **lenguaje principal** del código que vas a auditar. Opciones actuales:

| Código que auditas | LANG |
|--------------------|------|
| Python (.py) | `python` |
| Bash / scripts shell (.sh) | `bash` |

Para listarlos:

```bash
make list-langs
```

Si tu proyecto es otro lenguaje (TypeScript, Go, etc.), más adelante puedes usar **automejora** para generar un adaptador nuevo (ver sección [Automejora](#automejora)).

---

## Cómo sacar el máximo partido (rutas de uso)

1. **Primera vez en un repo**  
   Usa **triage**: `ROLE=00_orchestrator/_index`. Obtienes un mapa, superficies de riesgo y una recomendación de qué roles ejecutar después.

2. **Un solo tema (seguridad, rendimiento, etc.)**  
   Usa el **rol concreto** en modo quick: `01_security/_index`, `02_performance/_index`, etc. Un solo “pass” y listo.

3. **Máxima profundidad en un tema**  
   Usa los **subtasks** del rol (p. ej. seguridad en 4 passes):  
   `01_security/01a_injection_surfaces`, `01_security/01b_auth_access_control`, etc. (ver `make list-roles`).

4. **Auditoría completa**  
   Ejecuta triage y luego los 5 roles quick (6 passes en total). El Makefile puede generar todos los prompts de una vez:  
   `make full-audit LANG=python CODE=~/mi-proyecto/src/ PLATFORM=claude`

5. **Mejorar o ampliar este repo**  
   Usa los **meta-prompts** (automejora): evaluar cobertura, mejorar un prompt, generar un nuevo lenguaje o un nuevo rol. Ver sección [Automejora](#automejora).

---

## Quick Start

```bash
# Componer y copiar al portapapeles
./compose.sh python 01_security/_index --clipboard

# Componer y redirigir a fichero
./compose.sh bash 03_architecture/_index > /tmp/audit_prompt.md

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
├── 00_orchestrator/                   ← mapa + triage + síntesis
│   └── _index.md
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
├── 03_architecture/                   ← arquitectura
│   └── _index.md
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
├── meta/                              ← prompts de automejora
│   ├── _base_meta.md                  ← contrato base para meta-prompts
│   ├── improve_prompt.md              ← mejorar un prompt existente
│   ├── evaluate_coverage.md           ← evaluar gaps de cobertura
│   ├── generate_lang_adapter.md       ← generar adaptador idiomático
│   └── generate_role.md              ← generar nuevo rol
├── prompt_system_audit/               ← auditoría de cualquier sistema de prompts modular
│   ├── deep_analysis.md               ← análisis profundo (informe en prosa)
│   └── automated_json.md             ← análisis automatizado (salida JSON para pipelines)
└── _archive/                          ← prompts originales (histórico)
```

---

## Auditoría de sistemas de prompts modulares

Además de auditar *código*, puedes usar dos prompts autocontenidos para **analizar cualquier sistema de prompts modular** (incluido este repositorio u otro): rationale, coherencia, mejoras, verificación, métricas, riesgos.

| Archivo | Para qué | Salida |
|---------|----------|--------|
| [prompt_system_audit/deep_analysis.md](prompt_system_audit/deep_analysis.md) | Análisis profundo con evidencia y plan de mejora | Informe en prosa (9 secciones) |
| [prompt_system_audit/automated_json.md](prompt_system_audit/automated_json.md) | Análisis listo para pipelines automáticos | JSON estructurado |

**Uso:** Son prompts **standalone** (no se componen con `_base_meta.md` ni con `make meta`). Copia el contenido del `.md` en el LLM y pega a continuación la descripción o listado de módulos del sistema a analizar. Para el JSON, la entrada esperada es una lista de módulos con nombre, descripción, dependencias y propósito.

---

## Modos de uso

| Modo | Cuándo usarlo | Composición | Passes |
|------|---------------|-------------|--------|
| Triage rápido | Evaluar un repo nuevo | base + lang + `00_orchestrator/_index` | 1 |
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
make compose LANG=python ROLE=00_orchestrator/_index > /tmp/triage.md
```

Resultado del prompt compuesto (~220 líneas, ~3.500 tokens):

```
[_base_audit.md]     — principios, CoT, plantilla de hallazgo
---
[lang/python.md]     — detección de versión, PEPs, tooling Python
---
[00_orchestrator/_index.md] — mapeo, superficies de riesgo, triage, plan por fases
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
make claude LANG=python ROLE=00_orchestrator/_index     CODE=~/my-project/src/
make claude LANG=python ROLE=01_security/_index        CODE=~/my-project/src/
make claude LANG=python ROLE=02_performance/_index     CODE=~/my-project/src/
make claude LANG=python ROLE=03_architecture/_index    CODE=~/my-project/src/
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

**Elige la sección según dónde quieras usar el prompt:** en la web (Claude, ChatGPT, Gemini), en un IDE (Cursor, Antigravity), en terminal con API (curl, Ollama) o con herramientas como llm/aider. Cada opción usa el **mismo** prompt compuesto; solo cambia cómo se lo envías al modelo.

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

**Web** ([claude.ai](https://claude.ai)) — ideal si no has usado APIs ni terminal:

Si no tienes cuenta, créala en claude.ai. Luego:

1. Crea un **Proyecto** (o abre uno existente) → Settings → **Custom Instructions**.
2. Pega ahí el prompt compuesto (el que copiaste con `make clipboard`).
3. En el chat, sube los ficheros de tu código (drag & drop) o pega el código.
4. Escribe: *"Ejecuta la auditoría según las instrucciones del proyecto."*

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

**Web** ([chatgpt.com](https://chatgpt.com)) — ideal si no has usado APIs ni terminal:

Si no tienes cuenta, créala en chatgpt.com. Luego:

1. Crea un **Proyecto** → en la configuración del proyecto, pega el prompt compuesto en las **instrucciones**.
2. En el chat, sube ficheros o pega el código que quieras auditar.
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
make gemini LANG=python ROLE=03_architecture/_index CODE=~/my-project/src/
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
@audit-prompts/_base_audit.md @audit-prompts/lang/python.md @audit-prompts/00_orchestrator/_index.md
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
PROMPT=$(./compose.sh python 03_architecture/_index)
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
make list-meta         # Lista meta-prompts disponibles

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

make meta       PROMPT=<meta> [TARGET=<rol>]              # Compone un meta-prompt (automejora)
make meta-clipboard PROMPT=<meta>                         # Copia meta-prompt al portapapeles
make clean                                                 # Limpia archivos generados
```

---

## Añadir un nuevo lenguaje

1. Crear `lang/<lenguaje>.md` siguiendo la estructura de `lang/python.md`.
2. Ningún otro fichero necesita cambios.
3. Usar: `make compose LANG=<lenguaje> ROLE=<rol>`.

O usar el meta-prompt para generarlo automáticamente:

```bash
make meta PROMPT=generate_lang_adapter > /tmp/meta_prompt.md
# Pegar en un LLM junto con la instrucción: "Genera un adaptador para TypeScript"
```

## Añadir un nuevo rol

1. Crear `0N_<nombre>/` con `_index.md` y subtasks opcionales.
2. Seguir la estructura: Persona → Alcance → Metodología → Checklist.
3. Referenciar `_base_audit.md` para la plantilla de hallazgo (no duplicarla).
4. El Makefile lo detecta automáticamente.

O usar el meta-prompt para generarlo automáticamente:

```bash
make meta PROMPT=generate_role > /tmp/meta_prompt.md
# Pegar en un LLM junto con la instrucción: "Genera un rol para auditoría de compliance GDPR"
```

## Automejora: mejorar y ampliar este repositorio

**Qué es:** Los “meta-prompts” son instrucciones que le pasas a un LLM para que **analice o genere** piezas de este mismo sistema (por ejemplo, mejorar un rol existente o crear un adaptador para un lenguaje nuevo). No auditan tu código; auditan o amplían los prompts del repo.

**Cuándo te interesa:**
- Quieres soporte para **otro lenguaje** (p. ej. TypeScript, Go): usa `generate_lang_adapter`.
- Quieres un **nuevo tipo de auditoría** (p. ej. compliance, accesibilidad): usa `generate_role`.
- Quieres **saber qué falta** en el sistema (gaps, prioridades): usa `evaluate_coverage`.
- Quieres **pulir un prompt** concreto (menos ambigüedad, más cobertura): usa `improve_prompt`.

### Listar y usar meta-prompts

```bash
make list-meta
```

Verás los cuatro meta-prompts. Para **componer** uno y copiarlo al portapapeles:

```bash
make meta-clipboard PROMPT=evaluate_coverage
```

O para generarlo y guardarlo en un fichero (y luego pegarlo en Claude/ChatGPT con tu pregunta):

```bash
make meta PROMPT=generate_lang_adapter > /tmp/meta_prompt.md
```

### Qué hace cada meta-prompt (y cómo usarlo)

| Meta-prompt | Para qué sirve | Cómo usarlo |
|-------------|----------------|-------------|
| **evaluate_coverage** | Que la IA analice todos los prompts del repo y te diga qué áreas faltan o están débiles. | `make meta PROMPT=evaluate_coverage` → pega la salida + “Aquí tienes los prompts del sistema; analízalos y dime gaps y prioridades” en el LLM. |
| **improve_prompt** | Que la IA mejore un prompt concreto (más claro, más completo, menos ambiguo). | `make meta PROMPT=improve_prompt TARGET=01_security/_index` → pega todo en el LLM. La IA te devolverá análisis y un diff propuesto. |
| **generate_lang_adapter** | Generar un adaptador nuevo para un lenguaje (ej. TypeScript). | `make meta PROMPT=generate_lang_adapter` → pega en el LLM y añade: “Genera el adaptador para TypeScript.” Copia el resultado en `lang/typescript.md`. |
| **generate_role** | Generar un rol nuevo (carpeta + `_index.md` y subtasks). | `make meta PROMPT=generate_role` → pega en el LLM y añade: “Genera un rol para auditoría de compliance GDPR.” Crea la carpeta y ficheros que indique. |

### Flujo recomendado si quieres “sacar todo el jugo” al repo

1. **Evaluar** qué falta: `make meta PROMPT=evaluate_coverage` → pegar en un LLM con los prompts del repo → obtener lista de gaps.
2. **Generar** lo que falte: `generate_lang_adapter` o `generate_role` según lo que hayas detectado.
3. **Mejorar** prompts existentes: `make meta PROMPT=improve_prompt TARGET=<rol>` → aplicar los diffs que proponga la IA.
4. **Repetir** de vez en cuando o cuando cambien buenas prácticas.

---

## Preguntas frecuentes y problemas habituales

**¿Qué hago si no tengo `make`?**  
En macOS suele estar instalado. En Linux: `sudo apt install make`. En Windows, usa WSL e instala make ahí.

**El comando `make clipboard` no copia nada.**  
Comprueba que tengas una de estas herramientas en el PATH: `pbcopy` (macOS), `xclip` o `xsel` (Linux), `clip.exe` (Windows). En Linux a veces: `sudo apt install xclip`.

**¿Puedo usar solo parte del repo sin terminal?**  
Sí. Puedes abrir a mano `_base_audit.md`, un fichero de `lang/` (p. ej. `lang/python.md`) y un rol (p. ej. `01_security/_index.md`), concatenarlos con `---` entre ellos y pegar ese texto en las instrucciones de Claude/ChatGPT.

**Error: "no existe .../01_security/_index.md".**  
Asegúrate de estar en la raíz del repositorio (`cd audit-prompts`) y de escribir el rol exactamente así: `01_security/_index` (con `_index`). Lista de roles: `make list-roles`.

**Mi código es TypeScript / Go / otro lenguaje.**  
Por ahora solo hay adaptadores para `python` y `bash`. Puedes usar igualmente `LANG=python` (o el más cercano) para una revisión más genérica, o usar automejora: `make meta PROMPT=generate_lang_adapter` y pedir a un LLM que genere el adaptador para tu lenguaje; luego lo guardas en `lang/<lenguaje>.md`.

**¿Cuánto cuesta una auditoría con APIs de pago?**  
Depende del tamaño del código y del modelo. Para ~3K líneas y 6 passes (auditoría completa), el coste estimado está en la tabla de la sección [Coste estimado de una auditoría completa](#coste-estimado-de-una-auditoría-completa). Con Ollama (local) el coste es cero.

**¿Qué modelo elijo si no quiero pagar?**  
Ollama con un modelo local (p. ej. `qwen2.5-coder:32b`). Ver sección [Ollama](#ollama-linux-mac-windows). No envías código a internet.

---

## Requisitos

- **bash** (4.0+) — para `compose.sh` y el Makefile.
- **make** (GNU Make) — para el Makefile.
- **jq** — solo para los targets de API (`claude`, `chatgpt`, `gemini`).
- **Ollama** — solo para el target `ollama` (ejecución local).

En macOS todo viene instalado excepto `jq` (`brew install jq`).
En Windows, usar [WSL](https://learn.microsoft.com/en-us/windows/wsl/install).

---

## Resumen de comandos (cheat sheet)

```text
# Ver opciones
make help
make list-roles
make list-langs
make list-meta

# Generar prompt y copiar (cambia LANG y ROLE)
make clipboard LANG=python ROLE=01_security/_index

# Generar prompt a un fichero
make compose LANG=python ROLE=00_orchestrator/_index > mi_prompt.md

# Auditoría completa (genera 6 prompts)
make full-audit LANG=python CODE=~/mi-proyecto/src/ PLATFORM=claude

# Automejora: evaluar cobertura
make meta-clipboard PROMPT=evaluate_coverage

# Automejora: mejorar un rol concreto
make meta PROMPT=improve_prompt TARGET=01_security/_index
```

## Licencia

MIT. Usa, modifica y redistribuye libremente.
