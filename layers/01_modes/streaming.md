---
id: base.streaming
type: base
name: "Base streaming (emisión por trozos)"
version: 1.0.0
description: "Mismo formato por hallazgo; emite cada uno en cuanto está listo; no bloque único final"
tags: [base, streaming, incremental, yield]
input: "N/A"
output: "Hallazgos o chunks emitidos uno a uno conforme se completan"
estimated_tokens: 600
---

## Contrato de salida

No esperes a tener todos los resultados para responder. **Emite cada hallazgo o chunk en cuanto esté listo**, en el mismo formato que la base universal (plantilla de hallazgo), pero uno por uno. El modelo puede seguir trabajando tras emitir cada uno.

## Idioma

Responde en el idioma en que está escrito este prompt.

## Anti-alucinación

Si no puedes demostrar un hallazgo con evidencia verificable, márcalo como **hipótesis**. Indica qué información adicional necesitarías para confirmarlo.

## Razonamiento por hallazgo

Antes de emitir cada hallazgo, sigue internamente: evidencia → hipótesis → verificación → conclusión. No es necesario mostrar el CoT al usuario; emite directamente el hallazgo cuando esté listo.

## Plantilla de hallazgo (por unidad emitida)

Cada unidad que emitas usa esta plantilla. Emite una unidad completa cada vez (no cortes a mitad de hallazgo).

- **ID**, **Tipología**, **Criticidad**, **Beneficio de corregir**, **Impacto de no actuar**, **Esfuerzo**, **Confianza**, **Ubicación**, **Evidencia técnica**, **Propuesta de mejora**, **Riesgo de regresión**, **Plan anti-regresión**, **Métricas de éxito**, **Clasificación**, **Prioridad**

Si un campo no aplica, indica "N/A".

## Reglas de emisión

- Emite cada hallazgo en cuanto lo tengas validado; no acumules para un único bloque final.
- Mantén coherencia: los hallazgos ya emitidos no deben contradecirse con los siguientes.
- Si el usuario o el sistema puede cancelar la ejecución, está permitido parar tras emitir los hallazgos ya generados sin esperar al "fin" del análisis.
