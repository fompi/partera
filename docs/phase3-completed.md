---
phase: 3
title: "Expansión Engineering (Generate + Plan) + Técnicas Faltantes"
status: completed
---

# Fase 3: Completada

## Resumen

Expansión de la disciplina Engineering con 12 técnicas nuevas, 6 roles de `generate` y 1 rol de `plan`. La disciplina Engineering está ahora completa con los tres task types (audit, generate, plan).

---

## Técnicas añadidas (12)

### scalability/
| Archivo | ID | Descripción |
|---|---|---|
| `horizontal-vertical-scaling.md` | `scalability.horizontal-vertical` | Evaluación de estrategias de escalado y cuellos de botella |
| `load-distribution.md` | `scalability.load-distribution` | Balanceo de carga, particionamiento y sharding |
| `caching-strategies.md` | `scalability.caching-strategies` | TTL, invalidación y coherencia de caché |

### maintainability/
| Archivo | ID | Descripción |
|---|---|---|
| `code-organization.md` | `maintainability.code-organization` | Estructura modular, cohesión y acoplamiento |
| `documentation-standards.md` | `maintainability.documentation-standards` | Documentación técnica, comments, READMEs |
| `tech-debt.md` | `maintainability.tech-debt` | Identificación y priorización de deuda técnica |

### devex/
| Archivo | ID | Descripción |
|---|---|---|
| `onboarding-friction.md` | `devex.onboarding-friction` | Fricción en setup y primeros pasos |
| `debugging-observability.md` | `devex.debugging-observability` | Logs, trazas y métricas para debugging |
| `local-dev-environment.md` | `devex.local-dev-environment` | Complejidad del entorno de desarrollo local |

### resilience/
| Archivo | ID | Descripción |
|---|---|---|
| `failure-modes.md` | `resilience.failure-modes` | SPOFs y modos de fallo en cascada |
| `recovery-strategies.md` | `resilience.recovery-strategies` | Backups, disaster recovery y rollback |
| `graceful-degradation.md` | `resilience.graceful-degradation` | Fallbacks y degradación controlada |

---

## Roles de generate (6)

Ubicación: `disciplines/engineering/roles/generate/`

| Rol | ID | Descripción |
|---|---|---|
| `00_spec-writer` | `engineering.generate.00_spec-writer` | Genera especificación formal desde requisitos ambiguos |
| `01_tech-advisor` | `engineering.generate.01_tech-advisor` | Recomienda stack tecnológico con justificación y trade-offs |
| `02_implementer` | `engineering.generate.02_implementer` | Genera código funcional desde especificación y stack |
| `03_reviewer` | `engineering.generate.03_reviewer` | Revisa código con enfoque en calidad y mantenibilidad |
| `04_documenter` | `engineering.generate.04_documenter` | Genera documentación técnica desde código y spec |
| `05_frontend-dev` | `engineering.generate.05_frontend-dev` | Genera interfaces web desde mockups/specs (requiere `vision`) |

---

## Rol de plan (1)

Ubicación: `disciplines/engineering/roles/plan/`

| Rol | ID | Descripción |
|---|---|---|
| `00_tech-estimator` | `engineering.plan.00_tech-estimator` | Estima esfuerzo, riesgos y recursos con método PERT |

---

## Scripts creados

### `scripts/validate_discipline.sh`

Valida la integridad completa de una disciplina.

```bash
./scripts/validate_discipline.sh engineering
```

Verifica:
- Existencia de `_base.md`
- Front-matter correcto en adaptadores
- Front-matter válido en todos los roles
- Referencias `connects_to` apuntan a IDs existentes
- Referencias a capabilities/protocols/sources
- Roles huérfanos (sin connects en ambas direcciones)

### `scripts/generate_discipline_graph.sh`

Genera un diagrama Mermaid de relaciones entre roles.

```bash
./scripts/generate_discipline_graph.sh engineering > docs/engineering-graph.mermaid
```

Produce subgraphs por `task_type` con colores diferenciados:
- `audit` → azul claro
- `generate` → verde claro
- `plan` → amarillo claro

---

## Grafo de relaciones

Ver: `docs/engineering-graph.mermaid`

Renderizable en [Mermaid Live Editor](https://mermaid.live) o cualquier visor compatible.

Relaciones entre los 12 roles de Engineering:

```
plan/tech-estimator → generate/spec-writer
                            ↓              ↘
                   generate/tech-advisor → generate/implementer → generate/reviewer
                                              ↓                         ↓
                                    generate/documenter ←──────────────┘

generate/frontend-dev → generate/reviewer
generate/frontend-dev → generate/documenter

audit/orchestrator ↔ audit/security
audit/orchestrator ↔ audit/performance
audit/orchestrator ↔ audit/architecture
audit/orchestrator ↔ audit/correctness
```

---

## Comandos de ejemplo

### Usar técnicas nuevas como extensión

```bash
# Análisis de escalabilidad con auditoría de arquitectura
make compose DISC=engineering ADAPTER=python ROLE=audit/03_architecture/_index \
  EXT="techniques/scalability/horizontal-vertical-scaling"

# Análisis de resiliencia + failure modes
make compose DISC=engineering ADAPTER=python ROLE=audit/03_architecture/_index \
  EXT="techniques/resilience/failure-modes"

# DevEx + maintainability combinados
make compose DISC=engineering ADAPTER=python ROLE=audit/03_architecture/_index \
  EXT="techniques/devex/onboarding-friction techniques/maintainability/tech-debt"
```

### Usar roles de generate

```bash
# Redactor de especificaciones
make compose DISC=engineering ADAPTER=python ROLE=generate/00_spec-writer/_index

# Implementador con stack definido
make compose DISC=engineering ADAPTER=python ROLE=generate/02_implementer/_index

# Frontend developer (requiere capability vision - disponible en Fase 10)
make compose DISC=engineering ADAPTER=python ROLE=generate/05_frontend-dev/_index
```

### Usar rol de plan

```bash
# Estimador técnico
make compose DISC=engineering ADAPTER=python ROLE=plan/00_tech-estimator/_index
```

---

## Estado de validación

```
Disciplina: engineering
Roles:      12
Adaptadores: 2
Errores:    0
Advertencias: 13 (todas de protocols/ no creados aún — se resuelven en Fase 10)
```

---

## Siguiente fase

**Fase 4**: Primera disciplina adicional (Data o AI), reutilizando técnicas cross-disciplina (`scalability`, `resilience`, `devex`) ya creadas en esta fase.

Los campos `applicable_disciplines: [engineering, data, ai]` en las técnicas de scalability, resilience y devex están preparados para esta expansión.
