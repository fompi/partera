---
id: runtime.crewai
type: runtime
category: framework
name: "CrewAI"
version: 1.0.0
description: "Framework multi-agente con roles y tareas"
tags: [runtime, crewai, framework, multi-agent]
supports_capabilities: [all]
supports_tool_calling: true
supports_system_prompt: true
underlying_models: [openai, anthropic, ollama]
estimated_tokens: 240
---

# Runtime: CrewAI

## Características
- Framework multi-agente basado en roles y tareas
- Cada rol del sistema → Agent en CrewAI
- Cada chain → Crew con múltiples agents

## Mapeo
- `disciplines/X/roles/Y/Z/_index.md` → CrewAI Agent con:
  - `role`: name del rol
  - `goal`: description del rol
  - `backstory`: Contenido del rol
  - `tools`: Capabilities requeridas

## Ejemplo de generación
```python
from crewai import Agent, Task, Crew

# Desde engineering.generate.0002_implementer
implementer = Agent(
    role="Desarrollador Senior",
    goal="Genera código funcional desde especificación",
    backstory="[Contenido del rol]",
    tools=[code_execution_tool],
    verbose=True
)

# Chain → Crew
crew = Crew(
    agents=[spec_writer, tech_advisor, implementer, reviewer, documenter],
    tasks=[task1, task2, task3, task4, task5],
    process="sequential"
)
result = crew.kickoff()
```

## Instalación
```bash
pip install crewai crewai-tools
```

## Generación automática
```bash
# Generar código CrewAI desde un rol
./scripts/generate_crewai.sh engineering python generate/0002_implementer/_index
```

## Notas
- Usar `generate_crewai.sh` para generar código Python automáticamente
- Los chains de `chains/` se mapean directamente a Crews
- Soporta cualquier modelo como backend (OpenAI, Anthropic, Ollama)
