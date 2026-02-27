---
id: correctness.error-handling
type: technique
area: correctness
name: "Análisis de Gestión de Errores"
version: 1.0.0
description: "Detección de excepciones tragadas, fallos silenciosos y propagación incompleta"
tags: [correctness, error-handling, exceptions, fault-tolerance, observability]
input: "Código con llamadas externas, I/O o manejo de errores a analizar"
output: "Rutas de error con gaps de visibilidad y propuestas de corrección"
applicable_disciplines: [engineering, ai, data]
sfia_skills: [TEST, SWDN, RLMT]
estimated_tokens: 240
migrated_from: "04_correctness/04c_error_handling.md"
---

# Técnica: Análisis de Gestión de Errores

## Foco

- Excepciones tragadas (swallowed exceptions) o ignoradas silenciosamente
- Fallos silenciosos (operación falla sin señalarlo)
- Lagunas en la propagación de errores (el error se pierde en el camino)
- Ausencia de recuperación tras errores
- Formatos de error inconsistentes (dificultan diagnóstico)
- Violaciones de invariantes después de un error (estado corrupto)

## Metodología

1. **Por cada llamada externa** (I/O, red, BD, filesystem, APIs): traza qué ocurre cuando falla. ¿Quién la captura? ¿Se propaga? ¿Se registra?
2. **Estado consistente**: verifica que tras cualquier error, el sistema llega a un estado consistente (rollback, compensación, limpieza de recursos).
3. **Puntos ciegos**: identifica flujos donde un fallo intermedio deja el sistema en estado indefinido o sin visibilidad para el operador.

## Resultado esperado

Para cada problema: indica la ruta de propagación del error, qué se pierde o ignora, y qué debería hacerse para garantizar visibilidad y consistencia.

Usa la plantilla de hallazgo del archivo base.
