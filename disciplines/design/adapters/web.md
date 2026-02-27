---
id: design.adapter.web
type: adapter
discipline: design
name: "Web"
version: 1.0.0
description: "Adaptador para diseño de interfaces web"
tags: [web, responsive, desktop, mobile-web]
estimated_tokens: 310
---

# Adaptador: Web

## Contexto de uso

Diseño de interfaces web: aplicaciones SaaS, sitios corporativos, portales, dashboards, e-commerce. Incluye diseño responsive para múltiples tamaños de pantalla.

## Convenciones del entorno web

- **Responsive design**: mobile-first como estrategia de diseño; los breakpoints son puntos de adaptación, no targets fijos.
- **Grid system**: 12 columnas para desktop, 8 para tablet, 4 para mobile como referencia.
- **Tipografía web**: tamaño base 16px; escala tipográfica modular. Line-height 1.5 para cuerpo de texto.
- **Touch targets**: mínimo 44x44px para elementos interactivos (aunque en desktop se ve con cursor).
- **Estados de interacción**: todos los elementos interactivos tienen hover, focus, active y disabled definidos.
- **Loading states**: toda operación async > 300ms requiere indicador de carga.

## Patrones de navegación web

- **Global navigation**: consistente en todas las páginas; posición predecible (header o sidebar).
- **Breadcrumbs**: para jerarquías de más de 2 niveles.
- **Skip navigation**: enlace "saltar al contenido" para usuarios de teclado (accesibilidad).
- **404 y error pages**: con orientación de recuperación, no solo mensaje de error.

## Anti-patrones web

- Carousels automáticos (bajo engagement, problemas de accesibilidad).
- Modales que bloquean el contenido principal sin justificación.
- Formularios con solo un campo por página cuando no hay razón para ello.
- Color como único diferenciador de estados (problema para daltónicos).
- Texto sobre imágenes sin overlay de contraste suficiente.
- Infinite scroll sin punto de referencia para volver a posición anterior.

## Herramientas y entregables

- **Wireframes**: Figma, Sketch, Adobe XD o incluso papel.
- **Prototipos interactivos**: Figma prototype, Framer, Webflow.
- **Design tokens**: exportables a CSS custom properties o JSON.
- **Handoff**: anotaciones de comportamiento, medidas en px/rem, estados.

## Consideraciones de rendimiento visual

- Las decisiones de diseño tienen impacto en performance web: número de fuentes, peso de imágenes, animaciones CSS vs JS.
- Indicar peso máximo de imágenes y formatos recomendados (WebP, AVIF).
- Animaciones: preferir CSS transitions, respetar `prefers-reduced-motion`.
