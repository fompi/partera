---
id: maintainability.code-organization
type: technique
area: maintainability
name: "Análisis de Organización de Código"
version: 1.0.0
description: "Evaluación de estructura modular, cohesión y acoplamiento"
tags: [maintainability, modularity, cohesion, coupling]
input: "Codebase o arquitectura a analizar"
output: "Recomendaciones de refactorización estructural"
applicable_disciplines: [engineering]
sfia_skills: [DESN, SWDN]
estimated_tokens: 310
---

# Técnica: Análisis de Organización de Código

## Foco

- Cohesión de módulos: ¿cada módulo tiene una responsabilidad única y bien delimitada?
- Acoplamiento entre módulos: dependencias bidireccionales, ciclos de importación, interfaces frágiles.
- Tamaño y complejidad de ficheros: clases dios, módulos con múltiples responsabilidades.
- Consistencia en la estructura de directorios: ¿sigue una convención predecible?
- Separación de capas (UI, lógica de negocio, acceso a datos): ¿las responsabilidades están mezcladas?
- Ubicación de utilidades y helpers: ¿están dispersos o centralizados? ¿Son accesibles sin introducir acoplamiento excesivo?

## Metodología

1. **Mapear la estructura de directorios**: identificar módulos, capas y sus responsabilidades declaradas.
2. **Medir cohesión por módulo**: ¿las funciones/clases de un módulo colaboran hacia un único objetivo?
3. **Detectar acoplamiento excesivo**: dependencias entre módulos que deberían ser independientes, importaciones circulares.
4. **Identificar módulos que violan SRP**: ficheros grandes (>500 líneas es un indicador), clases con múltiples roles.
5. **Proponer reorganización**: extracción de módulos, consolidación de utilidades, inversión de dependencias.

## Resultado esperado

Para cada área problemática: descripción del problema de cohesión o acoplamiento, impacto en mantenibilidad (dificultad de cambio, testing, riesgo de regresión), propuesta de refactorización y orden sugerido de ejecución.

Usa la plantilla de hallazgo del archivo base.
