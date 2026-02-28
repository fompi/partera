---
id: capability.vision
type: capability
name: "Visión (Análisis de Imagen)"
version: 1.0.0
description: "Analizar contenido visual de imágenes"
tags: [vision, image, analysis, multimodal]
input: "Imagen (captura, mockup, diagrama, foto)"
output: "Descripción textual estructurada del contenido visual"
native_in: [claude, openai, gemini]
requires_wrapper_in: [ollama]
estimated_tokens: 120
---

# Capability: Visión

## Descripción
Capacidad de analizar imágenes: mockups, diagramas, capturas de pantalla, fotos, etc.

## Usos típicos
- Diseño: Analizar mockups, identificar elementos UI
- Ingeniería: Leer diagramas de arquitectura, analizar capturas de error
- Content: Describir imágenes para alt-text, analizar infografías

## Modelos que lo soportan nativamente
- Claude (Anthropic): vision nativa
- GPT-4V / GPT-4o (OpenAI): vision nativa
- Gemini Pro Vision (Google): vision nativa

## Modelos que requieren wrapper
- Ollama + LLaVA: requiere wrapper adicional
