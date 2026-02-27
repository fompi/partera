---
id: knowledge.design-basics
type: knowledge
name: "Fundamentos de Diseño"
version: 1.0.0
description: "Principios de UX/UI para no-diseñadores"
tags: [design, ux, ui, cross-discipline]
source_discipline: design
applicable_to: [engineering, content, business, management]
sfia_skills: [HCEV, USEV]
estimated_tokens: 360
---

# Knowledge Pack: Fundamentos de Diseño

## Principios de diseño visual

- **Jerarquía visual**: guiar la atención del usuario mediante tamaño, contraste y posición. Lo más importante debe destacar primero.
- **Consistencia**: usar los mismos colores, tipografías y componentes en toda la interfaz reduce la carga cognitiva.
- **Espacio negativo**: el espacio vacío no es desperdicio; da respiro y mejora la legibilidad.
- **Contraste**: relación mínima de 4.5:1 entre texto y fondo para cumplir WCAG AA (accesibilidad).

## Usabilidad y accesibilidad básica

- **Affordance**: un elemento debe parecer lo que hace (un botón debe parecer clickable).
- **Feedback inmediato**: el sistema debe responder visiblemente a cada acción del usuario (loading states, confirmaciones).
- **Error recovery**: los mensajes de error deben indicar qué salió mal y cómo corregirlo.
- **Accesibilidad (a11y)**: diseñar para usuarios con diversidad funcional; incluye alt-text, navegación por teclado, y suficiente contraste.

## User flows y journeys

- **User flow**: secuencia de pantallas/acciones que un usuario sigue para completar una tarea específica.
- **Happy path**: el flujo ideal sin errores ni desvíos.
- **Edge cases de UX**: estados vacíos, errores, timeouts, first-time user, y límites de datos.
- **Journey map**: visualización del proceso completo de un usuario, incluyendo touchpoints, emociones y puntos de fricción.

## Terminología de diseño

| Término | Significado |
|---------|-------------|
| Wireframe | Boceto estructural sin estilos visuales finales |
| Mockup | Diseño visual estático de alta fidelidad |
| Prototype | Mockup interactivo para validar flujos |
| Design system | Biblioteca de componentes y guías de estilo reutilizables |
| CTA | Call to Action; elemento que invita al usuario a realizar una acción |

## Pensamiento centrado en el usuario

- Diseñar para el **modelo mental del usuario**, no para la arquitectura técnica.
- Validar decisiones de diseño con **tests de usabilidad**, aunque sean informales.
- Priorizar **tareas frecuentes** sobre casos raros en la organización de la interfaz.
- El diseño no es solo estético: su función principal es **reducir el esfuerzo cognitivo** del usuario.
