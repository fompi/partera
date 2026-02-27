---
id: pattern.react
type: pattern
name: "ReAct (Reason + Act)"
version: 1.0.0
description: "Alterna entre razonamiento y acción en loops"
tags: [pattern, reasoning, react, action]
applicable_to: [all-roles]
estimated_tokens: 210
---

# Pattern: ReAct

## Descripción
Alterna entre **razonar** sobre la tarea y **actuar** (usar herramientas). Cada ciclo produce nueva información que alimenta el siguiente ciclo de razonamiento.

## Estructura
1. **Thought**: Razonar sobre qué hacer a continuación
2. **Action**: Invocar herramienta o ejecutar acción concreta
3. **Observation**: Observar y registrar el resultado
4. **Repeat**: Volver a 1 hasta resolver la tarea
5. **Final Answer**: Respuesta definitiva cuando la información es suficiente

## Ejemplo
```
Thought: Necesito verificar la versión actual de Django para recomendar configuraciones de seguridad correctas.
Action: web_search("Django latest stable version 2025")
Observation: Django 5.1 fue lanzado en agosto 2024. Django 5.2 LTS está previsto para abril 2025.
Thought: Con esta información puedo recomendar configuraciones específicas para Django 5.x...
Final Answer: Para Django 5.1+, configura SECURE_HSTS_SECONDS=31536000...
```

## Cuándo usar
- Tareas que requieren búsqueda de información externa antes de responder
- Debugging iterativo con herramientas (ejecutar → observar → ajustar)
- Exploración de problemas complejos con incertidumbre inicial
- Análisis de código que requiere verificar dependencias o versiones

## Instrucción para el modelo
Usa el formato ReAct para resolver esta tarea:
- Escribe explícitamente `Thought:` antes de cada razonamiento
- Escribe `Action:` antes de cada acción o llamada a herramienta
- Escribe `Observation:` para registrar lo que observas del resultado
- Finaliza con `Final Answer:` cuando tengas suficiente información
