---
id: maintainability.tech-debt
type: technique
area: maintainability
name: "Análisis de Deuda Técnica"
version: 1.0.0
description: "Identificación y priorización de deuda técnica acumulada"
tags: [maintainability, tech-debt, refactoring, prioritization]
input: "Codebase, backlog o descripción del sistema a analizar"
output: "Inventario de deuda técnica priorizado por impacto y coste de resolución"
applicable_disciplines: [engineering]
sfia_skills: [SWDN, DESN, REQM]
estimated_tokens: 300
---

# Técnica: Análisis de Deuda Técnica

## Foco

- Deuda deliberada: atajos tomados conscientemente con intención de revisitar (¿están documentados?).
- Deuda inadvertida: diseño pobre descubierto a posteriori, código legacy sin dueño claro.
- Deuda de dependencias: librerías desactualizadas, versiones EOL, dependencias con vulnerabilidades.
- Deuda de test: cobertura insuficiente en módulos críticos, tests frágiles o sin mantener.
- Deuda de configuración: secretos hardcodeados, entornos con configuración manual no reproducible.
- Indicadores: TODOs/FIXMEs en el código, PRs de "quick fix" acumulados, frecuencia de bugs en el mismo módulo.

## Metodología

1. **Inventariar indicadores de deuda**: contar TODOs/FIXMEs, revisar antigüedad de dependencias, identificar módulos con alta frecuencia de bugs.
2. **Clasificar por tipo**: deliberada/inadvertida, arquitectónica/táctica/de dependencias/de tests.
3. **Estimar el coste de inacción**: ¿ralentiza el desarrollo? ¿Introduce riesgo de seguridad? ¿Dificulta el onboarding?
4. **Estimar el coste de resolución**: días de trabajo aproximados, riesgo de regresión, dependencias entre items de deuda.
5. **Priorizar**: matriz impacto vs esfuerzo; quick wins primero, deuda crítica en el roadmap.

## Resultado esperado

Inventario de deuda técnica con: tipo, descripción, módulo afectado, coste de inacción (alto/medio/bajo), esfuerzo estimado de resolución, y orden de prioridad recomendado.

Usa la plantilla de hallazgo del archivo base.
