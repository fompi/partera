---
id: capability.code-execution
type: capability
name: "Ejecución de Código"
version: 1.0.0
description: "Ejecutar código en sandbox para verificar comportamiento"
tags: [code-execution, sandbox, testing, validation]
input: "Código a ejecutar + lenguaje"
output: "Resultado de ejecución (stdout, stderr, exitcode)"
native_in: [claude-code-execution]
requires_wrapper_in: [openai, gemini, ollama]
estimated_tokens: 140
---

# Capability: Ejecución de Código

## Descripción
Capacidad de ejecutar código en un entorno aislado para verificar comportamiento.

## Usos típicos
- Validar que el código generado funciona
- Probar soluciones a bugs
- Ejecutar tests
- Debugging interactivo

## Implementaciones
- Claude: Code execution nativa (cuando habilitada)
- OpenAI: Code Interpreter (Python only)
- Gemini: Code execution limitada
- Ollama: Requiere sandbox externo (Docker, etc)
