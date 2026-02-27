---
id: pattern.reflection
type: pattern
name: "Reflection"
version: 1.0.0
description: "Auto-crítica y refinamiento iterativo de respuestas"
tags: [pattern, reasoning, reflection, self-critique]
applicable_to: [audit, review, quality]
estimated_tokens: 195
---

# Pattern: Reflection

## Descripción
El modelo **critica su propia respuesta inicial** antes de entregar la final. Identifica fallos, omisiones o razonamientos incorrectos, y produce una versión mejorada.

## Estructura
1. **Draft**: Generar respuesta inicial
2. **Critique**: Identificar debilidades en el draft
   - ¿Hay falsos positivos o negativos?
   - ¿Se omitió algo importante?
   - ¿El razonamiento es correcto?
   - ¿Es accionable y específico?
3. **Refine**: Generar respuesta mejorada basada en la crítica

## Ejemplo
```
[Draft inicial]
El código tiene una vulnerabilidad en la función login().

[Autocrítica]
- Demasiado vago: no especifiqué qué tipo de vulnerabilidad
- Falta: no indiqué la línea exacta
- Falta: no propuse solución concreta
- ¿Falso positivo? Revisar: la variable se sanitiza en línea 45...
  No, la sanitización no cubre SQL injection.

[Respuesta refinada]
La función login() (línea 23) tiene SQL injection en la consulta
de línea 28: `query = f"SELECT * FROM users WHERE email='{email}'"`.
El atacante puede inyectar: email = "' OR '1'='1".
Fix: usar parámetros preparados: `cursor.execute("SELECT ... WHERE email=%s", (email,))`
```

## Cuándo usar
- Auditorías de seguridad donde los falsos positivos son costosos
- Reviews de código donde la precisión importa
- Análisis de calidad donde la completitud es crítica
- Cuando se quiere maximizar la confianza en la respuesta

## Instrucción para el modelo
Aplica reflexión en dos fases:

**Fase 1 — Draft**: Genera tu análisis inicial completo.

**Fase 2 — Autocrítica**: Revisa tu draft preguntándote:
- ¿Alguna conclusión es un falso positivo?
- ¿Omití vulnerabilidades, problemas o casos importantes?
- ¿Cada hallazgo incluye: descripción, ubicación, impacto y solución?
- ¿Es el nivel de severidad correcto?

**Fase 3 — Respuesta final**: Entrega la versión mejorada, corrigiendo lo identificado en la autocrítica.
