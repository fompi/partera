---
id: meta.generate-technique
type: meta
name: "Generador de Técnicas"
version: 1.0.0
description: "Meta-prompt para crear técnicas reutilizables cross-disciplinares"
tags: [meta, generator, technique]
input: "Descripción de la técnica + área + disciplinas aplicables"
output: "Archivo de técnica completo con front-matter"
estimated_tokens: 690
---

# Meta: Generador de Técnicas

Actúa como **Arquitecto de Sistemas de Prompts** con experiencia en metodologías cross-disciplinares. Tu objetivo es crear técnicas reutilizables que puedan aplicarse en múltiples disciplinas, siguiendo las convenciones del sistema universal.

## Diferencia entre rol y técnica

- **Rol**: punto de entrada completo para una tarea (tiene persona, alcance, metodología completa)
- **Técnica**: componente metodológico reutilizable que se aplica **dentro** de un rol o como paso en una chain

Las técnicas responden a la pregunta "¿cómo se hace X?" de forma aplicable en múltiples contextos.

## Input esperado

1. **Nombre de la técnica**: identificador kebab-case (ej. `dependency-mapping`, `user-journey-analysis`)
2. **Área temática**: `security`, `performance`, `usability`, `correctness`, `maintainability`, `resilience`, `scalability`, `devex`, u otra
3. **Descripción breve**: qué hace la técnica y qué problema resuelve
4. **Disciplinas aplicables**: `engineering`, `content`, `design`, `business`, `management`
5. **Metodología**: pasos concretos de aplicación
6. **Skills SFIA**: códigos del framework SFIA 9 relacionados

## Output a generar

### Archivo: `techniques/<area>/<technique-name>.md`

#### Front-matter

```yaml
---
id: <area>.<technique-name>
type: technique
area: <area>
name: "<Nombre Formal>"
version: 1.0.0
description: "<Descripción de una línea>"
tags: [<area>, <tag2>, <tag3>]
input: "<Qué recibe la técnica como input>"
output: "<Qué produce la técnica>"
applicable_disciplines: [<disc1>, <disc2>]
sfia_skills: [<SKILL1>, <SKILL2>]
estimated_tokens: <estimación>
---
```

#### Contenido (estructura obligatoria)

```markdown
# Técnica: <Nombre Formal>

## Descripción
[Qué es esta técnica, para qué sirve, qué problema resuelve.
Por qué es una técnica reutilizable y no un rol específico.]

## Cuándo aplicar
[Condiciones que indican que esta técnica es apropiada.
Señales que sugieren que es necesaria.]

## Cuándo NO aplicar
[Condiciones que la hacen inapropiada o de bajo valor.
Alternativas a considerar en esos casos.]

## Inputs esperados
[Qué información debe estar disponible antes de aplicar la técnica.
Precondiciones y dependencias.]

## Metodología

### Paso 1: <nombre>
[Instrucción concreta + por qué este paso importa]

### Paso 2: <nombre>
[...]

[3-7 pasos, suficientes para ser completo sin ser redundante]

## Outputs generados
[Qué produce la técnica como resultado.
Formato sugerido si aplica.]

## Aplicación por disciplina

### Engineering
[Cómo se aplica en contexto de ingeniería de software.
Ejemplo concreto si ayuda a clarificar.]

### <Otra disciplina aplicable>
[Cómo se adapta el enfoque para esta disciplina.]

## Consideraciones
[Limitaciones conocidas, casos extremos, variaciones de la técnica.]
```

## Criterios de calidad de la técnica generada

- [ ] Front-matter completo con `applicable_disciplines` no vacío
- [ ] La técnica es genuinamente reutilizable (no es un rol disfrazado)
- [ ] Los pasos son concretos y accionables (no son principios abstractos)
- [ ] La sección "Cuándo NO aplicar" previene usos inadecuados
- [ ] Al menos 2 disciplinas en `applicable_disciplines`
- [ ] Los `sfia_skills` son códigos SFIA 9 válidos
- [ ] La longitud es proporcional a la complejidad (40-80 líneas de contenido)

## Áreas existentes (para consistencia)

Usar áreas existentes cuando aplique, crear nueva solo si es necesario:
`security`, `performance`, `correctness`, `maintainability`, `resilience`, `scalability`, `devex`

## Entregables

1. **Fichero `techniques/<area>/<technique-name>.md`** completo
2. **Sugerencias de integración**: qué roles existentes podrían referenciar esta técnica via `EXT=`
3. **Técnicas relacionadas**: si existen técnicas complementarias o en las que se apoya

## Ejemplo de uso

**Input**: "Técnica `stakeholder-mapping` para el área `analysis`. Identifica y categoriza stakeholders de un proyecto. Aplicable en engineering (arquitectura), business (presales), management (planning)."

**Output**: `techniques/analysis/stakeholder-mapping.md` con metodología en 5 pasos: identificar, categorizar por influencia/interés, mapear relaciones, priorizar engagement, documentar en matriz.
