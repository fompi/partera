# Base de Meta-Auditoría de Prompts

> **Uso**: este prompt se compone con un meta-prompt específico (`meta/*.md`).
> Concatenar en orden: **_base_meta → meta-prompt**. Usar `compose.sh --meta <prompt>` para automatizarlo.

---

## Idioma

Responde en el idioma en que está escrito este prompt.

## Contexto del sistema de prompts

Este repositorio contiene un sistema modular de prompts de auditoría técnica de código compuesto por tres capas:

```
_base_audit.md  →  Contrato universal (anti-alucinación, CoT, plantilla de hallazgo)
  + lang/*.md   →  Adaptador idiomático (Python, Bash, ...)
    + 0N_role/  →  Rol funcional (seguridad, rendimiento, ...)
```

Convenciones del sistema:

- Cada rol es un directorio `0N_<nombre>/` con `_index.md` (modo quick) y subtasks opcionales (`0Na_<subtask>.md`).
- Los adaptadores idiomáticos en `lang/` siguen una estructura fija: detección de contexto, convenciones, anti-patterns, rendimiento, seguridad, tooling.
- La plantilla de hallazgo se define una sola vez en `_base_audit.md` y se referencia (no se duplica) desde los roles.
- Los prompts se componen concatenando: `_base_audit.md + lang/<lenguaje>.md + 0N_role/<archivo>.md`.

## Anti-alucinación

Si no puedes demostrar un problema en el prompt con evidencia verificable, márcalo explícitamente como **hipótesis** — nunca como hallazgo confirmado. Indica qué información adicional necesitarías para confirmarlo (ej. ejecución contra código real, A/B test con LLMs).

## Principios de evaluación de prompts

1. **Especificidad > generalidad**: cada instrucción debe ser lo bastante concreta para que dos LLMs distintos produzcan resultados comparables.
2. **Completitud sin redundancia**: cubrir todas las áreas relevantes sin duplicar contenido entre capas.
3. **Calibración de severidades**: los criterios de clasificación deben producir distribuciones realistas (no todo es "crítico").
4. **Accionabilidad**: cada instrucción debe traducirse en un paso verificable del output.
5. **Robustez ante variación de input**: el prompt debe funcionar con codebases de distintos tamaños, lenguajes y dominios.
6. **Composabilidad**: cada componente debe funcionar tanto aislado como compuesto con otros.
7. **Mínimo acoplamiento entre capas**: el rol no debe depender de detalles del adaptador idiomático y viceversa.

## Plantilla de hallazgo para meta-auditoría

Usa esta plantilla para cada problema encontrado en un prompt:

- **ID**: `META-001`, `META-002`, ...
- **Componente afectado**: archivo y sección del prompt
- **Tipo de problema**: Ambigüedad | Omisión | Redundancia | Inconsistencia | Sesgo | Fragilidad | Acoplamiento
- **Severidad**: Alta | Media | Baja
- **Evidencia**: qué observaste exactamente en el prompt
- **Impacto**: cómo afecta al output del LLM (falsos positivos, omisiones, inconsistencia entre runs)
- **Propuesta de mejora**: texto concreto de reemplazo o adición
- **Validación sugerida**: cómo verificar que la mejora funciona (ej. ejecutar contra código de referencia)
