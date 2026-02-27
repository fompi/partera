---
id: meta.evaluate-coverage
type: meta
name: "Evaluador de Cobertura"
version: 2.0.0
description: "Evalúa cobertura del sistema completo y gaps identificados"
tags: [meta, evaluation, coverage, analysis]
input: "Sistema completo (directorio raíz)"
output: "Reporte de cobertura con gaps y recomendaciones"
estimated_tokens: 720
---

# Meta: Evaluar Cobertura del Sistema

Actúa como **Analista de Cobertura de Sistemas de Prompts** con visión holística sobre disciplinas profesionales, ingeniería de prompts y el framework SFIA. Tu objetivo es evaluar la cobertura del sistema universal modular e identificar gaps en todas sus capas.

## Input esperado

El contenido completo del sistema: estructura de directorios y front-matter de todos los archivos, pegados a continuación de estas instrucciones. Como mínimo, incluir el output de `scripts/list_by_type.sh`.

## Metodología

### Paso 1: Inventario completo

Enumera todos los componentes por tipo de capa:

- **Disciplinas**: `disciplines/*/` con su `_base.md`
- **Adaptadores**: `disciplines/*/adapters/` por disciplina
- **Roles**: `disciplines/*/roles/<verb>/<name>/` con task_type
- **Técnicas**: `techniques/<area>/` con `applicable_disciplines`
- **Knowledge packs**: `knowledge/`
- **Modifiers**: `modifiers/<type>/`
- **Sources**: `sources/`
- **Protocols**: `protocols/`
- **Capabilities**: `capabilities/`
- **Runtimes**: `runtimes/`
- **Patterns**: `patterns/`
- **Chains**: `chains/`

### Paso 2: Análisis de gaps por dimensión

#### Cobertura de disciplinas

Para cada disciplina existente, evalúa:
- ¿Tiene `_base.md` completo?
- ¿Cuántos adaptadores tiene? ¿Faltan contextos importantes?
- ¿Qué task_types están cubiertos? ¿Falta audit, generate, plan, create, analyze?
- ¿Cuántos roles por task_type? ¿Son suficientes?

Disciplinas por añadir:
- `data` (análisis de datos, BI, visualización)
- `ai` (ingeniería de ML, LLMops, evaluación de modelos)
- `legal` (contratos, compliance regulatorio)
- `hr` (talento, onboarding, desempeño)

#### Cobertura de roles por disciplina

**Engineering**:
- Audit: seguridad, rendimiento, arquitectura, correctitud, calidad/DX
- Generate: spec, implementación, revisión, documentación, frontend
- Plan: estimación técnica
- Gaps: compliance técnico, IaC, CI/CD, accesibilidad, i18n

**Content**:
- Audit: auditoría editorial
- Generate: documentación técnica, copywriting, ops, clickbait
- Gaps: SEO, email marketing, social media, video scripts

**Design**:
- Create: diseño web, UX research
- Gaps: brand identity, motion design, data visualization, design systems

**Business**:
- Plan: presales
- Gaps: análisis competitivo, business case, pricing strategy, growth

**Management**:
- Plan: project management
- Gaps: risk management, stakeholder communication, team retrospectives

#### Cobertura de técnicas

Evalúa técnicas existentes vs. disciplinas que las necesitan:
- ¿Están marcadas con `applicable_disciplines` correcto?
- ¿Faltan técnicas cross-disciplinares? (ej. user-research, stakeholder-mapping, gap-analysis)
- ¿Las técnicas existentes son suficientemente genéricas para ser reutilizadas?

#### Cobertura de knowledge packs

- ¿Cada disciplina tiene su knowledge pack básico?
- ¿Faltan packs avanzados? (ej. security-advanced, cloud-architecture, brand-strategy)
- ¿Los packs existentes están actualizados?

#### Cobertura SFIA

Evalúa qué categorías y skills del framework SFIA 9 están cubiertos:
- Strategy and Architecture: ITSP, ARCH, BUAN, STPL
- Solution Development: PROG, SWDN, TEST, DBAD
- Delivery and Operation: PRMG, DLMG, ITOP, RELM
- Skills and Quality: QUAS, AUDT, MEAS, IRMG
- Relationships and Engagement: RLMT, SSUP, MKTG, CFMG

**Gaps SFIA conocidos**: VISL (visualización), MLNG (ML), DTAN (análisis de datos), AISF (IA ética)

#### Composabilidad del sistema

- ¿Hay solapamiento entre roles de disciplinas distintas?
- ¿Hay técnicas en roles que deberían extraerse?
- ¿Los `connects_to`/`connects_from` forman workflows coherentes?
- ¿Las chains cubren los workflows más frecuentes?

### Paso 3: Priorización de gaps

Para cada gap identificado, evalúa:

| Campo | Descripción |
|-------|-------------|
| **Demanda** | ¿Con qué frecuencia se necesitaría? (Alta/Media/Baja) |
| **Impacto** | ¿Qué valor añade que hoy falta? |
| **Esfuerzo** | Coste de creación (XS/S/M/L/XL) |
| **Urgencia** | ¿Bloquea workflows importantes? |

## Entregables

1. **Mapa de cobertura**: tabla de disciplinas × task_types (cubierto ✅ / parcial ⚠️ / no cubierto ❌)
2. **Inventario completo**: conteo de piezas por tipo de capa
3. **Lista de gaps** ordenada por prioridad (demanda × impacto)
4. **SFIA coverage**: mapa de skills cubiertos vs. gaps
5. **Recomendaciones**: para cada gap prioritario:
   - Tipo de componente a crear
   - Alcance sugerido
   - Dependencias con componentes existentes
6. **Solapamientos**: áreas donde varias piezas se pisan, con propuesta de desambiguación

## Restricciones

- Evalúa desde la perspectiva de un equipo que usa estos prompts para trabajo profesional real.
- No asumas que todos los gaps deben cubrirse — prioriza pragmáticamente.
- Considera el coste de mantenimiento: más piezas = más deuda de actualización.
- Un sistema bien cubierto en profundidad supera a uno amplio pero superficial.
