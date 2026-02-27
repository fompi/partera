---
id: pattern.tot
type: pattern
name: "Tree of Thoughts"
version: 1.0.0
description: "Exploración de múltiples ramas de razonamiento en paralelo"
tags: [pattern, reasoning, tot, exploration]
applicable_to: [planning, architecture, design]
estimated_tokens: 220
---

# Pattern: Tree of Thoughts (ToT)

## Descripción
Explora **múltiples caminos de razonamiento en paralelo** antes de seleccionar el mejor. Útil cuando hay varias soluciones posibles y se necesita evaluar trade-offs.

## Estructura
1. **Generar ramas**: Proponer 2-4 enfoques diferentes
2. **Explorar**: Desarrollar cada rama lo suficiente para evaluarla
3. **Evaluar**: Puntuar cada rama según criterios relevantes
4. **Seleccionar**: Elegir la rama más prometedora (o combinar)
5. **Profundizar**: Desarrollar la solución seleccionada

## Ejemplo
```
Tarea: Diseñar la arquitectura de autenticación para una API

Rama 1 — JWT stateless:
  + Sin estado en servidor, escala horizontalmente
  + Simple de implementar
  - Difícil de revocar tokens
  Evaluación: 7/10 para la mayoría de casos

Rama 2 — Sessions en Redis:
  + Revocación inmediata
  + Control total sobre sesiones
  - Requiere Redis, añade latencia
  Evaluación: 8/10 si se necesita logout instantáneo

Rama 3 — OAuth2 + PKCE:
  + Estándar de industria
  + Delega auth a proveedor
  - Complejidad mayor
  Evaluación: 9/10 si hay SSO o múltiples clientes

Selección: Rama 3 (OAuth2) dado que el sistema tiene múltiples clientes...
```

## Cuándo usar
- Decisiones de arquitectura con múltiples opciones válidas
- Planificación de features complejas
- Diseño de sistemas donde los trade-offs no son obvios
- Cuando el usuario necesita comparar alternativas

## Instrucción para el modelo
Usa Tree of Thoughts para explorar esta decisión:
1. Genera 3 enfoques alternativos
2. Para cada uno, explora ventajas, desventajas y casos de uso
3. Evalúa cada enfoque con una puntuación y justificación
4. Selecciona y desarrolla el mejor enfoque (o una combinación)
