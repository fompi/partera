---
id: design.base
type: discipline_base
discipline: design
name: "Base de Diseño"
version: 1.0.0
description: "Principios de diseño UX/UI, accesibilidad y usabilidad"
tags: [design, ux, ui, usability, accessibility]
sfia_category: "Solution Development and Implementation"
estimated_tokens: 620
---

## Alcance de la disciplina Design

Esta disciplina cubre el diseño de experiencias e interfaces centradas en el usuario, desde la investigación inicial hasta la validación del diseño final. Los ejes de calidad en orden de prioridad:

1. **Usabilidad**: el usuario puede completar sus tareas sin fricción, confusión ni errores.
2. **Accesibilidad**: el diseño funciona para usuarios con diversas capacidades (WCAG 2.1 AA como mínimo).
3. **Consistencia**: el sistema visual y de interacción es predecible y coherente.
4. **Estética funcional**: el diseño es visualmente atractivo, pero la estética no sacrifica la función.
5. **Escalabilidad**: los patrones de diseño pueden crecer sin perder coherencia.

## Principios fundamentales de diseño

- **Jerarquía visual**: lo más importante visualmente es lo más importante funcionalmente.
- **Contraste**: diferenciación clara entre elementos interactivos, informativos y decorativos.
- **Proximidad**: elementos relacionados agrupados; separación clara entre grupos distintos.
- **Alineación**: estructura visual que el ojo puede seguir sin esfuerzo consciente.
- **Repetición**: patrones consistentes reducen la carga cognitiva.
- **Espacio en blanco**: el espacio que rodea los elementos es tan diseño como los elementos mismos.

## Metodología user-centered design (UCD)

El diseño centrado en el usuario itera entre:

1. **Research**: entender al usuario real, no al usuario imaginado (entrevistas, encuestas, análisis de uso).
2. **Define**: sintetizar hallazgos en personas, jobs to be done, journey maps.
3. **Ideate**: generar múltiples soluciones antes de comprometerse con una.
4. **Prototype**: crear representaciones de baja y alta fidelidad para validar hipótesis.
5. **Test**: validar con usuarios reales antes de construir.
6. **Iterar**: el diseño no termina; mejora con cada ciclo de feedback.

## Accesibilidad (WCAG 2.1 AA)

Cuatro principios (POUR):

- **Perceptible**: toda la información es visible y audible para todos los usuarios.
  - Contraste mínimo: 4.5:1 para texto normal, 3:1 para texto grande.
  - Alt text para imágenes informativas.
  - Captions para contenido multimedia.
- **Operable**: la interfaz puede usarse con teclado, no solo con ratón.
  - Focus visible en todos los elementos interactivos.
  - Sin trampas de teclado.
- **Comprensible**: el lenguaje es claro y el comportamiento es predecible.
- **Robusto**: compatible con tecnologías asistivas actuales y futuras.

## Design systems

Un design system saludable incluye:

- **Tokens de diseño**: colores, tipografía, espaciado, radios como variables.
- **Componentes**: biblioteca de piezas reutilizables con variantes documentadas.
- **Patrones**: soluciones a problemas de interacción recurrentes (formularios, navegación, feedback).
- **Principios editoriales**: tono y voz de la interfaz.
- **Documentación**: guía de uso de componentes con ejemplos y anti-patterns.

## Métricas de diseño

- **Task completion rate**: porcentaje de usuarios que completan la tarea objetivo.
- **Time on task**: tiempo necesario para completar tareas clave.
- **Error rate**: frecuencia de errores en flujos críticos.
- **SUS (System Usability Scale)**: puntuación estándar de usabilidad percibida.
- **Accessibility audit score**: número y severidad de violaciones WCAG.
