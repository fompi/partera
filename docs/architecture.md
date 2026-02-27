# Arquitectura del Sistema Universal de Prompts Modulares

## Visión General

Este sistema implementa un enfoque de **composición modular** para prompts de IA: en lugar de un único megaprompt monolítico, cada prompt se construye concatenando capas especializadas. Cada capa aporta un tipo específico de contexto, sin duplicar el de las demás.

El resultado es un sistema donde se pueden expresar instrucciones complejas y especializadas con muy poco esfuerzo de composición, y donde cada pieza puede mantenerse, mejorarse y reutilizarse de forma independiente.

---

## Las 11 Capas Composables

### Capa 1: `base` — Contrato Universal

**Archivo**: `_base.md`

Establece las reglas universales que aplican a cualquier composición del sistema, independientemente de la disciplina o el rol:

- Principio de anti-alucinación (distinguir hallazgos de hipótesis)
- Framework de Chain-of-Thought para razonamiento estructurado
- Plantilla canónica de hallazgo/output
- Idioma de respuesta

**Por qué existe**: garantiza que todos los outputs del sistema tengan un estándar mínimo de rigor y formato, sin que cada rol deba redefinirlo.

### Capa 2: `discipline_base` — Base de Disciplina

**Directorio**: `disciplines/<disc>/_base.md`

Define los fundamentos de una disciplina profesional: sus principios, estándares de calidad, consideraciones éticas y vocabulario. Es el contexto que diferencia cómo piensa un ingeniero de cómo piensa un diseñador o un gestor de proyectos.

**Por qué existe**: permite que el mismo rol estructural (ej. "auditor") funcione de forma diferente según la disciplina, sin duplicar contenido.

### Capa 3: `adapter` — Adaptador de Contexto

**Directorio**: `disciplines/<disc>/adapters/`

Especializa la disciplina para un contexto concreto: un lenguaje de programación, una plataforma de diseño, un modelo de negocio, una metodología de gestión. Aporta convenciones específicas, anti-patterns y tooling del contexto.

**Por qué existe**: la diferencia entre auditar código Python y código Go no está en el rol (seguridad) sino en el adaptador. Separar este contexto permite reutilizar los roles con cualquier lenguaje.

### Capa 4: `knowledge` — Knowledge Pack

**Directorio**: `knowledge/`

Conocimiento de referencia curado que se inyecta opcionalmente. Por ejemplo, un diseñador que necesita nociones básicas de ingeniería para colaborar con un equipo técnico.

**Por qué existe**: permite enriquecer un rol con conocimiento de otras disciplinas sin contaminar la base de la disciplina ni el rol con información que no siempre es necesaria.

### Capa 5: `role` — Rol Funcional

**Directorio**: `disciplines/<disc>/roles/<verb>/<name>/_index.md`

El corazón del sistema: define una **persona profesional** con objetivos concretos, un alcance claro y una metodología paso a paso. El rol es el único componente que da instrucciones activas al LLM sobre qué hacer.

**Por qué existe**: es la unidad de trabajo del sistema. Todo lo anterior es contexto; el rol es la instrucción.

### Capa 6: `technique` — Técnica Reutilizable

**Directorio**: `techniques/<area>/`

Componentes metodológicos cross-disciplinares que se pueden inyectar en cualquier rol. Por ejemplo, `injection-analysis` es una técnica de seguridad útil tanto para ingeniería como para diseño de formularios.

**Por qué existe**: evita duplicar metodologías en múltiples roles. Una técnica se mantiene en un solo lugar y mejora automáticamente todos los roles que la referencian.

### Capa 7: `modifier` — Modificador de Output

**Directorio**: `modifiers/<type>/`

Ajusta cómo debe presentarse el output: para una audiencia ejecutiva vs. técnica, con análisis superficial vs. profundo, o adaptado a una industria regulada.

**Por qué existe**: el mismo análisis de seguridad necesita formatos radicalmente distintos para un CISO y para un desarrollador junior.

### Capa 8: `source` — Restricción de Fuentes

**Directorio**: `sources/`

Instruye al LLM sobre qué fuentes de información debe consultar o priorizar: solo documentación oficial, solo fuentes académicas, solo fuentes internas.

**Por qué existe**: algunos contextos (healthcare, legal, fintech) requieren que la información provenga exclusivamente de fuentes verificadas.

### Capa 9: `protocol` — Protocolo de Ejecución

**Directorio**: `protocols/`

Define el modo de interacción: autónomo (ejecuta sin confirmación), supervisado (pide confirmación en cada paso), colaborativo (trabaja en diálogo con el usuario), pedagógico (explica mientras hace).

**Por qué existe**: el mismo rol puede necesitar modos de ejecución radicalmente distintos según el contexto de uso.

### Capa 10: `capability` — Capacidad del LLM

**Directorio**: `capabilities/`

Declara y activa capacidades específicas del LLM: visión (análisis de imágenes), ejecución de código, búsqueda web, generación de diagramas.

**Por qué existe**: algunos roles solo tienen sentido si el LLM puede ejecutar código o analizar imágenes. Declararlo explícitamente mejora la calidad del output.

### Capa 11: `runtime` — Adaptación de Runtime

**Directorio**: `runtimes/`

Adapta el prompt al runtime o framework específico: formato de system message para Claude, definición de agente para CrewAI, chain para LangChain.

**Por qué existe**: el mismo prompt semántico necesita formatos técnicos distintos según dónde se ejecuta.

---

## Orden de Composición

```
base → discipline_base → adapter → [knowledge] → role
     → [techniques] → [modifiers] → [sources]
     → [protocols] → [capabilities] → [runtime]
```

El orden importa: las capas anteriores establecen el contexto en el que las posteriores operan. El rol (capa 5) puede asumir que ya existe un contrato universal (capa 1), los principios de la disciplina (capa 2) y las convenciones del adaptador (capa 3).

---

## Decisiones de Diseño

### ¿Por qué no un único megaprompt?

Un megaprompt tiene tres problemas prácticos:

1. **Mantenimiento**: cambiar la plantilla de hallazgo requiere editar todos los prompts.
2. **Combinatoria**: con 2 adaptadores × 5 roles = 10 prompts únicos; con el sistema modular = 2 + 5 = 7 archivos.
3. **Contexto**: los LLMs tienen ventanas de contexto finitas; la modularidad permite incluir solo lo necesario.

### ¿Por qué front-matter YAML?

El front-matter YAML en cada archivo permite:

- **Descubrimiento automático**: `list_by_type.sh` puede listar todos los roles o técnicas sin parsear markdown.
- **Validación**: `validate_frontmatter.sh` verifica campos obligatorios y formatos.
- **Generación**: los meta-prompts pueden generar archivos con front-matter correcto.
- **Trazabilidad SFIA**: el campo `sfia_skills` mapea directamente al framework de competencias.

### ¿Por qué separar disciplinas en namespaces?

Sin disciplinas, `audit/security` puede significar auditoría de código, auditoría de contenido editorial, o auditoría de una propuesta de negocio. Con disciplinas, `engineering.audit.01_security` es inequívoco.

Además, la separación permite que equipos distintos mantengan sus disciplinas de forma independiente, y que las disciplinas evolucionen a velocidades distintas.

### ¿Por qué técnicas reutilizables en lugar de subtasks?

En el sistema v1, las subtasks vivían dentro de roles específicos. El problema: `injection-analysis` fue escrita para `engineering.audit.security`, pero es igualmente útil para `design.create.web-designer` al analizar formularios.

Las técnicas en `techniques/` son ciudadanos de primera clase: tienen su propio front-matter, su propio ciclo de vida, y pueden componer en cualquier disciplina.

---

## Patrones de Composición

### Composición mínima (auditoría rápida)
```
base + engineering._base + python + security_role
```

### Composición completa (análisis profundo)
```
base + engineering._base + python + security-awareness
    + security_role + injection-analysis + secrets-crypto
    + modifier/deep + source/official-docs-only
    + protocol/autonomous + capability/code-execution
    + runtime/claude
```

### Composición cross-disciplinar (diseñador con conocimiento técnico)
```
base + design._base + web + knowledge/engineering-basics
    + web-designer_role + knowledge/security-awareness
```

---

## Comparación con SFIA 9

El framework SFIA (Skills Framework for the Information Age) define categorías y skills de competencia profesional. Este sistema mapea sus piezas a SFIA para ofrecer trazabilidad y orientación sobre qué skills se necesitan para cada rol.

Ver [`docs/sfia-mapping.md`](sfia-mapping.md) para el mapeo completo.

### Correspondencia conceptual

| Elemento SFIA | Elemento del sistema |
|---------------|---------------------|
| Categoría (ej. Solution Development) | Disciplina (engineering) |
| Subcategoría (ej. Programming/software dev) | Task type (generate) |
| Skill (ej. PROG) | Rol específico + técnicas |
| Nivel de responsabilidad | Modifier (audience/executive vs junior) |

---

## Comparación con Otros Sistemas

### vs Fabric

[Fabric](https://github.com/danielmiessler/fabric) es una biblioteca de prompts plana enfocada en ingeniería.

| Aspecto | Este sistema | Fabric |
|---------|-------------|--------|
| Estructura | 11 capas composables | Biblioteca plana |
| Cross-disciplinar | Sí (5 disciplinas) | No (principalmente ingeniería) |
| Metadata | YAML front-matter validado | Sin metadata |
| Chains | Declarativas con front-matter | Ad-hoc |
| SFIA mapping | Sí | No |
| Validación automática | Sí | No |

### vs CrewAI

[CrewAI](https://github.com/joaomdmoura/crewAI) es un framework de agentes multi-role.

| Aspecto | Este sistema | CrewAI |
|---------|-------------|--------|
| Naturaleza | Sistema de prompts | Framework de ejecución |
| Runtime | Cualquiera | Propio (Python) |
| Composición | Texto plano | Código Python |
| Multi-agente | Via chains | Nativo |
| UI | No | No |

Este sistema puede **generar definiciones CrewAI** via `make generate-crewai`.

### vs LangChain

[LangChain](https://github.com/langchain-ai/langchain) es un framework para construir aplicaciones LLM.

| Aspecto | Este sistema | LangChain |
|---------|-------------|-----------|
| Naturaleza | Sistema de prompts | Framework de código |
| Prompt templates | Markdown plano | Python/LCEL |
| Chains | YAML declarativas | Código Python |
| Runtime | Agnóstico | Propio (Python) |

### vs MetaGPT

[MetaGPT](https://github.com/geekan/MetaGPT) asigna roles de una empresa de software a LLMs.

| Aspecto | Este sistema | MetaGPT |
|---------|-------------|---------|
| Scope | 5 disciplinas profesionales | Empresa de software |
| Roles | Configurables | Fijos (PM, Engineer, QA...) |
| Cross-disciplinar | Sí | No |

---

## Qué tiene este sistema que no tienen otros

1. **Cross-disciplinar real**: no solo código; también contenido, diseño, negocio y gestión
2. **Metadata estructurada**: descubrimiento, validación y generación automatizados
3. **Interfaces declarativas**: cada pieza declara input/output/connections en front-matter
4. **SFIA-mapped**: trazabilidad a framework profesional reconocido internacionalmente
5. **Runtime-agnostic**: funciona con cualquier LLM o framework, sin lock-in
6. **Técnicas reutilizables**: cross-disciplinares, mantenidas una sola vez
7. **Validación automática**: scripts verifican consistencia del sistema

## Qué tienen otros sistemas que este no tiene

1. **Runtime multi-agente completo**: CrewAI, AutoGen tienen orquestación nativa de múltiples agentes
2. **UI visual**: algunos frameworks tienen interfaces gráficas de construcción
3. **Telemetría y observability**: built-in en algunos frameworks (LangSmith, etc.)
4. **Integración con bases de datos vectoriales**: RAG nativo
5. **Evaluación automática de outputs**: benchmarking de prompts

---

## Extensión del Sistema

Para añadir una nueva disciplina, adaptador, rol o técnica, ver los meta-prompts en `meta/`:

```bash
# Generar un nuevo rol
cat meta/_base_meta.md meta/generate_role.md > /tmp/meta-role.txt
# → Pegar en LLM con descripción del rol deseado

# Generar un nuevo adaptador
cat meta/_base_meta.md meta/generate_adapter.md > /tmp/meta-adapter.txt

# Generar una nueva disciplina completa
cat meta/_base_meta.md meta/generate_discipline.md > /tmp/meta-discipline.txt

# Evaluar cobertura del sistema
cat meta/_base_meta.md meta/evaluate_coverage.md > /tmp/meta-coverage.txt
```
