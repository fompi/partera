---
id: pattern.plan-and-solve
type: pattern
name: "Plan-and-Solve"
version: 1.0.0
description: "Planifica explícitamente antes de actuar, luego ejecuta el plan"
tags: [pattern, planning, execution, structured]
applicable_to: [generate, plan, architecture]
estimated_tokens: 205
---

# Pattern: Plan-and-Solve

## Descripción
Separa explícitamente la **fase de planificación** de la **fase de ejecución**. Primero crea un plan detallado, luego lo ejecuta paso a paso. Reduce errores en tareas complejas al forzar pensamiento anticipatorio.

## Estructura
1. **Understand**: Analizar el problema y sus requisitos
2. **Plan**: Crear un plan de pasos concretos y ordenados
3. **Validate**: Revisar el plan antes de ejecutar (¿es completo? ¿correcto?)
4. **Execute**: Seguir el plan paso a paso
5. **Verify**: Confirmar que cada paso produce el resultado esperado

## Ejemplo
```
Tarea: Refactorizar la función procesar_pedido() para que sea testeable

[Understand]
- La función actual tiene 150 líneas, mezcla lógica de negocio, BD y email
- No es testeable por las dependencias hardcodeadas
- Objetivo: separar responsabilidades y permitir inyección de dependencias

[Plan]
1. Extraer función calcular_total(items) → lógica pura, testeable
2. Extraer función validar_stock(repo, items) → recibe repositorio como param
3. Extraer función enviar_confirmacion(mailer, pedido) → inyecta mailer
4. Refactorizar procesar_pedido() para orquestar las anteriores
5. Añadir tipos/interfaces para repo y mailer
6. Escribir tests unitarios para cada función extraída

[Validate]
- ¿El plan cubre todos los casos? Sí
- ¿Hay dependencias entre pasos? Sí: 1-3 antes de 4, 5 antes de 6
- ¿Riesgo de regresión? Bajo si se ejecutan tests de integración existentes

[Execute]
Paso 1: def calcular_total(items: list[Item]) -> Decimal: ...
...
```

## Cuándo usar
- Generación de código complejo con múltiples componentes
- Refactorizaciones no triviales
- Arquitectura de nuevas features
- Cualquier tarea donde un error en pasos iniciales bloquea los siguientes

## Instrucción para el modelo
Aplica Plan-and-Solve para esta tarea:

1. **Entender**: Resume el problema y los requisitos clave (2-3 líneas)
2. **Plan**: Lista los pasos concretos y ordenados que vas a seguir
3. **Validar el plan**: Confirma que el plan es completo y no tiene dependencias circulares
4. **Ejecutar**: Sigue el plan paso a paso, indicando en qué paso estás
5. **Verificar**: Al final, confirma que cada paso se completó correctamente
