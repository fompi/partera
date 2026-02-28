# Chains y Patterns — Diseño y uso

**Objetivo**: Definir cómo funcionan los **chains** (flujos multi-paso) y los **patterns** (estilos de razonamiento reutilizables) en el sistema de prompts modulares, y cómo se integran con las 11 capas y con `compose.sh`.

**Relación con la arquitectura**: Los chains orquestan varios roles en secuencia; los patterns son capas opcionales de *razonamiento* que se inyectan vía `EXT` y se componen en un orden definido (ver [architecture.md](architecture.md)).

---

## 1. Patterns (estilos de razonamiento)

### Qué son

Un **pattern** es un fragmento de prompt que indica *cómo* debe razonar el modelo (paso a paso, con plan previo, con autocrítica, etc.), sin aportar dominio ni tarea concreta. Son reutilizables en cualquier disciplina y rol.

Ejemplos: Chain-of-Thought (CoT), Plan-and-Solve, Reflection, ReAct, Tree of Thought (ToT).

### Dónde viven

- **Directorio**: `patterns/`
- **Formato**: Markdown con front-matter YAML.
- **Listado**: `make list-patterns`

### Front-matter esperado

```yaml
---
id: pattern.<nombre>
type: pattern
name: "Nombre legible"
version: 1.0.0
description: "Una línea sobre qué hace el pattern"
tags: [pattern, reasoning, ...]
applicable_to: [all-roles]  # o lista: audit, generate, plan, ...
estimated_tokens: 190
---
```

- **applicable_to**: `all-roles` o lista de tipos de rol (audit, generate, plan, etc.) donde el pattern tiene sentido.

### Posición en la composición

Los patterns se tratan como **capa de razonamiento** y se insertan **después del adaptador y antes del knowledge** en el orden de composición, para que el estilo de razonamiento aplique a todo lo que sigue (conocimiento + rol + técnicas, etc.):

```text
base → discipline_base → adapter → [patterns] → [knowledge] → role
     → [techniques] → [modifiers] → [sources] → [protocols] → [capabilities] → [runtime]
```

Así, si incluyes `patterns/cot`, el modelo recibe la instrucción de “razonar paso a paso” antes de recibir el rol y las técnicas.

### Uso

Incluir uno o más patterns vía variable de entorno `EXT`:

```bash
# Un solo pattern
DISC=engineering EXT="patterns/cot" ./compose.sh python audit/01_security/_index

# Varios (orden: primero listado = primero en el prompt)
DISC=engineering EXT="patterns/cot patterns/plan-and-solve" ./compose.sh python generate/02_implementer/_index

# Desde un alma: definir en compose.extensions o equivalente si el alma lo soporta
```

Cada entrada en `EXT` que empiece por `patterns/` se resuelve a `patterns/<nombre>.md` y se concatena en el orden indicado.

### Contenido recomendado del .md

- **Descripción** breve del pattern.
- **Estructura** (pasos o fases).
- **Ejemplo** de uso (entrada/salida o diálogo).
- **Cuándo usar** (tipos de tarea).
- **Instrucción para el modelo**: un bloque claro que se pueda concatenar tal cual en el system prompt (por ejemplo “Razona paso a paso…” para CoT).

---

## 2. Chains (flujos multi-paso)

### Qué son los chains

Un **chain** es un flujo definido por una secuencia de **pasos**. Cada paso corresponde a un **rol** del sistema (disciplina + ruta de rol). El chain no compone un único megaprompt, sino que cada paso genera su propio prompt (mismo orden de capas: base, disciplina, adaptador, opcionalmente patterns/knowledge/techniques/modifiers, etc., y el rol del paso).

El resultado es una secuencia de prompts (uno por paso) que un orquestador externo (humano, script o framework) puede ejecutar en orden, pasando el output de un paso como input del siguiente cuando así se defina.

### Dónde viven los chains

- **Directorio**: `chains/`
- **Formato**: archivo `.chain` (Markdown con front-matter YAML que define `steps`).
- **Listado**: `make list-chains`

### Front-matter del chain

```yaml
---
id: chain.<nombre>
type: chain
name: "Nombre legible"
version: 1.0.0
description: "Descripción breve del flujo"
tags: [chain, workflow, ...]
disciplines: [engineering]   # disciplinas que intervienen
steps:
  - role: engineering.generate.00_spec-writer
    name: "Escritor de Especificaciones"
    input_from: user | previous | previous_all
    input_description: "texto libre"
    output_to: next | user | orchestrator
    output_description: "texto libre"
  # más pasos...
estimated_tokens: 2200      # suma aproximada de todos los pasos
---
```

- **role**: identificador del rol en formato `<disciplina>.<verbo>.<nombre_corto>`.  
  Se traduce a ruta: `disciplines/<disciplina>/roles/<verbo>/<nombre_corto>/_index` (o `_index.md`).  
  Ejemplo: `engineering.generate.00_spec-writer` → `engineering` + `generate/00_spec-writer/_index`.
- **name**: etiqueta del paso (para listados y resúmenes).
- **input_from**: de dónde recibe el input (`user`, `previous`, `previous_all`, etc.).
- **output_to**: a dónde va el output (`next`, `user`, `orchestrator`, etc.).

Estos campos son sobre todo documentales y para generación de resúmenes; la ejecución real la hace quien invoque el chain (p. ej. `run_chain.sh`).

### Orden de los pasos

El orden en la lista YAML es el orden de ejecución. Dependencias entre pasos (p. ej. “Paso 2 recibe de previous”) se resuelven en runtime por el orquestador, no por el formato del chain.

### Composición de cada paso

Para cada paso, el sistema debe:

1. Resolver `role` a `DISC` y ruta de rol (p. ej. `audit/01_security/_index`).
2. Llamar a `compose.sh` con ese `DISC`, el **mismo adaptador** para todo el chain y ese rol. Opcionalmente se puede permitir en el futuro `extensions` o `pattern` por paso (por ahora no es obligatorio).

Por tanto, cada paso del chain es una composición estándar de las 11 capas (con el rol del paso), con un único adaptador compartido.

### Uso de chains

```bash
# Listar chains
make list-chains

# Mostrar prompts de cada paso (sin ejecutar)
./scripts/run_chain.sh nl-to-code python

# Guardar cada paso en archivos
./scripts/run_chain.sh full-audit python --steps ./output/

# Vía Make
make chain CHAIN=full-audit ADAPTER=python
make chain CHAIN=content-pipeline ADAPTER=marketing --steps ./out/
```

El adaptador es obligatorio para poder componer; el script puede indicarlo en el mensaje de uso si falta.

### Pasos paralelos vs secuenciales

- **Secuencial**: la mayoría de chains (nl-to-code, content-pipeline). El output del paso N es input del paso N+1.
- **Paralelo**: p. ej. full-audit, donde varios auditores reciben el mismo input y sus salidas las consume un orquestador. El formato del chain no distingue paralelo vs secuencial; `input_from: previous_all` documenta que el paso recibe el agregado de pasos anteriores. La ejecución en paralelo la implementa quien corre el chain (p. ej. un script o un framework de agentes).

### Validación

- **Sintaxis**: el front-matter debe ser YAML válido.
- **Roles**: cada `role` debe resolver a un archivo existente en `disciplines/<disc>/roles/...`.
- **Schema**: se puede validar con un schema JSON (o YAML) para `.chain` si se añade `chains/_schema.yaml` y un script `scripts/validate_chains.sh` que compruebe `id`, `type`, `steps`, y la existencia de los roles.

---

## 3. Integración con el resto del sistema

### Con las 11 capas

- **Chains**: no son una capa más; son una **orquestación** de varias composiciones (cada una con las 11 capas). Cada paso = una composición con un rol distinto.
- **Patterns**: se consideran una **capa opcional de razonamiento** y se componen en un solo lugar del orden (después de adapter, antes de knowledge), como se ha indicado arriba.

### Con almas

- Un **alma** fija disciplina, rol, extensiones (técnicas, modifiers, etc.). No define un chain completo.
- Para usar un **pattern** desde un alma, el alma tendría que incluir en sus extensiones algo como `patterns/cot` (si el formato de almas lo permite en `compose.techniques` o en un futuro `compose.patterns`).
- Un **chain** puede referenciar roles que a su vez están cubiertos por almas (p. ej. security-deep); el chain solo fija la secuencia de roles y el adaptador, no las extensiones por paso. Si en el futuro se soporta “alma por paso”, se podría documentar aquí.

### Con run_chain.sh

- `run_chain.sh` lee el `.chain`, parsea `steps` y por cada paso:
  - Resuelve `role` a `DISC` y ruta de rol.
  - Invoca `compose.sh` con ese `DISC`, el adaptador dado y el rol.
- No ejecuta el LLM; solo genera los prompts. La ejecución (y el paso de outputs entre pasos) es responsabilidad del usuario o de una herramienta externa.

---

## 4. Resumen de decisiones

| Tema | Decisión |
| ------ | ---------- |
| **Patterns como capa** | Capa opcional de razonamiento; orden: después de adapter, antes de knowledge. |
| **Ruta en EXT** | `patterns/<nombre>` sin `.md`; compose.sh añade `.md` si hace falta. |
| **Chains** | Lista de pasos con `role` (disciplina.verbo.nombre); cada paso = una composición completa. |
| **Adaptador en chains** | Único para todo el chain; se pasa como argumento a `run_chain.sh` / `make chain`. |
| **Validación chains** | Recomendado: schema YAML/JSON + script que compruebe roles existentes. |
| **Ejecución** | run_chain.sh solo genera prompts; no ejecuta el modelo ni pasa datos entre pasos. |

---

## 5. Documentación relacionada

- [architecture.md](architecture.md): las 11 capas y el orden de composición.
- [README principal](../README.md): ejemplos de uso de `compose.sh` y Make.
- [almas-swarm.md](almas-swarm.md): uso de almas en contextos multi-agente.
