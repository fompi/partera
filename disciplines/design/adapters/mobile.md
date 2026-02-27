---
id: design.adapter.mobile
type: adapter
discipline: design
name: "Mobile"
version: 1.0.0
description: "Adaptador para diseño de apps móviles nativas"
tags: [mobile, ios, android, native]
estimated_tokens: 320
---

# Adaptador: Mobile

## Contexto de uso

Diseño de aplicaciones móviles nativas para iOS y Android. Las plataformas tienen sus propios HIG (Human Interface Guidelines) y Material Design que los usuarios esperan que se respeten.

## Convenciones de plataforma

### iOS (Apple HIG)
- Navigation: Tab Bar (≤5 items), Navigation Stack, Modal.
- Touch targets: mínimo 44pt.
- Safe areas: respetar notch, Dynamic Island, home indicator.
- Typography: Dynamic Type (escalado por accesibilidad del sistema).
- Gestures: swipe back para navegación es expectativa del usuario iOS.

### Android (Material Design 3)
- Navigation: Navigation Bar, Navigation Drawer, Top App Bar.
- Touch targets: mínimo 48dp.
- Elevation y shadows como lenguaje visual.
- Adaptive layouts: soporte para diferentes form factors (foldables, tablets).
- Back gesture: debe ser consistente con el comportamiento del sistema.

## Principios de diseño mobile

- **Thumb-friendly zones**: elementos de acción principal en la zona alcanzable con el pulgar (bottom 2/3 de pantalla).
- **One primary action per screen**: evitar pantallas con múltiples CTAs de igual peso.
- **Context-aware defaults**: aprovechar GPS, cámara, contactos cuando es relevante y el usuario lo autorizó.
- **Offline-first consideration**: el diseño contempla estados de conectividad degradada.
- **Battery-aware**: animaciones y operaciones de background tienen impacto en batería.

## Anti-patrones mobile

- Portar directamente el diseño web sin adaptar al contexto móvil.
- Menús hamburguesa que ocultan navegación principal (Tab Bar es más descubrible).
- Texto demasiado pequeño (mínimo 16sp/pt para cuerpo).
- Inputs de texto que no invocan el tipo de teclado correcto (email, número, etc.).
- Notificaciones push sin valor claro para el usuario.
- Splash screens excesivamente largos.

## Entregables para mobile

- Diseños en resoluciones @1x, @2x, @3x (iOS) o mdpi, hdpi, xhdpi, xxhdpi (Android).
- Especificación de gestures no estándar.
- Flujos de onboarding y permisos (ubicación, notificaciones, cámara).
- Dark mode: el diseño funciona en ambos modos de color del sistema.
- Estados de error y empty states para cada pantalla principal.
