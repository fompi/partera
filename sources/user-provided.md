---
id: source.user-provided
type: source
name: "Material Provisto por Usuario"
version: 1.0.0
description: "Basar respuestas únicamente en documentos/código del usuario"
tags: [source, user-provided, context-only]
restriction_level: strict
estimated_tokens: 140
---

# Source: Material Provisto por Usuario

## Restricción
Solo utilizar información de:
- Archivos adjuntos por el usuario
- Código/documentación proporcionada explícitamente
- Contexto compartido en la conversación actual

## Prohibido
- Conocimiento general del modelo
- Documentación externa
- Búsqueda web
- Asunciones sobre tecnologías no mencionadas

## Rationale
Evita alucinaciones, asegura que el análisis se basa exclusivamente en lo proporcionado.
