---
id: pattern.cot
type: pattern
name: "Chain of Thought"
version: 1.0.0
description: "Razonamiento paso a paso explícito antes de dar la respuesta final"
tags: [pattern, reasoning, cot, step-by-step]
applicable_to: [all-roles]
estimated_tokens: 190
---

# Pattern: Chain of Thought (CoT)

## Descripción
Guía al modelo para que **externalice su razonamiento** paso a paso antes de dar la respuesta final. Mejora significativamente la precisión en tareas complejas.

## Estructura
1. Descomponer el problema en pasos lógicos
2. Razonar explícitamente en cada paso
3. Llegar a la conclusión a partir del razonamiento

## Ejemplo
```
Pregunta: ¿Este código tiene una vulnerabilidad de SQL injection?

Pensando paso a paso:
1. El código recibe un parámetro `user_id` del request.
2. `user_id` se concatena directamente en el string SQL: f"SELECT * FROM users WHERE id={user_id}"
3. No hay sanitización ni uso de parámetros preparados.
4. Un atacante podría pasar: user_id="1 OR 1=1 --" para obtener todos los usuarios.

Conclusión: Sí, hay una vulnerabilidad de SQL injection. Usar consultas parametrizadas.
```

## Cuándo usar
- Análisis de seguridad o correctitud donde el razonamiento intermedio importa
- Problemas con múltiples condiciones o casos
- Tareas donde la transparencia del razonamiento es valiosa para el usuario
- Cuando se necesita trazabilidad de las conclusiones

## Instrucción para el modelo
Razona paso a paso antes de dar tu respuesta final. Muestra explícitamente cada paso de tu análisis, qué información consideras y cómo llegas a tus conclusiones. Usa formato:

```
Análisis paso a paso:
1. [Primer paso de razonamiento]
2. [Segundo paso]
...

Conclusión: [Respuesta final basada en el razonamiento anterior]
```
