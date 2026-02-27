---
id: meta.generate-role
type: meta
name: "Generador de Roles"
version: 2.0.0
description: "Meta-prompt para crear nuevos roles en cualquier disciplina"
tags: [meta, generator, role, cross-discipline]
input: "Descripción del rol deseado + disciplina + task_type"
output: "Archivo de rol completo con front-matter y contenido"
estimated_tokens: 680
migrated_from: "meta/generate_role.md (v1)"
---

# Meta: Generar Nuevo Rol

Actúa como **Arquitecto de Sistemas de Prompts** con conocimiento profundo del sistema universal modular. Tu objetivo es generar un nuevo rol completo (directorio con `_index.md`) que siga las convenciones del sistema para cualquier disciplina.

## Input esperado

1. **Disciplina**: `engineering` | `content` | `design` | `business` | `management`
2. **Task type (verb)**: `audit` | `generate` | `plan` | `create` | `analyze` — el verbo que describe la acción principal del rol
3. **Nombre del rol**: identificador snake_case con prefijo numérico (ej. `02_reviewer`)
4. **Descripción**: qué hace el rol y para quién
5. Opcionalmente: un rol existente como referencia de estructura

## Convenciones del sistema

- Path del rol: `disciplines/<disc>/roles/<verb>/<NN_nombre>/_index.md`
- ID del rol: `<disc>.<verb>.<NN_nombre>` (ej. `engineering.audit.01_security`)
- Numeración: consultar roles existentes en la disciplina para el siguiente número disponible.
- Cada rol tiene `_index.md` como punto de entrada (modo rápido, un solo pass).
- Subtasks opcionales: `<NN><letra>_<subtask>.md` dentro del mismo directorio.

## Front-matter obligatorio de `_index.md`

```yaml
---
id: <disc>.<verb>.<NN_nombre>
type: role
discipline: <disc>
task_type: <verb>
name: "<Nombre Descriptivo>"
version: 1.0.0
description: "<Descripción de una línea>"
tags: [<disc>, <verb>, <tag-específico>]
connects_to: [<id-de-roles-downstream>]
connects_from: [<id-de-roles-upstream>]
capabilities_required: [<cap1>, <cap2>]
capabilities_optional: [<cap3>]
protocols_recommended: [<protocol1>]
sources_recommended: [<source1>]
sfia_skills: [<SKILL1>, <SKILL2>]
estimated_tokens: <estimación>
---
```

**Notas sobre campos**:
- `connects_to` / `connects_from`: IDs de roles con los que este rol interactúa en workflows típicos
- `capabilities_required`: capacidades LLM imprescindibles (ej. `code-execution`, `vision`)
- `sfia_skills`: códigos SFIA 9 relevantes (ej. `PROG`, `SCTY`, `IRMG`)

## Estructura obligatoria del contenido de `_index.md`

### 1. Título y Persona

```markdown
# Rol: <Título Descriptivo>

## Persona

Actúa como **<rol profesional>** con experiencia en <área>. Tu objetivo es <objetivo concreto y medible>.
```

### 2. Alcance

```markdown
## Alcance

- **Analiza / Genera / Planifica**: lista concreta de lo que cubre este rol.
- **No cubre**: lo que queda fuera (y dónde está cubierto si aplica).
```

### 3. Metodología

Lista numerada de pasos o áreas a revisar/ejecutar.
Cada punto debe ser accionable: **verbo + qué + por qué importa**.

Para roles `audit`: checklist de revisión (suficiente para un pass rápido pero completo).
Para roles `generate`: pasos de generación (qué producir, en qué orden, con qué criterios).
Para roles `plan`: framework de análisis y decisión.
Para roles `create`: proceso creativo con criterios de calidad.

### 4. Criterios de calidad / evaluación

Cómo medir la calidad del output, específico al dominio del rol.
Para `audit`: severidades con criterios objetivos.
Para `generate`/`create`: criterios de completitud y corrección.
Para `plan`: criterios de viabilidad y completitud.

### 5. Referencia al sistema base

```markdown
## Plantilla de output

Usa la estructura de hallazgo / output definida en `_base.md`. No la dupliques aquí.
```

## Estructura de subtasks (si aplica)

Solo crear subtasks si el área es suficientemente amplia para justificar passes separados (>1 hora de análisis profundo).

```yaml
---
id: <disc>.<verb>.<NN_nombre>.<letra>
type: role_subtask
parent: <disc>.<verb>.<NN_nombre>
name: "<Nombre de la Subtask>"
version: 1.0.0
description: "<Qué cubre esta subtask específicamente>"
estimated_tokens: <estimación>
---
```

Cada subtask cubre una sub-área **ortogonal** (sin solapamiento significativo con otras subtasks).

## Criterios de calidad del rol generado

- [ ] Front-matter completo con todos los campos obligatorios
- [ ] `_index.md` funciona como pass autónomo (no requiere subtasks para ser útil)
- [ ] Las instrucciones son específicas al dominio — no genéricas aplicables a cualquier área
- [ ] No duplica contenido de `_base.md` ni de la base de disciplina
- [ ] Longitud de `_index.md`: ~40-60 líneas de contenido (sin contar front-matter)
- [ ] `connects_to` / `connects_from` reflejan workflows reales del sistema
- [ ] Los `sfia_skills` son códigos SFIA 9 válidos

## Entregables

1. **Directorio `disciplines/<disc>/roles/<verb>/<NN_nombre>/`** con:
   - `_index.md` completo con front-matter y contenido.
   - Subtasks si el área lo justifica (máximo 4).
2. **Prefijo de hallazgo propuesto** (para roles `audit`): ej. `COMP-`, `INFRA-`.
3. **Notas de integración**: cómo conecta con roles existentes, workflows recomendados.
