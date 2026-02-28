---
id: pattern.toolformer
type: pattern
name: "Toolformer"
version: 1.0.0
description: "Decide cuándo usar herramientas vs conocimiento interno"
tags: [pattern, tool-use, toolformer, hybrid]
applicable_to: [all-roles]
estimated_tokens: 200
---

# Pattern: Toolformer

## Descripción
Enseña al modelo a **decidir autónomamente** cuándo su conocimiento interno es suficiente y cuándo necesita usar una herramienta externa. Evita tanto el exceso de llamadas a herramientas como la confianza excesiva en conocimiento potencialmente desactualizado.

## Heurísticas de decisión

### Usar conocimiento interno cuando:
- El dato es estable y no cambia con el tiempo (principios de diseño, algoritmos)
- El modelo tiene alta confianza y no es información crítica de versión
- La herramienta añade latencia sin beneficio claro

### Usar herramienta cuando:
- La información podría estar desactualizada (versiones, CVEs, APIs)
- Se necesita verificar un dato específico de alta precisión
- La tarea requiere ejecutar código real para confirmar comportamiento
- Necesita información del contexto local (leer archivo, buscar en repo)

## Formato de decisión
```
[Evaluando si necesito herramienta]
- Dato requerido: versión actual de urllib3
- ¿Lo sé con certeza? No (puede haber cambiado)
- ¿Es crítico para la respuesta? Sí (afecta CVE-2023-32681)
→ Usar herramienta: web_search("urllib3 latest version CVE 2024")

[Evaluando si necesito herramienta]
- Dato requerido: complejidad temporal de quicksort
- ¿Lo sé con certeza? Sí (O(n log n) promedio, O(n²) peor caso)
- ¿Es crítico? Sí, pero es conocimiento estable
→ Usar conocimiento interno
```

## Cuándo usar
- Roles con acceso a herramientas (web-search, code-execution)
- Auditorías donde la versión exacta de dependencias importa
- Análisis que mezclan conocimiento general con datos específicos del proyecto

## Instrucción para el modelo
Antes de cada afirmación factual, decide explícitamente:
- Si puedes responder con confianza desde tu conocimiento → hazlo
- Si el dato podría estar desactualizado o necesitas confirmación → usa la herramienta apropiada
- Documenta brevemente tu decisión: `[Conocimiento interno]` o `[→ herramienta: X]`
