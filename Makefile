# Partera — Makefile multiplataforma
#
# Uso:
#   make compose DISC=engineering ADAPTER=python ROLE=audit/0001_security/_index
#   make ollama  DISC=engineering ADAPTER=python ROLE=audit/0001_security/_index CODE=~/my-project/src/
#   make claude  DISC=engineering ADAPTER=python ROLE=audit/0003_architecture/_index CODE=~/my-project/src/app.py
#   make full-audit DISC=engineering ADAPTER=python CODE=~/my-project/src/ PLATFORM=claude
#
# Variables:
#   DISC      — disciplina (engineering, content, design, business, management)
#   ADAPTER   — adaptador (python, bash, technical, marketing, web, agile, ...)
#   ROLE      — rol (audit/0001_security/_index, generate/0002_implementer/_index, ...)
#   CODE      — ruta al código/contenido a analizar
#   PLATFORM  — plataforma para full-audit (claude, chatgpt, gemini, ollama)

SHELL       := /bin/bash
.DEFAULT_GOAL := help

PROMPTS_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))

DISC        ?= engineering
ADAPTER     ?=
ROLE        ?=
PROJECT     ?= $(CURDIR)
OUT         ?= $(PROJECT)/.audit_output

# Modelos por defecto (feb 2026). Override con: make claude MODEL=<modelo> ...
# Para actualizar: consultar docs de cada proveedor y cambiar aquí.
CLAUDE_MODEL   ?= claude-sonnet-4-20260217
CHATGPT_MODEL  ?= gpt-5.2
GEMINI_MODEL   ?= gemini-3.1-pro
OLLAMA_MODEL   ?= qwen2.5-coder:32b

# --- Validación -----------------------------------------------------------

define check_compose
	@test -n "$(DISC)"    || { echo "Error: DISC requerido (engineering, content, ...)"; exit 1; }
	@test -n "$(ADAPTER)" || { echo "Error: ADAPTER requerido (python, bash, ...)"; exit 1; }
	@test -n "$(ROLE)"    || { echo "Error: ROLE requerido (audit/0001_security/_index, ...)"; exit 1; }
endef

define check_code
	@test -n "$(CODE)" || { echo "Error: CODE requerido (ruta a fichero o directorio)"; exit 1; }
endef

# --- Targets principales --------------------------------------------------

.PHONY: help
help: ## Muestra esta ayuda
	@echo "Partera — Sistema de prompts modulares"
	@echo ""
	@echo "Targets disponibles:"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'
	@echo ""
	@echo "Variables:"
	@echo "  DISC=engineering       Disciplina (default: engineering)"
	@echo "  ADAPTER=python|bash     Adaptador"
	@echo "  ROLE=audit/0001_security/_index   Rol"
	@echo "  CODE=<ruta>            Código/contenido a analizar"
	@echo ""
	@echo "Ejemplos:"
	@echo "  make compose DISC=engineering ADAPTER=python ROLE=audit/0001_security/_index"
	@echo "  make claude  DISC=engineering ADAPTER=python ROLE=audit/0001_security/_index CODE=~/src/"
	@echo "  make full-audit DISC=engineering ADAPTER=python CODE=~/src/ PLATFORM=claude"

.PHONY: compose
compose: ## Compone base + disciplina + adaptador + rol (requiere DISC, ADAPTER, ROLE)
	$(check_compose)
	@DISC=$(DISC) $(PROMPTS_DIR)compose.sh "$(ADAPTER)" "$(ROLE)"

.PHONY: clipboard
clipboard: ## Compone y copia al portapapeles
	$(check_compose)
	@DISC=$(DISC) $(PROMPTS_DIR)compose.sh "$(ADAPTER)" "$(ROLE)" --clipboard

# --- Listados y validación -----------------------------------------------

.PHONY: validate
validate: ## Valida todo el sistema (front-matter, referencias, disciplinas)
	@$(PROMPTS_DIR)scripts/validate_system.sh

.PHONY: validate-frontmatter
validate-frontmatter: ## Valida front-matter YAML de todos los archivos .md
	@$(PROMPTS_DIR)scripts/validate_frontmatter.sh "$(PROMPTS_DIR)"

.PHONY: list-disciplines
list-disciplines: ## Lista todas las disciplinas disponibles
	@$(PROMPTS_DIR)scripts/list_by_type.sh disciplines

.PHONY: list-adapters
list-adapters: ## Lista adaptadores (DISC=<disciplina> para filtrar)
	@$(PROMPTS_DIR)scripts/list_by_type.sh adapters $(DISC)

.PHONY: list-roles
list-roles: ## Lista roles (DISC=<disciplina> para filtrar)
	@$(PROMPTS_DIR)scripts/list_by_type.sh roles $(DISC)

.PHONY: list-techniques
list-techniques: ## Lista técnicas disponibles
	@$(PROMPTS_DIR)scripts/list_by_type.sh techniques

.PHONY: list-sources
list-sources: ## Lista fuentes disponibles
	@$(PROMPTS_DIR)scripts/list_by_type.sh sources

.PHONY: list-protocols
list-protocols: ## Lista protocolos disponibles
	@$(PROMPTS_DIR)scripts/list_by_type.sh protocols

.PHONY: list-capabilities
list-capabilities: ## Lista capabilities disponibles
	@$(PROMPTS_DIR)scripts/list_by_type.sh capabilities

# --- Almas (composiciones declarativas YAML) ---------------------------------

ALMA ?=

.PHONY: alma
alma: ## Compone un alma (ALMA=<nombre> ADAPTER=<adaptador>)
	@test -n "$(ALMA)" || { echo "Error: ALMA requerido (v02/security-deep, engineering/security-fintech, ...)"; exit 1; }
	@test -n "$(ADAPTER)" || { echo "Error: ADAPTER requerido (python, bash, ...)"; exit 1; }
	@$(PROMPTS_DIR)compose.sh --alma "$(ALMA)" "$(ADAPTER)"

.PHONY: alma-clipboard
alma-clipboard: ## Compone un alma y copia al portapapeles
	@test -n "$(ALMA)" || { echo "Error: ALMA requerido"; exit 1; }
	@test -n "$(ADAPTER)" || { echo "Error: ADAPTER requerido"; exit 1; }
	@$(PROMPTS_DIR)compose.sh --alma "$(ALMA)" "$(ADAPTER)" --clipboard

.PHONY: list-almas
list-almas: ## Lista almas disponibles
	@$(PROMPTS_DIR)scripts/list_almas.sh

.PHONY: validate-almas
validate-almas: ## Valida todas las almas
	@$(PROMPTS_DIR)scripts/validate_almas.sh

.PHONY: validate-chains
validate-chains: ## Valida todos los chains (roles referenciados existen)
	@$(PROMPTS_DIR)scripts/validate_chains.sh

# --- Chains -------------------------------------------------------------------

CHAIN ?=

.PHONY: chain
chain: ## Ejecuta un chain mostrando cada paso. Requiere CHAIN=<nombre> [ADAPTER=<adaptador>] [STEPS=<dir>]
	@test -n "$(CHAIN)" || { echo "Error: CHAIN requerido (nl-to-code, full-audit, idea-to-project, content-pipeline)"; exit 1; }
	@$(PROMPTS_DIR)scripts/run_chain.sh "$(CHAIN)" "$(ADAPTER)" $(if $(STEPS),--steps $(STEPS))

.PHONY: list-chains
list-chains: ## Lista los chains disponibles
	@echo "Chains disponibles:"
	@for f in $(PROMPTS_DIR)chains/*.chain; do \
		name=$$(basename "$$f" .chain); \
		desc=$$(awk '/^---$$/{found++; next} found==1 && /^description:/{sub(/^description: */, ""); gsub(/"/, ""); print; exit} found==2{exit}' "$$f"); \
		printf "  \033[36m%-25s\033[0m %s\n" "$$name" "$$desc"; \
	done
	@echo ""
	@echo "Uso: make chain CHAIN=<nombre> ADAPTER=<adaptador>"

# --- Runtime-aware composition (Fase 7) -----------------------------------
#
# Uso: make runtime-claude DISC=engineering ADAPTER=python ROLE=generate/0002_implementer/_index
#      make runtime-crewai  DISC=engineering ADAPTER=python ROLE=generate/0002_implementer/_index
#
# Diferencia con los targets claude/openai/gemini/ollama (que generan curl):
# Estos targets componen el prompt con instrucciones del runtime incluidas.

RUNTIME ?=

.PHONY: list-runtimes
list-runtimes: ## Lista los runtimes disponibles
	@echo "Runtimes disponibles:"
	@for f in $(PROMPTS_DIR)runtimes/*.md; do \
		name=$$(basename "$$f" .md); \
		desc=$$(awk '/^---$$/{found++; next} found==1 && /^description:/{sub(/^description: */, ""); gsub(/"/, ""); print; exit} found==2{exit}' "$$f"); \
		printf "  \033[36m%-15s\033[0m %s\n" "$$name" "$$desc"; \
	done
	@echo ""
	@echo "Uso: make runtime-claude DISC=<disc> ADAPTER=<adapter> ROLE=<rol>"

.PHONY: runtime-claude
runtime-claude: ## Compone prompt con instrucciones runtime Claude. Requiere DISC, ADAPTER, ROLE.
	@test -n "$(DISC)"    || { echo "Error: DISC requerido (engineering, content, ...)"; exit 1; }
	@test -n "$(ADAPTER)" || { echo "Error: ADAPTER requerido (python, bash, ...)"; exit 1; }
	@test -n "$(ROLE)"    || { echo "Error: ROLE requerido"; exit 1; }
	@DISC=$(DISC) RUNTIME=claude $(PROMPTS_DIR)compose.sh $(ADAPTER) $(ROLE) $(if $(CLIPBOARD),--clipboard)

.PHONY: runtime-openai
runtime-openai: ## Compone prompt con instrucciones runtime OpenAI. Requiere DISC, ADAPTER, ROLE.
	@test -n "$(DISC)"    || { echo "Error: DISC requerido"; exit 1; }
	@test -n "$(ADAPTER)" || { echo "Error: ADAPTER requerido"; exit 1; }
	@test -n "$(ROLE)"    || { echo "Error: ROLE requerido"; exit 1; }
	@DISC=$(DISC) RUNTIME=openai $(PROMPTS_DIR)compose.sh $(ADAPTER) $(ROLE) $(if $(CLIPBOARD),--clipboard)

.PHONY: runtime-gemini
runtime-gemini: ## Compone prompt con instrucciones runtime Gemini. Requiere DISC, ADAPTER, ROLE.
	@test -n "$(DISC)"    || { echo "Error: DISC requerido"; exit 1; }
	@test -n "$(ADAPTER)" || { echo "Error: ADAPTER requerido"; exit 1; }
	@test -n "$(ROLE)"    || { echo "Error: ROLE requerido"; exit 1; }
	@DISC=$(DISC) RUNTIME=gemini $(PROMPTS_DIR)compose.sh $(ADAPTER) $(ROLE) $(if $(CLIPBOARD),--clipboard)

.PHONY: runtime-ollama
runtime-ollama: ## Compone prompt con instrucciones runtime Ollama. Requiere DISC, ADAPTER, ROLE.
	@test -n "$(DISC)"    || { echo "Error: DISC requerido"; exit 1; }
	@test -n "$(ADAPTER)" || { echo "Error: ADAPTER requerido"; exit 1; }
	@test -n "$(ROLE)"    || { echo "Error: ROLE requerido"; exit 1; }
	@DISC=$(DISC) RUNTIME=ollama $(PROMPTS_DIR)compose.sh $(ADAPTER) $(ROLE) $(if $(CLIPBOARD),--clipboard)

.PHONY: runtime-crewai
runtime-crewai: ## Compone prompt con instrucciones runtime CrewAI. Requiere DISC, ADAPTER, ROLE.
	@test -n "$(DISC)"    || { echo "Error: DISC requerido"; exit 1; }
	@test -n "$(ADAPTER)" || { echo "Error: ADAPTER requerido"; exit 1; }
	@test -n "$(ROLE)"    || { echo "Error: ROLE requerido"; exit 1; }
	@DISC=$(DISC) RUNTIME=crewai $(PROMPTS_DIR)compose.sh $(ADAPTER) $(ROLE) $(if $(CLIPBOARD),--clipboard)
	@echo ""
	@echo "Tip: make generate-crewai DISC=$(DISC) ADAPTER=$(ADAPTER) ROLE=$(ROLE)"
	@echo "     para generar código Python de CrewAI directamente."

.PHONY: runtime-langchain
runtime-langchain: ## Compone prompt con instrucciones runtime LangChain. Requiere DISC, ADAPTER, ROLE.
	@test -n "$(DISC)"    || { echo "Error: DISC requerido"; exit 1; }
	@test -n "$(ADAPTER)" || { echo "Error: ADAPTER requerido"; exit 1; }
	@test -n "$(ROLE)"    || { echo "Error: ROLE requerido"; exit 1; }
	@DISC=$(DISC) RUNTIME=langchain $(PROMPTS_DIR)compose.sh $(ADAPTER) $(ROLE) $(if $(CLIPBOARD),--clipboard)

.PHONY: runtime-autogen
runtime-autogen: ## Compone prompt con instrucciones runtime AutoGen. Requiere DISC, ADAPTER, ROLE.
	@test -n "$(DISC)"    || { echo "Error: DISC requerido"; exit 1; }
	@test -n "$(ADAPTER)" || { echo "Error: ADAPTER requerido"; exit 1; }
	@test -n "$(ROLE)"    || { echo "Error: ROLE requerido"; exit 1; }
	@DISC=$(DISC) RUNTIME=autogen $(PROMPTS_DIR)compose.sh $(ADAPTER) $(ROLE) $(if $(CLIPBOARD),--clipboard)

.PHONY: generate-crewai
generate-crewai: ## Genera código Python de CrewAI desde un rol. Requiere DISC, ADAPTER, ROLE.
	@test -n "$(DISC)"    || { echo "Error: DISC requerido"; exit 1; }
	@test -n "$(ADAPTER)" || { echo "Error: ADAPTER requerido"; exit 1; }
	@test -n "$(ROLE)"    || { echo "Error: ROLE requerido"; exit 1; }
	@$(PROMPTS_DIR)scripts/generate_crewai.sh "$(DISC)" "$(ADAPTER)" "$(ROLE)"

.PHONY: list-patterns
list-patterns: ## Lista los patterns de razonamiento disponibles
	@echo "Patterns de razonamiento disponibles:"
	@for f in $(PROMPTS_DIR)patterns/*.md; do \
		name=$$(basename "$$f" .md); \
		desc=$$(awk '/^---$$/{found++; next} found==1 && /^description:/{sub(/^description: */, ""); gsub(/"/, ""); print; exit} found==2{exit}' "$$f"); \
		printf "  \033[36m%-20s\033[0m %s\n" "$$name" "$$desc"; \
	done
	@echo ""
	@echo "Uso: DISC=<disc> EXT=\"patterns/<name>\" ./compose.sh <adapter> <rol>"

# --- Plataformas de pago ---------------------------------------------------

.PHONY: claude
claude: ## Genera comando curl para Claude API (Anthropic)
	$(check_compose)
	$(check_code)
	@mkdir -p "$(OUT)"
	@PROMPT=$$(DISC=$(DISC) $(PROMPTS_DIR)compose.sh "$(ADAPTER)" "$(ROLE)"); \
	MODEL=$${MODEL:-$(CLAUDE_MODEL)}; \
	echo "#!/usr/bin/env bash"; \
	echo "# Claude API — $(ADAPTER) + $(ROLE)"; \
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
	$(check_compose)
	$(check_code)
	@mkdir -p "$(OUT)"
	@PROMPT=$$(DISC=$(DISC) $(PROMPTS_DIR)compose.sh "$(ADAPTER)" "$(ROLE)"); \
	MODEL=$${MODEL:-$(CHATGPT_MODEL)}; \
	echo "#!/usr/bin/env bash"; \
	echo "# OpenAI API — $(ADAPTER) + $(ROLE)"; \
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
	$(check_compose)
	$(check_code)
	@mkdir -p "$(OUT)"
	@PROMPT=$$(DISC=$(DISC) $(PROMPTS_DIR)compose.sh "$(ADAPTER)" "$(ROLE)"); \
	MODEL=$${MODEL:-$(GEMINI_MODEL)}; \
	echo "#!/usr/bin/env bash"; \
	echo "# Gemini API — $(ADAPTER) + $(ROLE)"; \
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
	$(check_compose)
	@mkdir -p "$(PROJECT)/.cursor/rules"
	@ROLE_NAME=$$(echo "$(ROLE)" | sed 's|/_index$$||;s|\.md$$||;s|/|__|g'); \
	OUT_FILE="$(PROJECT)/.cursor/rules/audit_$${ROLE_NAME}.md"; \
	DISC=$(DISC) $(PROMPTS_DIR)compose.sh "$(ADAPTER)" "$(ROLE)" > "$$OUT_FILE"; \
	echo "Creado: $$OUT_FILE"; \
	echo ""; \
	echo "Uso en Cursor:"; \
	echo "  1. La regla se activará automáticamente en el proyecto."; \
	echo "  2. En el chat, escribe:"; \
	echo "     Siguiendo la regla de auditoría, analiza @src/"

.PHONY: antigravity
antigravity: ## Genera un Skill SKILL.md para Google Antigravity
	$(check_compose)
	@SKILL_NAME="audit-$$(echo '$(ROLE)' | tr '/' '-' | sed 's/_index//;s/--*/-/g;s/-$$//')"; \
	SKILL_DIR="$(PROJECT)/.agent/skills/$$SKILL_NAME"; \
	mkdir -p "$$SKILL_DIR"; \
	PROMPT=$$(DISC=$(DISC) $(PROMPTS_DIR)compose.sh "$(ADAPTER)" "$(ROLE)"); \
	ROLE_LABEL=$$(echo "$(ROLE)" | sed 's|.*/||;s/_index//'); \
	{ echo "---"; \
	  echo "name: $$SKILL_NAME"; \
	  echo "description: |"; \
	echo "  $$ROLE_LABEL ($(ADAPTER)). Usa este skill cuando el usuario pida auditar"; \
	  echo "  código $(ADAPTER) enfocándose en $$(echo '$(ROLE)' | tr '_' ' ' | sed 's|/.*||')."; \
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
	$(check_compose)
	$(check_code)
	@PROMPT=$$(DISC=$(DISC) $(PROMPTS_DIR)compose.sh "$(ADAPTER)" "$(ROLE)"); \
	MODEL=$${MODEL:-$(OLLAMA_MODEL)}; \
	echo "Ejecutando auditoría con Ollama ($$MODEL)..."; \
	echo "Prompt: $(ADAPTER) + $(ROLE) ($$(echo "$$PROMPT" | wc -l | tr -d ' ') líneas)"; \
	echo "Código: $(CODE)"; \
	echo "---"; \
	CODE_CONTENT=$$(find "$(CODE)" -type f \( -name '*.py' -o -name '*.sh' -o -name '*.js' -o -name '*.ts' -o -name '*.go' -o -name '*.rs' \) -exec cat {} + 2>/dev/null || cat "$(CODE)"); \
	echo "$$CODE_CONTENT" | ollama run "$$MODEL" --system "$$PROMPT" "Ejecuta la auditoría sobre este código:"

# --- Auditoría completa ----------------------------------------------------

QUICK_ROLES := audit/0000_orchestrator/_index audit/0001_security/_index audit/0002_performance/_index \
               audit/0003_architecture/_index audit/0004_correctness/_index audit/0005_quality/_index

.PHONY: full-audit
full-audit: ## Ejecuta auditoría completa (6 passes). Requiere DISC, ADAPTER, PLATFORM, CODE.
	$(check_compose)
	$(check_code)
	@test -n "$(PLATFORM)" || { echo "Error: PLATFORM requerido (claude, chatgpt, gemini, ollama)"; exit 1; }
	@mkdir -p "$(OUT)"
	@echo "=== Auditoría completa: $(DISC) + $(ADAPTER) sobre $(CODE) ==="
	@echo "Plataforma: $(PLATFORM)"
	@echo "Roles: $(QUICK_ROLES)"
	@echo ""
	@for role in $(QUICK_ROLES); do \
		echo "--- $$role ---"; \
		$(MAKE) -s compose DISC=$(DISC) ADAPTER=$(ADAPTER) ROLE=$$role > "$(OUT)/$$(echo $$role | tr '/' '_')_prompt.md"; \
		echo "Prompt guardado en $(OUT)/$$(echo $$role | tr '/' '_')_prompt.md"; \
	done
	@echo ""
	@echo "Prompts generados en $(OUT)/. Para ejecutarlos:"
	@echo ""
	@for role in $(QUICK_ROLES); do \
		echo "  make $(PLATFORM) DISC=$(DISC) ADAPTER=$(ADAPTER) ROLE=$$role CODE=$(CODE)"; \
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
	@echo "  make meta PROMPT=improve_prompt TARGET=0001_security/_index"
	@echo "  make meta PROMPT=evaluate_coverage"
	@echo "  make meta-clipboard PROMPT=improve_prompt"

# --- Utilidades ------------------------------------------------------------

.PHONY: token-estimate
token-estimate: ## Estima tokens del prompt compuesto (regla: ~4 chars/token)
	$(check_compose)
	@PROMPT_CONTENT=$$(DISC=$(DISC) $(PROMPTS_DIR)compose.sh "$(ADAPTER)" "$(ROLE)"); \
	CHARS=$$(echo "$$PROMPT_CONTENT" | wc -c | tr -d ' '); \
	LINES=$$(echo "$$PROMPT_CONTENT" | wc -l | tr -d ' '); \
	TOKENS=$$((CHARS / 4)); \
	echo "Prompt compuesto: $(DISC) + $(ADAPTER) + $(ROLE)"; \
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
