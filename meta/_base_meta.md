---
id: meta.base
type: meta
name: "Base Meta"
version: 2.0.0
description: "Instrucciones base para todos los meta-prompts generadores"
tags: [meta, generator, base]
estimated_tokens: 450
migrated_from: "meta/_base_meta.md (v1)"
---

# Base de Meta-Prompts

> **Uso**: este prompt se compone con un meta-prompt específico (`meta/*.md`).
> Concatenar en orden: **_base_meta → meta-prompt**. Usar `compose.sh --meta <prompt>` para automatizarlo.

---

## Idioma

Responde en el idioma en que está escrito este prompt.

## Contexto del sistema de prompts

Este repositorio contiene un **sistema universal modular de prompts** compuesto por 11 tipos de capas composables que cubren múltiples disciplinas profesionales:

```
_base.md                              →  Contrato universal (anti-alucinación, CoT, formato de hallazgo)
  + disciplines/<disc>/_base.md       →  Base de disciplina (principios, estándares, ética profesional)
    + disciplines/<disc>/adapters/    →  Adaptador de contexto (lenguaje, plataforma, modelo de negocio...)
      + [knowledge/<pack>.md]         →  Conocimiento de referencia opcional
        + disciplines/<disc>/roles/   →  Rol funcional (<verb>/<name>/_index.md)
          + [techniques/<area>/]      →  Técnicas reutilizables cross-disciplinares
            + [modifiers/<type>/]     →  Modificadores de output (audiencia, profundidad, industria)
              + [sources/<name>.md]   →  Restricciones de fuentes de información
                + [protocols/<name>.md]  →  Protocolo de ejecución (autónomo, supervisado...)
                  + [capabilities/]   →  Capacidades requeridas del LLM
                    + [runtimes/]     →  Adaptaciones de runtime (Claude, OpenAI, CrewAI...)
```

**Disciplinas disponibles**: engineering, content, design, business, management

**Convenciones del sistema**:
- Cada pieza tiene front-matter YAML con `id`, `type`, `version`, `description`.
- Los roles usan path `discipline/verb/name/_index.md` (ej. `engineering/audit/01_security/_index.md`).
- El ID de rol en chains sigue el formato `discipline.verb.name` (ej. `engineering.audit.01_security`).
- Las técnicas son cross-disciplinares y viven en `techniques/<area>/`.
- Las chains declaran secuencias de roles en `chains/*.chain` con front-matter YAML.
- La composición se orquesta via `compose.sh` con `EXT=` para capas opcionales.
- `DISC=<disciplina>` selecciona la disciplina activa; `RUNTIME=<name>` añade el runtime.

## Anti-alucinación

Si no puedes demostrar un problema en el prompt con evidencia verificable, márcalo explícitamente como **hipótesis** — nunca como hallazgo confirmado. Indica qué información adicional necesitarías para confirmarlo.

## Principios de evaluación de prompts

1. **Especificidad > generalidad**: cada instrucción debe ser lo bastante concreta para que dos LLMs distintos produzcan resultados comparables.
2. **Completitud sin redundancia**: cubrir todas las áreas relevantes sin duplicar contenido entre capas.
3. **Calibración de severidades**: los criterios de clasificación deben producir distribuciones realistas (no todo es "crítico").
4. **Accionabilidad**: cada instrucción debe traducirse en un paso verificable del output.
5. **Robustez ante variación de input**: el prompt debe funcionar con contextos de distintos tamaños, disciplinas y dominios.
6. **Composabilidad**: cada componente debe funcionar tanto aislado como compuesto con otros.
7. **Mínimo acoplamiento entre capas**: cada capa no debe depender de detalles de otras capas adyacentes.
8. **Cross-disciplinar donde aplique**: preferir abstracciones reutilizables en múltiples disciplinas.

## Plantilla de hallazgo para meta-evaluación

Usa esta plantilla para cada problema encontrado en un prompt:

- **ID**: `META-001`, `META-002`, ...
- **Componente afectado**: archivo y sección del prompt
- **Tipo de problema**: Ambigüedad | Omisión | Redundancia | Inconsistencia | Sesgo | Fragilidad | Acoplamiento
- **Severidad**: Alta | Media | Baja
- **Evidencia**: qué observaste exactamente en el prompt
- **Impacto**: cómo afecta al output del LLM (falsos positivos, omisiones, inconsistencia entre runs)
- **Propuesta de mejora**: texto concreto de reemplazo o adición
- **Validación sugerida**: cómo verificar que la mejora funciona
