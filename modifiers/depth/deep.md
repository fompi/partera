---
id: modifier.depth.deep
type: modifier
category: depth
name: "Análisis Profundo"
version: 1.0.0
description: "Output exhaustivo con análisis detallado"
tags: [depth, deep, comprehensive]
affects: [length, detail, thoroughness]
estimated_tokens: 180
---

# Modifier: Análisis Profundo

## Instrucciones de ajuste

Este modifier prioriza la exhaustividad y el rigor sobre la brevedad.

**Alcance**:
- Cubrir **todos los aspectos relevantes**, incluyendo los de bajo impacto si forman parte del cuadro completo.
- Explorar implicaciones secundarias y efectos en cadena, no solo los síntomas superficiales.

**Justificación y razonamiento**:
- Incluir el razonamiento completo detrás de cada hallazgo y recomendación.
- Documentar **alternativas consideradas** y por qué se descartan o priorizan.
- Señalar **trade-offs explícitamente**: cada decisión tiene costes y beneficios; documentar ambos.

**Evidencia**:
- Apoyar cada afirmación con evidencia concreta: fragmentos de código, datos, especificaciones o referencias.
- Distinguir entre certezas, hipótesis bien fundamentadas y especulaciones.

**Estructura**:
- Organizar por secciones temáticas con profundidad uniforme.
- Incluir una sección de síntesis al final que conecte los hallazgos entre sí.
- Para análisis técnicos: incluir severidad, probabilidad de ocurrencia y esfuerzo de corrección estimado.

> Este modifier es adecuado para revisiones arquitectónicas, auditorías de seguridad completas, o decisiones de alto impacto. Para síntesis rápida, usar `modifier.depth.quick`.
