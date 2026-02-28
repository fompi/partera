---
id: correctness.edge-cases-contracts
type: technique
area: correctness
name: "Análisis de Edge Cases y Contratos"
version: 1.0.0
description: "Verificación de contratos entre módulos y manejo de inputs límite"
tags: [correctness, edge-cases, contracts, preconditions, invariants]
input: "Interfaces, APIs o módulos a analizar"
output: "Contratos violados y edge cases no manejados con ubicación específica"
applicable_disciplines: [engineering, ai, data]
sfia_skills: [TEST, SWDN]
estimated_tokens: 250
migrated_from: "0004_correctness/04a_edge_cases_contracts.md"
---

# Técnica: Análisis de Edge Cases y Contratos

## Foco

- **Contratos entre módulos**: entradas/salidas esperadas (precondiciones, postcondiciones), garantías implícitas
- **Edge cases**: null, vacío, overflow, unicode problemático, zonas horarias, valores en frontera
- **Desajustes de tipos**: asunciones implícitas sobre tipos que no se validan
- **Suposiciones implícitas**: "esto nunca será null", "el usuario siempre envía X"

## Metodología

1. **Por cada función/API pública**: enumera las precondiciones (qué debe ser cierto antes de llamar) y verifica si los callers las respetan.
2. **Inputs adversarios**: para cada interfaz externa o interna crítica, genera mentalmente entradas que prueben los límites y verifica si el sistema las maneja.
3. **Validación en fronteras**: comprueba si las validaciones están donde corresponde (entrada del sistema, límites de módulo).

## Resultado esperado

Para cada contrato o edge case identificado: indica qué precondición se viola o qué valor límite no se maneja correctamente, y en qué archivo/función ocurre.

Usa la plantilla de hallazgo del archivo base.
