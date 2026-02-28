---
id: resilience.graceful-degradation
type: technique
area: resilience
name: "Análisis de Degradación Controlada"
version: 1.0.0
description: "Análisis de fallbacks y degradación controlada ante fallos parciales"
tags: [resilience, graceful-degradation, fallback, circuit-breaker, bulkhead]
input: "Sistema o servicio con dependencias externas o internas"
output: "Mapa de degradación con fallbacks definidos y gaps identificados"
applicable_disciplines: [engineering, data, ai]
sfia_skills: [ARCH, DESN, RLMT]
estimated_tokens: 295
---

# Técnica: Análisis de Degradación Controlada

## Foco

- Circuit breakers: ¿están implementados en llamadas a servicios externos? ¿Tienen umbrales y half-open state correctos?
- Bulkheads: ¿están los recursos (thread pools, conexiones) segregados para evitar que un fallo afecte a todo?
- Fallbacks definidos: ante la caída de un servicio dependiente, ¿qué hace el sistema? ¿Silenció el error o lo comunica al usuario?
- Feature flags para deshabilitar funcionalidad no crítica: ¿puede desactivarse un módulo problemático sin deploy?
- Priorización de tráfico: ¿las funciones críticas tienen garantizados recursos incluso bajo alta carga?
- Comportamiento ante datos inconsistentes o parciales: ¿el sistema falla limpio o corrompe estado?

## Metodología

1. **Inventariar las dependencias externas e internas**: para cada una, definir qué nivel de degradación es aceptable.
2. **Verificar la existencia de circuit breakers**: ¿están configurados con timeouts y thresholds apropiados? ¿Se monitorizan?
3. **Evaluar los fallbacks**: para cada dependencia con circuit breaker, ¿qué respuesta se devuelve en open state? ¿Es útil para el usuario?
4. **Detectar fallos que se tragan en silencio**: catch blocks vacíos, errores logueados pero no propagados, null returns sin contexto.
5. **Revisar el comportamiento bajo carga máxima**: ¿el sistema rechaza carga nueva limpiamente (backpressure) o colapsa?

## Resultado esperado

Para cada dependencia o componente crítico: modo de fallo ante su caída, existencia y calidad del circuit breaker/bulkhead, fallback definido, y recomendaciones para mejorar la resiliencia con impacto en UX acotado.

Usa la plantilla de hallazgo del archivo base.
