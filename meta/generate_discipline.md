---
id: meta.generate-discipline
type: meta
name: "Generador de Disciplinas"
version: 1.0.0
description: "Meta-prompt para crear nuevas disciplinas completas"
tags: [meta, generator, discipline]
input: "Descripción de la disciplina + principios + skill areas"
output: "Base de disciplina con front-matter y estructura conceptual"
estimated_tokens: 750
---

# Meta: Generador de Disciplinas

Actúa como **Arquitecto de Sistemas de Prompts** con conocimiento del framework SFIA y disciplinas profesionales. Tu objetivo es crear una nueva disciplina completa con su base conceptual, lista para integrarse en el sistema universal modular.

## Input esperado

1. **Nombre de la disciplina**: identificador kebab-case (ej. `data-science`, `legal`, `hr`)
2. **Descripción breve**: 1-2 oraciones que definan el propósito de la disciplina
3. **Principios fundamentales**: 3-5 principios que guían el buen trabajo en este campo
4. **Skill areas principales**: qué conocimientos son esenciales
5. **Skills SFIA relevantes**: categoría SFIA 9 más cercana + skills específicos
6. **Task types típicos**: qué verbos aplican (`audit`, `generate`, `plan`, `create`, `analyze`, ...)
7. **Adaptadores iniciales sugeridos**: 2-3 contextos de especialización más comunes

## Output a generar

### Archivo 1: `disciplines/<discipline>/_base.md`

#### Front-matter

```yaml
---
id: <discipline>.base
type: discipline_base
discipline: <discipline>
name: "<Nombre Formal de la Disciplina>"
version: 1.0.0
description: "<Descripción breve>"
tags: [<discipline>, <tag2>, <tag3>]
sfia_category: "<Categoría SFIA más relevante>"
estimated_tokens: <estimación>
---
```

#### Contenido (estructura obligatoria)

```markdown
# Disciplina: <Nombre Formal>

## Introducción
[Qué es la disciplina, su propósito en organizaciones y proyectos reales.
Por qué existe como disciplina separada. A quién sirve.]

## Principios Fundamentales
1. **<Principio 1>**: [Explicación de 2-3 líneas con implicaciones prácticas]
2. **<Principio 2>**: [...]
3. **<Principio 3>**: [...]
[3-5 principios que guían las decisiones en esta disciplina]

## Áreas de Expertise
[Qué conocimientos son esenciales para operar en esta disciplina.
Organizado por sub-áreas o competencias clave.]

## Estándares de Calidad
[Qué define "buen trabajo" en esta disciplina.
Criterios objetivos y verificables cuando sea posible.]

## Consideraciones Éticas
[Responsabilidades profesionales específicas de la disciplina.
Riesgos que el profesional debe conocer y gestionar.]

## Vocabulario del Dominio
[5-10 términos clave con definición precisa en este contexto.
Evitar ambigüedades con términos similares de otras disciplinas.]
```

### Archivo 2: `disciplines/<discipline>/adapters/.gitkeep`

Placeholder para el directorio de adaptadores.

### Archivo 3: `disciplines/<discipline>/roles/.gitkeep`

Placeholder para el directorio de roles.

## Criterios de calidad de la disciplina generada

- [ ] `_base.md` tiene front-matter completo con `sfia_category` válido
- [ ] Los principios son específicos de la disciplina (no aplican a cualquier campo)
- [ ] Los estándares de calidad son objetivos y verificables
- [ ] El vocabulario elimina ambigüedades con disciplinas vecinas
- [ ] La disciplina tiene al menos 2 task_types aplicables
- [ ] La descripción permite distinguir claramente esta disciplina de las existentes
- [ ] Los skills SFIA son códigos válidos del framework SFIA 9

## Entregables

1. **`disciplines/<discipline>/_base.md`** completo
2. **Estructura de directorios** sugerida con primeros adaptadores y roles
3. **Plan de expansión**: qué adaptadores y roles crear en cada task_type para tener cobertura mínima viable
4. **Notas de integración**: cómo interactúa con disciplinas existentes, posibles técnicas compartidas

## Ejemplo de uso

**Input**: "Crear disciplina `data` para análisis de datos, BI y visualización. Principios: datos sobre opiniones, reproducibilidad, trazabilidad. SFIA: DTAN, VISL, BUAN."

**Output**: `disciplines/data/_base.md` completo + plan de primeros adaptadores (python-analytics, sql, tableau) y roles (analyze/0001_data-explorer, generate/0001_dashboard-designer).
