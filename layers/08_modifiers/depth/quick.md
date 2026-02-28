---
id: modifier.depth.quick
type: modifier
category: depth
name: "Análisis Rápido"
version: 1.0.0
description: "Output conciso y accionable, prioriza velocidad"
tags: [depth, quick, concise]
affects: [length, detail, speed]
estimated_tokens: 170
---

# Modifier: Análisis Rápido

## Instrucciones de ajuste

Este modifier prioriza la velocidad y accionabilidad sobre la exhaustividad.

**Alcance**:
- Limitar a los **3–5 hallazgos o puntos más importantes**; descartar lo de bajo impacto.
- No cubrir todos los ángulos posibles; enfocarse en lo que tiene mayor consecuencia inmediata.

**Formato**:
- Conclusiones y recomendaciones al inicio, sin preámbulo.
- Bullets cortos; evitar párrafos explicativos extensos.
- Omitir justificaciones detalladas: una frase de contexto es suficiente.

**Acción inmediata**:
- Identificar **una acción prioritaria** que el receptor puede tomar de inmediato.
- Si hay varios issues, ordenarlos por urgencia y señalar claramente cuál abordar primero.

**Lo que se omite conscientemente**:
- Análisis de alternativas.
- Trade-offs completos.
- Contexto histórico o comparaciones externas.
- Justificaciones teóricas.

> Este modifier es adecuado para triage inicial, reuniones de estado, o cuando el tiempo disponible es limitado. Para análisis completo, usar `modifier.depth.deep`.
