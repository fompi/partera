---
id: correctness.concurrency-state
type: technique
area: correctness
name: "Análisis de Concurrencia y Estado Compartido"
version: 1.0.0
description: "Identificación de race conditions, deadlocks y violaciones de atomicidad"
tags: [correctness, concurrency, race-conditions, deadlocks, atomicity, toctou]
input: "Código con concurrencia: threads, async, multiprocess, señales o workers"
output: "Recursos compartidos con riesgos de carrera o inconsistencia identificados"
applicable_disciplines: [engineering, ai, data]
sfia_skills: [TEST, SWDN, SFEN]
estimated_tokens: 240
migrated_from: "0004_correctness/04b_concurrency_state.md"
---

# Técnica: Análisis de Concurrencia y Estado Compartido

## Foco

- Condiciones de carrera (race conditions)
- Deadlocks
- Estado inconsistente por acceso concurrente
- Violaciones de atomicidad
- Fallo parcial en operaciones distribuidas (completar una parte pero no otra)

## Nota importante

**Omitir si no hay concurrencia**: threads, async, multiprocess, señales, workers paralelos. Si no hay concurrencia, no hay nada que auditar aquí.

## Metodología

1. **Estado mutable compartido**: identificar todas las variables o recursos (ficheros, BD, memoria) compartidos entre flujos de ejecución.
2. **Sincronización**: verificar que cada acceso a estado compartido está correctamente protegido (locks, atomics, canales).
3. **TOCTOU**: buscar patrones Time-of-check to time-of-use y ventanas donde el estado puede cambiar entre comprobación y uso.

## Resultado esperado

Para cada problema de concurrencia: identifica el recurso compartido, los flujos que lo acceden y qué condición de carrera o inconsistencia puede ocurrir.

Usa la plantilla de hallazgo del archivo base.
