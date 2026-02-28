#!/usr/bin/env bash
# generate_crewai.sh — Genera código Python de CrewAI desde un rol del sistema
#
# Uso:
#   ./scripts/generate_crewai.sh <discipline> <adapter> <role_path>
#
# Ejemplos:
#   ./scripts/generate_crewai.sh engineering python generate/0002_implementer/_index
#   ./scripts/generate_crewai.sh engineering python audit/0001_security/_index
#
# Output: código Python impreso a stdout (redirigir a archivo según necesidad)

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")/.." && pwd)"

usage() {
  cat <<'USAGE'
Genera código Python de CrewAI desde un rol del sistema.

Uso:
  ./scripts/generate_crewai.sh <discipline> <adapter> <role_path>

Ejemplos:
  ./scripts/generate_crewai.sh engineering python generate/0002_implementer/_index
  ./scripts/generate_crewai.sh engineering bash   audit/0001_security/_index

Output: código Python impreso a stdout
  Redirigir: ./scripts/generate_crewai.sh engineering python generate/0002_implementer/_index > agent.py
USAGE
  exit 1
}

[[ $# -lt 3 ]] && usage

DISC="$1"
ADAPTER="$2"
ROLE="$3"

# Resolver ruta del rol
role_file="$SCRIPT_DIR/disciplines/$DISC/roles/${ROLE}"
[[ "$role_file" != *.md ]] && role_file="${role_file}.md"

if [[ ! -f "$role_file" ]]; then
  echo "Error: rol '$ROLE' no encontrado en disciplines/$DISC/roles/" >&2
  exit 1
fi

# Extrae campo del front-matter
get_field() {
  local file="$1" field="$2"
  awk '/^---$/{found++; next} found==1{print} found==2{exit}' "$file" \
    | grep "^${field}:" | head -1 | sed 's/^[^:]*: *//' | tr -d '"'
}

# Extrae contenido (sin front-matter)
get_content() {
  local file="$1"
  awk '/^---$/{found++; next} found>=2{print}' "$file"
}

# Leer campos del rol
role_name=$(get_field "$role_file" "name")
role_description=$(get_field "$role_file" "description")
role_caps=$(get_field "$role_file" "capabilities_required" | tr -d '[]' | tr ',' ' ' | xargs || true)

# Fallback a nombre del archivo si no hay front-matter
if [[ -z "$role_name" ]]; then
  role_name=$(basename "$(dirname "$role_file")" | sed 's/^[0-9]*_//' | tr '_' ' ')
fi
if [[ -z "$role_description" ]]; then
  role_description="Agente especializado en $(echo "$ROLE" | tr '/' ' ')"
fi

# Extraer contenido del rol (backstory)
backstory=$(get_content "$role_file" | head -50 | sed "s/'/\\\'/g")

# Construir lista de tools desde capabilities
tools_list=""
if [[ -n "$role_caps" ]]; then
  for cap in $role_caps; do
    case "$cap" in
      web-search)      tools_list="${tools_list}    web_search_tool,\n" ;;
      code-execution)  tools_list="${tools_list}    code_execution_tool,\n" ;;
      vision)          tools_list="${tools_list}    image_analysis_tool,\n" ;;
      file-analysis)   tools_list="${tools_list}    file_read_tool,\n" ;;
    esac
  done
fi

# Nombre de variable Python (sanitizado)
var_name=$(echo "$role_name" | tr '[:upper:]' '[:lower:]' | tr ' /-' '_' | sed 's/__*/_/g' | sed 's/^_//;s/_$//')
[[ -z "$var_name" ]] && var_name="agent"

# Generar código Python
cat <<PYTHON
#!/usr/bin/env python3
"""
Agente CrewAI generado desde: disciplines/$DISC/roles/$ROLE
Disciplina: $DISC | Adapter: $ADAPTER

Generado con: scripts/generate_crewai.sh $DISC $ADAPTER $ROLE
"""

from crewai import Agent, Task, Crew, Process
from crewai_tools import SerperDevTool, CodeInterpreterTool  # Ajustar según capabilities


# --- Tool stubs (reemplazar con implementaciones reales) ---
# Capabilities requeridas por el rol: ${role_caps:-ninguna}
PYTHON

if [[ -n "$tools_list" ]]; then
cat <<PYTHON
web_search_tool = SerperDevTool()           # pip install crewai-tools
code_execution_tool = CodeInterpreterTool() # pip install crewai-tools
image_analysis_tool = None                  # Implementar con wrapper tools/wrappers/image_analysis.py
file_read_tool = None                       # Implementar según necesidad

PYTHON
fi

cat <<PYTHON
# --- Agente: ${role_name} ---
${var_name} = Agent(
    role="${role_name}",
    goal="${role_description}",
    backstory="""
$(echo "$backstory" | head -20 | sed 's/^/    /')
    """,
    tools=[
$(printf "%b" "${tools_list:-        # Sin tools declaradas\n}")
    ],
    verbose=True,
    allow_delegation=False,
    # llm=...  # Opcional: especificar modelo (default: usa OPENAI_API_KEY o ANTHROPIC_API_KEY)
)


# --- Tarea ejemplo ---
task_${var_name} = Task(
    description="""
    Ejecuta tu rol de '${role_name}' sobre la siguiente tarea:
    {task_input}
    """,
    expected_output="Resultado detallado del análisis o generación según el rol.",
    agent=${var_name},
)


# --- Crew (un agente, una tarea) ---
crew = Crew(
    agents=[${var_name}],
    tasks=[task_${var_name}],
    process=Process.sequential,
    verbose=True,
)


if __name__ == "__main__":
    import sys
    task_input = sys.argv[1] if len(sys.argv) > 1 else "Describe tu tarea aquí."
    result = crew.kickoff(inputs={"task_input": task_input})
    print(result)
PYTHON
