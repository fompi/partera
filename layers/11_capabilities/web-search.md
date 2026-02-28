---
id: capability.web-search
type: capability
name: "Búsqueda Web"
version: 1.0.0
description: "Buscar información actualizada en la web"
tags: [web-search, internet, real-time, research]
input: "Query de búsqueda"
output: "Resultados relevantes con fuentes"
native_in: [claude-with-extension]
requires_wrapper_in: [openai, gemini, ollama]
estimated_tokens: 130
---

# Capability: Búsqueda Web

## Descripción
Capacidad de buscar información en internet en tiempo real.

## Usos típicos
- Investigar tecnologías recientes
- Verificar documentación actualizada
- Buscar ejemplos y best practices
- Validar información

## Implementaciones
- Claude: Extensión nativa (cuando habilitada)
- OpenAI: Via function calling + API externa (Tavily, SerpAPI)
- Gemini: Via function calling + API externa
- Ollama: Requiere tool wrapper
