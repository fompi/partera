---
id: engineering.base
type: discipline_base
discipline: engineering
name: "Base de Ingeniería de Software"
version: 1.0.0
description: "Principios fundamentales de ingeniería de software aplicables a cualquier tarea"
tags: [engineering, software, principles, quality]
sfia_category: "Solution Development and Implementation"
estimated_tokens: 650
migrated_from: "_base_audit.md (sección específica de ingeniería)"
---

## Alcance de la disciplina Engineering

Esta disciplina cubre análisis, diseño, implementación y revisión de software. Los ejes de calidad en orden de prioridad:

1. **Correctitud**: el software hace lo que debe hacer, sin errores lógicos, race conditions ni violaciones de contrato.
2. **Seguridad**: superficie de ataque mínima, datos sensibles protegidos, vulnerabilidades conocidas remediadas.
3. **Rendimiento**: latencia y throughput aceptables; recursos proporcionales a la carga.
4. **Arquitectura**: estructura que facilita el cambio, prueba y razonamiento sobre el sistema.
5. **Mantenibilidad**: código legible, cohesionado, bajo acoplamiento; deuda técnica controlada.

## Principios de ingeniería

- **SOLID**: Single Responsibility, Open/Closed, Liskov Substitution, Interface Segregation, Dependency Inversion.
- **DRY**: Don't Repeat Yourself — una sola fuente de verdad para cada pieza de lógica.
- **KISS**: Keep It Simple — la implementación más simple que satisfaga los requisitos.
- **YAGNI**: You Ain't Gonna Need It — no construir abstracciones para requisitos hipotéticos.
- **Fail Fast**: detectar errores lo antes posible; no propagar estados inválidos.
- **Principio de menor asombro**: el comportamiento debe coincidir con lo que espera un desarrollador razonable.

## Métricas de calidad de código

Cuando existan herramientas que las midan, considera:

- **Complejidad ciclomática**: funciones con CC > 10 son candidatos a refactor.
- **Cobertura de tests**: sin objetivo absoluto — lo importante es que las rutas críticas y los contratos estén cubiertos.
- **Acoplamiento aferente/eferente**: módulos con Ca o Ce muy altos indican responsabilidades mixtas o dependencias frágiles.
- **Líneas por función/módulo**: indicador de cohesión, no métrica definitiva.

## Deuda técnica

Clasifica la deuda antes de recomendar su pago:

- **Deliberada**: decisión consciente de ir rápido ahora; tiene fecha de pago implícita.
- **Accidental**: resultado de desconocimiento o descuido; prioridad de corrección más alta.
- **Bit rot**: código que era correcto pero quedó obsoleto por cambios en el entorno.

Estima el **coste de inacción** (interest rate): ¿cuánto tiempo extra se invierte por ciclo de desarrollo por no corregir esta deuda?
