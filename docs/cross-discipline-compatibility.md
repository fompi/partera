# Matriz de compatibilidad cross-disciplinar

**Propósito**: Definir qué combinaciones **disciplina + adaptador + rol** son válidas, cómo se relacionan los roles entre disciplinas en flujos de trabajo compuestos, y qué combinaciones deben ser rechazadas (p. ej. por el script de validación o por `compose.sh`).

## Descripción

Este documento describe las relaciones entre roles de distintas disciplinas y las restricciones de compatibilidad. Las conexiones entre disciplinas muestran que el sistema no es un conjunto de silos sino una red de roles colaborativos.

## Mapa de conexiones cross-disciplinares

| Desde | Hacia | Relación |
| ----- | ----- | -------- |
| `business.plan.0000_presales` | `engineering.plan.0000_tech-estimator` | Validación técnica de la propuesta comercial |
| `business.plan.0000_presales` | `content.generate.0003_copywriter` | Generación del copy para la propuesta ejecutiva |
| `design.create.0000_web-designer` | `engineering.generate.0005_frontend-dev` | Entrega de mockups para implementación |
| `design.create.0001_ux-researcher` | `design.create.0000_web-designer` | Research de usuarios informa las decisiones de diseño |
| `engineering.generate.0002_implementer` | `content.generate.0001_doc-writer` | Código implementado → documentación técnica |
| `management.plan.0000_project-manager` | `engineering.plan.0000_tech-estimator` | Estimación técnica alimenta el plan de proyecto |
| `business.plan.0000_presales` | `management.plan.0000_project-manager` | Business case aprobado inicia la planificación |
| `engineering.plan.0000_tech-estimator` | `management.plan.0000_project-manager` | Estimación técnica alimenta el plan de proyecto |
| `content.generate.0000_clickbait-writer` | `content.audit.0000_content-auditor` | Titulares generados → revisión editorial |
| `content.generate.0003_copywriter` | `content.audit.0000_content-auditor` | Copy generado → auditoría de calidad y compliance |

## Flujos de trabajo compuestos

### Flujo: Lanzamiento de producto

```text
business.plan.0000_presales
  ↓ (business case aprobado)
engineering.plan.0000_tech-estimator + management.plan.0000_project-manager
  ↓ (spec + plan)
design.create.0001_ux-researcher
  ↓ (research completado)
design.create.0000_web-designer
  ↓ (mockups)
engineering.generate.0002_implementer + engineering.generate.0005_frontend-dev
  ↓ (código implementado)
content.generate.0001_doc-writer
  ↓ (documentación)
content.generate.0003_copywriter → content.audit.0000_content-auditor
  (copy de lanzamiento auditado)
```

### Flujo: Propuesta comercial

```text
business.plan.0000_presales
  ↓ (necesita validación técnica)
engineering.plan.0000_tech-estimator
  ↓ (estimación técnica)
business.plan.0000_presales (integra estimación)
  ↓ (business case con números)
content.generate.0003_copywriter
  (copy ejecutivo de la propuesta)
```

### Flujo: Feature de producto con investigación

```text
design.create.0001_ux-researcher
  ↓ (personas, journey maps, pain points)
design.create.0000_web-designer
  ↓ (mockups validados)
engineering.generate.0005_frontend-dev
  ↓ (implementación)
content.generate.0001_doc-writer
  (documentación de la feature)
```

## Reglas de compatibilidad

### Compatibilidades válidas (ejemplos)

| Discipline | Adapter | Role | Válido |
| ---------- | ------- | ---- | ------ |
| content | news | generate/0000_clickbait-writer | ✓ |
| content | technical | generate/0001_doc-writer | ✓ |
| content | marketing | generate/0003_copywriter | ✓ |
| content | internal | generate/0002_ops-procedures | ✓ |
| design | web | create/0000_web-designer | ✓ |
| design | mobile | create/0001_ux-researcher | ✓ |
| business | saas | plan/0000_presales | ✓ |
| business | ecommerce | plan/0000_presales | ✓ |
| management | agile | plan/0000_project-manager | ✓ |
| management | waterfall | plan/0000_project-manager | ✓ |

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
