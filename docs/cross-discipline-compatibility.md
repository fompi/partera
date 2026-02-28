# Matriz de compatibilidad cross-disciplinar

**Propósito**: Definir qué combinaciones **disciplina + adaptador + rol** son válidas, cómo se relacionan los roles entre disciplinas en flujos de trabajo compuestos, y qué combinaciones deben ser rechazadas (p. ej. por el script de validación o por `compose.sh`).

## Descripción

Este documento describe las relaciones entre roles de distintas disciplinas y las restricciones de compatibilidad. Las conexiones entre disciplinas muestran que el sistema no es un conjunto de silos sino una red de roles colaborativos.

## Mapa de conexiones cross-disciplinares

| Desde | Hacia | Relación |
| ----- | ----- | -------- |
| `business.plan.00_presales` | `engineering.plan.00_tech-estimator` | Validación técnica de la propuesta comercial |
| `business.plan.00_presales` | `content.generate.03_copywriter` | Generación del copy para la propuesta ejecutiva |
| `design.create.00_web-designer` | `engineering.generate.05_frontend-dev` | Entrega de mockups para implementación |
| `design.create.01_ux-researcher` | `design.create.00_web-designer` | Research de usuarios informa las decisiones de diseño |
| `engineering.generate.02_implementer` | `content.generate.01_doc-writer` | Código implementado → documentación técnica |
| `management.plan.00_project-manager` | `engineering.plan.00_tech-estimator` | Estimación técnica alimenta el plan de proyecto |
| `business.plan.00_presales` | `management.plan.00_project-manager` | Business case aprobado inicia la planificación |
| `engineering.plan.00_tech-estimator` | `management.plan.00_project-manager` | Estimación técnica alimenta el plan de proyecto |
| `content.generate.00_clickbait-writer` | `content.audit.00_content-auditor` | Titulares generados → revisión editorial |
| `content.generate.03_copywriter` | `content.audit.00_content-auditor` | Copy generado → auditoría de calidad y compliance |

## Flujos de trabajo compuestos

### Flujo: Lanzamiento de producto

```text
business.plan.00_presales
  ↓ (business case aprobado)
engineering.plan.00_tech-estimator + management.plan.00_project-manager
  ↓ (spec + plan)
design.create.01_ux-researcher
  ↓ (research completado)
design.create.00_web-designer
  ↓ (mockups)
engineering.generate.02_implementer + engineering.generate.05_frontend-dev
  ↓ (código implementado)
content.generate.01_doc-writer
  ↓ (documentación)
content.generate.03_copywriter → content.audit.00_content-auditor
  (copy de lanzamiento auditado)
```

### Flujo: Propuesta comercial

```text
business.plan.00_presales
  ↓ (necesita validación técnica)
engineering.plan.00_tech-estimator
  ↓ (estimación técnica)
business.plan.00_presales (integra estimación)
  ↓ (business case con números)
content.generate.03_copywriter
  (copy ejecutivo de la propuesta)
```

### Flujo: Feature de producto con investigación

```text
design.create.01_ux-researcher
  ↓ (personas, journey maps, pain points)
design.create.00_web-designer
  ↓ (mockups validados)
engineering.generate.05_frontend-dev
  ↓ (implementación)
content.generate.01_doc-writer
  (documentación de la feature)
```

## Reglas de compatibilidad

### Compatibilidades válidas (ejemplos)

| Discipline | Adapter | Role | Válido |
| ---------- | ------- | ---- | ------ |
| content | news | generate/00_clickbait-writer | ✓ |
| content | technical | generate/01_doc-writer | ✓ |
| content | marketing | generate/03_copywriter | ✓ |
| content | internal | generate/02_ops-procedures | ✓ |
| design | web | create/00_web-designer | ✓ |
| design | mobile | create/01_ux-researcher | ✓ |
| business | saas | plan/00_presales | ✓ |
| business | ecommerce | plan/00_presales | ✓ |
| management | agile | plan/00_project-manager | ✓ |
| management | waterfall | plan/00_project-manager | ✓ |

### Incompatibilidades (rechazadas por el sistema)

Las siguientes combinaciones **no son válidas**: el adaptador pertenece a otra disciplina. El sistema (p. ej. `compose.sh` o los scripts de validación) debe rechazarlas porque no existe `disciplines/{discipline}/adapters/{adapter}.md`.

| Discipline | Adapter | Motivo |
| ---------- | ------- | ------ |
| content | python | El adaptador python pertenece a engineering |
| design | saas | El adaptador saas pertenece a business |
| management | bash | El adaptador bash pertenece a engineering |
| content | agile | El adaptador agile pertenece a management |

## Principio de compatibilidad

Un adaptador es compatible con una disciplina si y solo si existe el archivo:
`disciplines/{discipline}/adapters/{adapter}.md`

Los adaptadores no son globales; cada disciplina define los suyos con el contexto específico de esa disciplina. Un "web" de design (interfaces, UX) es distinto a un hipotético "web" de engineering (stack backend/frontend, deployment).
