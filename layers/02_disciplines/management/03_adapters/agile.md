---
id: management.adapter.agile
type: adapter
discipline: management
name: "Agile"
version: 1.0.0
description: "Adaptador para gestión ágil (Scrum, Kanban)"
tags: [agile, scrum, kanban, sprint]
estimated_tokens: 350
---

# Adaptador: Agile

## Contexto de uso

Proyectos gestionados con metodologías ágiles: Scrum para proyectos con iteraciones definidas, Kanban para flujos continuos. Aplica a equipos de desarrollo de software, aunque los principios son trasladables a otros contextos.

## Scrum: roles, artefactos y ceremonias

### Roles
- **Product Owner (PO)**: dueño del backlog y de la priorización; representa al negocio.
- **Scrum Master (SM)**: facilitador del proceso; elimina impedimentos; no es jefe de proyecto.
- **Development Team**: autoorganizado; comprometido con el sprint goal.

### Artefactos
- **Product Backlog**: lista priorizada de todo lo que el producto debe hacer.
- **Sprint Backlog**: items seleccionados para el sprint actual + plan para entregarlos.
- **Increment**: suma de todos los items completados, en estado "Done".

### Ceremonias
| Ceremonia | Propósito | Duración (sprint 2 semanas) |
|-----------|-----------|------------------------------|
| Sprint Planning | Seleccionar y planificar el sprint | ≤ 4h |
| Daily Scrum | Sincronización diaria del equipo | 15 min |
| Sprint Review | Demo del incremento a stakeholders | ≤ 2h |
| Retrospective | Mejora del proceso del equipo | ≤ 1.5h |
| Backlog Refinement | Preparar items para futuros sprints | ≤ 2h (ongoing) |

## Kanban: principios y métricas

- **Visualizar el flujo**: tablero con columnas que representan el proceso real.
- **Limitar el WIP (Work in Progress)**: número máximo de items por columna.
- **Gestionar el flujo**: métricas de cycle time y lead time.
- **Políticas explícitas**: criterios claros de qué significa "Done" en cada columna.
- **Mejora continua**: revisar métricas y ajustar el sistema regularmente.

## Definition of Done (DoD)

El DoD es el acuerdo del equipo sobre qué significa que algo está completo. Ejemplo:

- [ ] Código desarrollado y revisado (code review aprobado)
- [ ] Tests unitarios escritos y pasando
- [ ] Tests de integración pasando
- [ ] Documentación actualizada
- [ ] Desplegado en staging y validado
- [ ] Criterios de aceptación del PO verificados

## Anti-patrones ágiles

- **Scrum teatral**: hacer las ceremonias sin el mindset (daily de status report, retrospectivas vacías).
- **PO como proxy**: el PO no tiene acceso real a stakeholders o usuarios.
- **Sprint commitment como contrato**: el sprint goal es un objetivo, no un contrato de entrega fija.
- **No definition of Done**: items "terminados" que requieren trabajo adicional.
- **Velocity como KPI de productividad**: medir al equipo por velocidad lleva a inflación de puntos.
- **Ignorar la deuda técnica**: el backlog de tech debt también se prioriza.

## Escalado ágil

Para múltiples equipos: SAFe, LeSS o Nexus como frameworks. En general, minimizar coordinación overhead y maximizar autonomía de equipo.
