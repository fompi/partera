---
id: capability.diagram-generation
type: capability
name: "Generación de Diagramas"
version: 1.0.0
description: "Generar diagramas visuales (Mermaid, PlantUML, etc)"
tags: [diagrams, visualization, architecture, flowchart]
input: "Descripción del diagrama o sistema"
output: "Código de diagrama renderizable"
native_in: []
requires_wrapper_in: [claude, openai, gemini, ollama]
estimated_tokens: 145
---

# Capability: Generación de Diagramas

## Descripción
Capacidad de generar diagramas visuales en formato textual (Mermaid, PlantUML, etc).

## Tipos de diagramas
- Arquitectura de sistemas
- Flowcharts / diagramas de flujo
- Diagramas de secuencia
- Entity-relationship diagrams
- State machines

## Formatos soportados
- Mermaid (más común, amplio soporte)
- PlantUML
- Graphviz DOT

## Implementaciones
- Todos los modelos: Generan código de diagrama como texto
- Renderizado: Requiere herramienta externa (Mermaid CLI, PlantUML server, etc)
