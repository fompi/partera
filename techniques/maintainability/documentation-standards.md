---
id: maintainability.documentation-standards
type: technique
area: maintainability
name: "Análisis de Estándares de Documentación"
version: 1.0.0
description: "Evaluación de documentación técnica, comentarios inline y READMEs"
tags: [maintainability, documentation, readme, comments, api-docs]
input: "Codebase o repositorio con documentación a evaluar"
output: "Gaps de documentación identificados con prioridad de resolución"
applicable_disciplines: [engineering, data, ai]
sfia_skills: [IRMG, DOCM, SWDN]
estimated_tokens: 280
---

# Técnica: Análisis de Estándares de Documentación

## Foco

- README: ¿existe, está actualizado, cubre setup, uso y contribución?
- Documentación de API pública: ¿cada endpoint/función pública tiene descripción, parámetros y ejemplos?
- Comentarios inline: ¿explican el *por qué* (no el *qué*)? ¿Están desactualizados respecto al código?
- Documentación de arquitectura: ADRs, diagramas, decisiones de diseño documentadas.
- Changelog y guías de migración para cambios breaking.
- Coherencia entre documentación y comportamiento real del sistema.

## Metodología

1. **Inventariar tipos de documentación existente**: README, wikis, docstrings, comentarios, diagramas, ADRs.
2. **Evaluar completitud del README**: ¿puede un desarrollador nuevo hacer setup y ejecutar el proyecto sin preguntar?
3. **Revisar la documentación de API**: ¿está generada automáticamente o es manual? ¿Coincide con la implementación actual?
4. **Auditar comentarios inline**: buscar comentarios que explican código obvio (ruido) vs comentarios que faltan en lógica compleja.
5. **Detectar documentación obsoleta**: comentarios con TODOs sin resolver, referencias a rutas o APIs que ya no existen.

## Resultado esperado

Para cada gap identificado: tipo de documentación afectada, impacto en onboarding y mantenimiento, y propuesta concreta (qué documentar, dónde, en qué formato).

Usa la plantilla de hallazgo del archivo base.
