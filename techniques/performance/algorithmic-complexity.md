---
id: performance.algorithmic-complexity
type: technique
area: performance
name: "Análisis de Complejidad Algorítmica"
version: 1.0.0
description: "Análisis Big-O, estructuras de datos subóptimas y cómputo redundante"
tags: [performance, algorithms, big-o, data-structures, complexity]
input: "Código o descripción de algoritmos y estructuras de datos a analizar"
output: "Hotspots con complejidad actual, propuesta alternativa y mejora estimada"
applicable_disciplines: [engineering, ai, data]
sfia_skills: [SFEN, DTAN]
estimated_tokens: 260
migrated_from: "0002_performance/02a_algorithmic_complexity.md"
---

# Técnica: Análisis de Complejidad Algorítmica

## Foco

- Análisis Big-O en rutas críticas (worst-case y average-case cuando aplique).
- Estructuras de datos subóptimas para el caso de uso (p.ej. lista donde conviene diccionario/hash, array ordenado vs búsqueda binaria).
- Bucles costosos: iteraciones redundantes, anidamiento innecesario, trabajo repetido en cada iteración.
- Ordenaciones y búsquedas innecesarias o mal ubicadas.
- Cómputo redundante: valores que podrían precomputarse, cachearse o derivarse una sola vez.

## Metodología

1. **Identificar funciones hotspot**: en el código proporcionado o en traces/profiles, localizar las que más tiempo consumen.
2. **Trazar complejidad worst-case**: contar iteraciones anidadas, llamadas recursivas, accesos a estructuras lineales.
3. **Proponer alternativa**: algoritmo o estructura más adecuada con complejidad esperada (p.ej. O(n²) → O(n log n)).

## Resultado esperado

Para cada hotspot identificado: complejidad actual, impacto en la ruta crítica, propuesta con complejidad mejorada y estimación de mejora (factor aproximado o rango).

Usa la plantilla de hallazgo del archivo base.
