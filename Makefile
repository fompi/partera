# Audit Prompts — Makefile multiplataforma
#
# Uso:
#   make help                              — muestra todos los targets
#   make compose LANG=python ROLE=01_security/_index
#   make ollama  LANG=python ROLE=01_security/_index CODE=~/my-project/src/
#   make claude  LANG=python ROLE=03_architecture/_index CODE=~/my-project/src/app.py
#   make cursor  LANG=bash   ROLE=05_quality/_index PROJECT=~/my-project
#   make antigravity LANG=python ROLE=01_security/_index PROJECT=~/my-project
#   make full-audit  LANG=python CODE=~/my-project/src/ PLATFORM=claude
#
# Variables:
#   LANG      — adaptador idiomático (python, bash, ...)
#   ROLE      — rol o subtask (00_orchestrator/_index, 01_security/_index, 01_security/01a_injection_surfaces, ...)
#   CODE      — ruta al código a analizar (fichero, directorio o glob)
#   PLATFORM  — plataforma para full-audit (claude, chatgpt, gemini, ollama)
#   MODEL     — modelo a usar (override del default por plataforma)
#   PROJECT   — raíz del proyecto a auditar (default: directorio actual de trabajo)
#   OUT       — directorio de salida (default: .audit_output)

SHELL       := /bin/bash
.DEFAULT_GOAL := help

PROMPTS_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
BASE        := $(PROMPTS_DIR)_base_audit.md
LANG_FILE   := $(PROMPTS_DIR)lang/$(LANG).md
ROLE_CLEAN  := $(ROLE:%.md=%)
ROLE_FILE   := $(PROMPTS_DIR)$(ROLE_CLEAN).md
PROJECT     ?= $(CURDIR)
OUT         ?= $(PROJECT)/.audit_output

# Modelos por defecto (feb 2026). Override con: make claude MODEL=<modelo> ...
# Para actualizar: consultar docs de cada proveedor y cambiar aquí.
CLAUDE_MODEL   ?= claude-sonnet-4-20260217
CHATGPT_MODEL  ?= gpt-5.2
GEMINI_MODEL   ?= gemini-3.1-pro
OLLAMA_MODEL   ?= qwen2.5-coder:32b

# --- Validación -----------------------------------------------------------

define check_lang
	@test -n "$(LANG)" || { echo "Error: LANG requerido (python, bash, ...)"; exit 1; }
	@test -f "$(LANG_FILE)" || { echo "Error: no existe $(LANG_FILE)"; exit 1; }
endef

define check_role
	@test -n "$(ROLE)" || { echo "Error: ROLE requerido (00_orchestrator/_index, 01_security/_index, ...)"; exit 1; }
	@test -f "$(ROLE_FILE)" || { echo "Error: no existe $(ROLE_FILE)"; exit 1; }
endef

define check_code
	@test -n "$(CODE)" || { echo "Error: CODE requerido (ruta a fichero o directorio)"; exit 1; }
endef

# --- Targets principales --------------------------------------------------

.PHONY: help
help: ## Muestra esta ayuda
	@echo "Audit Prompts — Makefile multiplataforma"
	@echo ""
	@echo "Targets disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "Variables:"
	@echo "  LANG=python|bash       Adaptador idiomático"
	@echo "  ROLE=<rol>             Rol o subtask (ver estructura de carpetas)"
	@echo "  CODE=<ruta>            Código a analizar"
	@echo "  MODEL=<modelo>         Override del modelo por defecto"
	@echo "  PROJECT=<dir>          Raíz del proyecto a auditar (default: cwd)"
	@echo "  OUT=<dir>              Directorio de salida (default: PROJECT/.audit_output)"
	@echo ""
	@echo "Ejemplos:"
	@echo "  make compose LANG=python ROLE=01_security/_index"
	@echo "  make claude  LANG=python ROLE=01_security/_index CODE=~/my-project/src/"
	@echo "  make ollama  LANG=bash ROLE=04_correctness/_index CODE=~/my-project/scripts/"
	@echo "  make cursor  LANG=python ROLE=03_architecture/_index PROJECT=~/my-project"
	@echo "  make antigravity LANG=python ROLE=01_security/_index PROJECT=~/my-project"
	@echo "  make full-audit LANG=python CODE=~/my-project/src/ PLATFORM=claude"

.PHONY: compose
compose: ## Compone base + lang + rol y lo imprime a stdout
	$(check_lang)
	$(check_role)
	@cat "$(BASE)" <(printf '\n---\n\n') "$(LANG_FILE)" <(printf '\n---\n\n') "$(ROLE_FILE)"

.PHONY: clipboard
clipboard: ## Compone y copia al portapapeles
	$(check_lang)
	$(check_role)
	@$(PROMPTS_DIR)compose.sh "$(LANG)" "$(ROLE)" --clipboard

.PHONY: list-roles
list-roles: ## Lista todos los roles y subtasks disponibles
	@echo "Roles disponibles:"
	@echo ""
	@echo "  00_orchestrator/_index       — Mapa del sistema + triage"
	@echo "  01_security/_index           — Seguridad (quick, 1 pass)"
	@echo "  01_security/01a_injection_surfaces"
	@echo "  01_security/01b_auth_access_control"
	@echo "  01_security/01c_secrets_crypto"
	@echo "  01_security/01d_supply_chain"
	@echo "  02_performance/_index        — Rendimiento (quick, 1 pass)"
	@echo "  02_performance/02a_algorithmic_complexity"
	@echo "  02_performance/02b_io_network_concurrency"
	@echo "  02_performance/02c_memory_resources"
	@echo "  03_architecture/_index       — Arquitectura (quick, 1 pass)"
	@echo "  04_correctness/_index        — Correctitud (quick, 1 pass)"
	@echo "  04_correctness/04a_edge_cases_contracts"
	@echo "  04_correctness/04b_concurrency_state"
	@echo "  04_correctness/04c_error_handling"
	@echo "  05_quality/_index            — Calidad/DX (quick, 1 pass)"
	@echo "  05_quality/05a_testing_quality"
	@echo "  05_quality/05b_observability_ops"
	@echo "  05_quality/05c_code_maintainability"

.PHONY: list-langs
list-langs: ## Lista los adaptadores idiomáticos disponibles
	@echo "Lenguajes disponibles:"
	@for f in $(PROMPTS_DIR)lang/*.md; do echo "  $$(basename $$f .md)"; done

# --- Plataformas de pago ---------------------------------------------------

.PHONY: claude
claude: ## Genera comando curl para Claude API (Anthropic)
	$(check_lang)
	$(check_role)
	$(check_code)
	@mkdir -p "$(OUT)"
	@PROMPT=$$(cat "$(BASE)" <(printf '\n---\n\n') "$(LANG_FILE)" <(printf '\n---\n\n') "$(ROLE_FILE)"); \
	MODEL=$${MODEL:-$(CLAUDE_MODEL)}; \
	echo "#!/usr/bin/env bash"; \
	echo "# Claude API — $(LANG) + $(ROLE)"; \
	echo "# Modelo: $$MODEL"; \
	echo "# Docs: https://docs.anthropic.com/en/api/messages"; \
	echo "# Pricing: https://www.anthropic.com/pricing"; \
	echo ""; \
	echo "PROMPT=\$$(cat <<'PROMPT_EOF'"; \
	echo "$$PROMPT"; \
	echo "PROMPT_EOF"; \
	echo ")"; \
	echo ""; \
	echo "CODE=\$$(cat $(CODE))"; \
	echo ""; \
	echo 'curl -s https://api.anthropic.com/v1/messages \'; \
	echo '  -H "x-api-key: $$ANTHROPIC_API_KEY" \'; \
	echo '  -H "content-type: application/json" \'; \
	echo '  -H "anthropic-version: 2023-06-01" \'; \
	echo "  -d \$$(jq -n \\"; \
	echo '    --arg system "$$PROMPT" \'; \
	echo '    --arg code "$$CODE" \'; \
	echo "    '{model: \"$$MODEL\","; \
	echo "      max_tokens: 16384,"; \
	echo "      system: \$$system,"; \
	echo "      messages: [{role: \"user\","; \
	echo '        content: ("Ejecuta la auditoría sobre este código:\n\n" + $$code)}]}'"'"')'

.PHONY: chatgpt
chatgpt: ## Genera comando curl para OpenAI API
	$(check_lang)
	$(check_role)
	$(check_code)
	@mkdir -p "$(OUT)"
	@PROMPT=$$(cat "$(BASE)" <(printf '\n---\n\n') "$(LANG_FILE)" <(printf '\n---\n\n') "$(ROLE_FILE)"); \
	MODEL=$${MODEL:-$(CHATGPT_MODEL)}; \
	echo "#!/usr/bin/env bash"; \
	echo "# OpenAI API — $(LANG) + $(ROLE)"; \
	echo "# Modelo: $$MODEL"; \
	echo "# Docs: https://platform.openai.com/docs/api-reference/chat"; \
	echo "# Pricing: https://openai.com/api/pricing"; \
	echo ""; \
	echo "PROMPT=\$$(cat <<'PROMPT_EOF'"; \
	echo "$$PROMPT"; \
	echo "PROMPT_EOF"; \
	echo ")"; \
	echo ""; \
	echo "CODE=\$$(cat $(CODE))"; \
	echo ""; \
	echo 'curl -s https://api.openai.com/v1/chat/completions \'; \
	echo '  -H "Authorization: Bearer $$OPENAI_API_KEY" \'; \
	echo '  -H "Content-Type: application/json" \'; \
	echo "  -d \$$(jq -n \\"; \
	echo '    --arg system "$$PROMPT" \'; \
	echo '    --arg code "$$CODE" \'; \
	echo "    '{model: \"$$MODEL\","; \
	echo "      messages: ["; \
	echo '        {role: "system", content: $$system},'; \
	echo '        {role: "user",'; \
	echo '         content: ("Ejecuta la auditoría sobre este código:\n\n" + $$code)}]}'"'"')'

.PHONY: gemini
gemini: ## Genera comando curl para Gemini API (Google AI Studio)
	$(check_lang)
	$(check_role)
	$(check_code)
	@mkdir -p "$(OUT)"
	@PROMPT=$$(cat "$(BASE)" <(printf '\n---\n\n') "$(LANG_FILE)" <(printf '\n---\n\n') "$(ROLE_FILE)"); \
	MODEL=$${MODEL:-$(GEMINI_MODEL)}; \
	echo "#!/usr/bin/env bash"; \
	echo "# Gemini API — $(LANG) + $(ROLE)"; \
	echo "# Modelo: $$MODEL"; \
	echo "# Docs: https://ai.google.dev/gemini-api/docs"; \
	echo "# Pricing: https://ai.google.dev/gemini-api/docs/pricing"; \
	echo ""; \
	echo "PROMPT=\$$(cat <<'PROMPT_EOF'"; \
	echo "$$PROMPT"; \
	echo "PROMPT_EOF"; \
	echo ")"; \
	echo ""; \
	echo "CODE=\$$(cat $(CODE))"; \
	echo ""; \
	echo "curl -s \"https://generativelanguage.googleapis.com/v1beta/models/$$MODEL:generateContent?key=\$$GEMINI_API_KEY\" \\"; \
	echo '  -H "Content-Type: application/json" \'; \
	echo "  -d \$$(jq -n \\"; \
	echo '    --arg system "$$PROMPT" \'; \
	echo '    --arg code "$$CODE" \'; \
	echo "    '{system_instruction: {parts: [{text: \$$system}]},"; \
	echo "      contents: [{parts: [{text: (\"Ejecuta la auditoría sobre este código:\\n\\n\" + \$$code)}]}],"; \
	echo '      generationConfig: {maxOutputTokens: 16384}}'"'"')'

# --- IDEs y herramientas ---------------------------------------------------

.PHONY: cursor
cursor: ## Genera ficheros .cursor/rules/ en el PROJECT para usar como reglas
	$(check_lang)
	$(check_role)
	@mkdir -p "$(PROJECT)/.cursor/rules"
	@ROLE_NAME=$$(echo "$(ROLE)" | sed 's|/_index$$||;s|\.md$$||;s|/|__|g'); \
	OUT_FILE="$(PROJECT)/.cursor/rules/audit_$${ROLE_NAME}.md"; \
	cat "$(BASE)" <(printf '\n---\n\n') "$(LANG_FILE)" <(printf '\n---\n\n') "$(ROLE_FILE)" > "$$OUT_FILE"; \
	echo "Creado: $$OUT_FILE"; \
	echo ""; \
	echo "Uso en Cursor:"; \
	echo "  1. La regla se activará automáticamente en el proyecto."; \
	echo "  2. En el chat, escribe:"; \
	echo "     Siguiendo la regla de auditoría, analiza @src/"

.PHONY: antigravity
antigravity: ## Genera un Skill SKILL.md para Google Antigravity
	$(check_lang)
	$(check_role)
	@SKILL_NAME="audit-$$(echo '$(ROLE)' | tr '/' '-' | sed 's/_index//;s/--*/-/g;s/-$$//')"; \
	SKILL_DIR="$(PROJECT)/.agent/skills/$$SKILL_NAME"; \
	mkdir -p "$$SKILL_DIR"; \
	ROLE_LABEL=$$(head -1 "$(ROLE_FILE)" | sed 's/^# *//'); \
	PROMPT=$$(cat "$(BASE)" <(printf '\n---\n\n') "$(LANG_FILE)" <(printf '\n---\n\n') "$(ROLE_FILE)"); \
	{ echo "---"; \
	  echo "name: $$SKILL_NAME"; \
	  echo "description: |"; \
	  echo "  $$ROLE_LABEL ($(LANG)). Usa este skill cuando el usuario pida auditar"; \
	  echo "  código $(LANG) enfocándose en $$(echo '$(ROLE)' | tr '_' ' ' | sed 's|/.*||')."; \
	  echo "  Actívalo con: \"audita seguridad\", \"revisa rendimiento\", \"analiza arquitectura\"."; \
	  echo "compatibility:"; \
	  echo "  - antigravity"; \
	  echo "  - cursor"; \
	  echo "  - claude-code"; \
	  echo "---"; \
	  echo ""; \
	  echo "$$PROMPT"; \
	} > "$$SKILL_DIR/SKILL.md"; \
	echo "Creado: $$SKILL_DIR/SKILL.md"; \
	echo ""; \
	echo "Antigravity detectará el skill automáticamente desde .agent/skills/."; \
	echo "También compatible con Cursor, Claude Code y Gemini CLI."; \
	echo ""; \
	echo "Docs: https://www.mdskills.ai/specs/skill-md"

.PHONY: ollama
ollama: ## Ejecuta la auditoría directamente con Ollama local
	$(check_lang)
	$(check_role)
	$(check_code)
	@PROMPT=$$(cat "$(BASE)" <(printf '\n---\n\n') "$(LANG_FILE)" <(printf '\n---\n\n') "$(ROLE_FILE)"); \
	MODEL=$${MODEL:-$(OLLAMA_MODEL)}; \
	echo "Ejecutando auditoría con Ollama ($$MODEL)..."; \
	echo "Prompt: $(LANG) + $(ROLE) ($$(echo "$$PROMPT" | wc -l | tr -d ' ') líneas)"; \
	echo "Código: $(CODE)"; \
	echo "---"; \
	CODE_CONTENT=$$(find "$(CODE)" -type f \( -name '*.py' -o -name '*.sh' -o -name '*.js' -o -name '*.ts' -o -name '*.go' -o -name '*.rs' \) -exec cat {} + 2>/dev/null || cat "$(CODE)"); \
	echo "$$CODE_CONTENT" | ollama run "$$MODEL" --system "$$PROMPT" "Ejecuta la auditoría sobre este código:"

# --- Auditoría completa ----------------------------------------------------

QUICK_ROLES := 00_orchestrator/_index 01_security/_index 02_performance/_index \
               03_architecture/_index 04_correctness/_index 05_quality/_index

.PHONY: full-audit
full-audit: ## Ejecuta auditoría completa (6 passes secuenciales). Requiere PLATFORM.
	$(check_lang)
	$(check_code)
	@test -n "$(PLATFORM)" || { echo "Error: PLATFORM requerido (claude, chatgpt, gemini, ollama)"; exit 1; }
	@mkdir -p "$(OUT)"
	@echo "=== Auditoría completa: $(LANG) sobre $(CODE) ==="
	@echo "Plataforma: $(PLATFORM)"
	@echo "Roles: $(QUICK_ROLES)"
	@echo ""
	@for role in $(QUICK_ROLES); do \
		echo "--- $$role ---"; \
		$(MAKE) -s compose LANG=$(LANG) ROLE=$$role > "$(OUT)/$${role//\//_}_prompt.md"; \
		echo "Prompt guardado en $(OUT)/$${role//\//_}_prompt.md"; \
	done
	@echo ""
	@echo "Prompts generados en $(OUT)/. Para ejecutarlos:"
	@echo ""
	@for role in $(QUICK_ROLES); do \
		echo "  make $(PLATFORM) LANG=$(LANG) ROLE=$$role CODE=$(CODE)"; \
	done

# --- Meta-prompts (automejora) ---------------------------------------------

META_BASE    := $(PROMPTS_DIR)meta/_base_meta.md
META_FILE    := $(PROMPTS_DIR)meta/$(PROMPT).md

define check_prompt
	@test -n "$(PROMPT)" || { echo "Error: PROMPT requerido (improve_prompt, evaluate_coverage, generate_lang_adapter, generate_role)"; exit 1; }
	@test -f "$(META_FILE)" || { echo "Error: no existe $(META_FILE)"; exit 1; }
endef

.PHONY: meta
meta: ## Compone un meta-prompt (automejora). Requiere PROMPT, opcionalmente TARGET.
	$(check_prompt)
	@if [ -n "$(TARGET)" ]; then \
		cat "$(META_BASE)" <(printf '\n---\n\n') "$(META_FILE)" <(printf '\n---\n\nA continuación el prompt a analizar:\n\n---\n\n') "$(PROMPTS_DIR)$(TARGET).md"; \
	else \
		cat "$(META_BASE)" <(printf '\n---\n\n') "$(META_FILE)"; \
	fi

.PHONY: meta-clipboard
meta-clipboard: ## Compone un meta-prompt y lo copia al portapapeles
	$(check_prompt)
	@$(PROMPTS_DIR)compose.sh --meta "$(PROMPT)" --clipboard

.PHONY: list-meta
list-meta: ## Lista los meta-prompts disponibles (automejora)
	@echo "Meta-prompts disponibles:"
	@echo ""
	@echo "  improve_prompt         — Analizar debilidades de un prompt existente"
	@echo "  evaluate_coverage      — Evaluar gaps de cobertura del sistema"
	@echo "  generate_lang_adapter  — Generar adaptador idiomático para un nuevo lenguaje"
	@echo "  generate_role          — Generar un nuevo rol de auditoría"
	@echo ""
	@echo "Uso:"
	@echo "  make meta PROMPT=improve_prompt TARGET=01_security/_index"
	@echo "  make meta PROMPT=evaluate_coverage"
	@echo "  make meta-clipboard PROMPT=improve_prompt"

# --- Utilidades ------------------------------------------------------------

.PHONY: token-estimate
token-estimate: ## Estima tokens del prompt compuesto (regla: ~4 chars/token)
	$(check_lang)
	$(check_role)
	@CHARS=$$(cat "$(BASE)" "$(LANG_FILE)" "$(ROLE_FILE)" | wc -c | tr -d ' '); \
	LINES=$$(cat "$(BASE)" "$(LANG_FILE)" "$(ROLE_FILE)" | wc -l | tr -d ' '); \
	TOKENS=$$((CHARS / 4)); \
	echo "Prompt compuesto: $(LANG) + $(ROLE)"; \
	echo "  Líneas:          $$LINES"; \
	echo "  Caracteres:      $$CHARS"; \
	echo "  Tokens (est.):   ~$$TOKENS"; \
	echo ""; \
	echo "Contexto restante por modelo:"; \
	echo "  Claude Opus/Sonnet 4.6 (200K):  ~$$((200000 - TOKENS)) tokens libres"; \
	echo "  Claude 4.6 beta (1M):           ~$$((1000000 - TOKENS)) tokens libres"; \
	echo "  GPT-5.2 (400K):                 ~$$((400000 - TOKENS)) tokens libres"; \
	echo "  Gemini 3.1 Pro (1M):            ~$$((1000000 - TOKENS)) tokens libres"; \
	echo "  Ollama local (depende del modelo y quantización)"

.PHONY: clean
clean: ## Limpia archivos generados
	rm -rf "$(OUT)"
	@echo "Para limpiar reglas/skills instalados en un proyecto:"
	@echo "  rm -rf <proyecto>/.cursor/rules/audit_*.md <proyecto>/.agent/skills/audit-*"
