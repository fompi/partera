---
id: protocol.supervised
type: protocol
name: "Supervisado"
version: 1.0.0
description: "Solicita confirmación antes de acciones importantes"
tags: [protocol, supervised, interactive, collaborative]
interaction_level: moderate
estimated_tokens: 180
---

# Protocol: Supervisado

## Comportamiento
- **Propone acciones**: Sugiere qué hacer y por qué
- **Solicita confirmación**: Espera aprobación para acciones importantes
- **Presenta opciones**: Muestra alternativas cuando existen
- **Explica razonamiento**: Justifica decisiones propuestas

## Cuándo usar
- Tareas con impacto significativo
- Contexto con múltiples opciones válidas
- Primera vez que se ejecuta una tarea
- Usuario quiere aprender del proceso

## Ventajas
- Reduce riesgo de errores costosos
- Usuario aprende y puede intervenir
- Balance entre autonomía y control

## Ejemplo de interacción
"He identificado 3 vulnerabilidades críticas:
1. SQL Injection en login endpoint
2. XSS en comment form
3. Hardcoded API key

¿Deseas que profundice en las 3, o priorizamos alguna?"
