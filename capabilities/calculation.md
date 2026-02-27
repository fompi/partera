---
id: capability.calculation
type: capability
name: "Cálculos Complejos"
version: 1.0.0
description: "Ejecutar cálculos matemáticos precisos"
tags: [calculation, math, precision, computation]
input: "Expresión matemática o problema"
output: "Resultado preciso con pasos"
native_in: []
requires_wrapper_in: [claude, openai, gemini, ollama]
estimated_tokens: 135
---

# Capability: Cálculos Complejos

## Descripción
Capacidad de ejecutar cálculos matemáticos con precisión (más allá de la capacidad del LLM).

## Usos típicos
- Análisis financiero (ROI, NPV)
- Cálculos de performance (throughput, latency)
- Estimaciones estadísticas
- Conversiones de unidades complejas

## Implementaciones
- Todos los modelos requieren wrapper externo:
  - Python + SymPy/NumPy
  - Wolfram Alpha API
  - Calculator API
