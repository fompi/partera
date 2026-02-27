---
id: performance.memory-resources
type: technique
area: performance
name: "Análisis de Memoria y Recursos"
version: 1.0.0
description: "Detección de fugas de memoria, asignaciones excesivas y recursos no liberados"
tags: [performance, memory, resources, leaks, cache, lifecycle]
input: "Código con gestión de memoria, cachés o ciclo de vida de recursos"
output: "Patrones de retención con impacto estimado en RAM y propuestas de corrección"
applicable_disciplines: [engineering, ai, data]
sfia_skills: [SFEN, PRMG]
estimated_tokens: 240
migrated_from: "02_performance/02c_memory_resources.md"
---

# Técnica: Análisis de Memoria y Recursos

## Foco

- Fugas de memoria: referencias que impiden liberación (listas globales, closures, caches sin eviction).
- Asignaciones excesivas: buffers sobredimensionados, objetos temporales en bucles.
- Falta de limpieza: recursos no liberados (handles, conexiones, ficheros abiertos).
- Estrategia de caché: TTL, política de eviction (LRU, LFU), límite de tamaño.
- Ciclo de vida de objetos: retención innecesariamente larga, objetos que deberían ser de corta vida.

## Metodología

1. **Identificar objetos de ciclo largo**: qué referencias los mantienen vivos más de lo necesario.
2. **Revisar patrones de limpieza**: `close`, `finally`, context managers, destructores.
3. **Evaluar caché**: si existe, ¿TTL adecuado? ¿eviction cuando alcanza límite? ¿memoria acotada?

## Resultado esperado

Para cada hallazgo: patrón de retención, impacto estimado en RAM, propuesta de pooling/liberación/caché con criterios de éxito.

Usa la plantilla de hallazgo del archivo base.
