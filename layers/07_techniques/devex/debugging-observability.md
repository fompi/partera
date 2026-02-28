---
id: devex.debugging-observability
type: technique
area: devex
name: "Análisis de Debugging y Observabilidad"
version: 1.0.0
description: "Evaluación de logs, trazas y métricas para diagnóstico efectivo"
tags: [devex, observability, logging, tracing, metrics, debugging]
input: "Sistema o codebase con instrumentación a evaluar"
output: "Gaps de observabilidad identificados con propuestas de mejora"
applicable_disciplines: [engineering, data, ai]
sfia_skills: [DESN, SWDN, MONI]
estimated_tokens: 295
---

# Técnica: Análisis de Debugging y Observabilidad

## Foco

- Calidad de logs: ¿tienen contexto suficiente (request ID, user ID, timestamp)? ¿Son buscables?
- Niveles de log coherentes: ¿se usa ERROR para errores, DEBUG para detalle? ¿Hay logging excesivo en producción?
- Trazas distribuidas: ¿se propaga el trace ID entre servicios? ¿Se puede reconstruir el flujo de una request?
- Métricas de negocio: ¿se miden las acciones críticas además de las métricas de infraestructura?
- Alertas accionables: ¿las alertas apuntan a síntomas con runbooks? ¿Hay alert fatigue?
- Dificultad para reproducir errores localmente: ¿existen herramientas para simular condiciones de producción?

## Metodología

1. **Evaluar los tres pilares**: logs (qué pasó), métricas (cuánto/cuándo), trazas (por dónde pasó).
2. **Revisar la calidad de los logs de error**: ante un error en producción, ¿los logs existentes permitirían diagnosticarlo sin acceso a producción?
3. **Verificar la propagación de contexto**: en sistemas distribuidos, ¿se mantiene el correlation ID entre llamadas?
4. **Analizar el tiempo medio de diagnóstico (MTTD)**: ¿cuánto tarda el equipo en localizar la causa raíz de un incidente típico?
5. **Identificar puntos ciegos**: componentes o flujos sin instrumentación donde los fallos serían invisibles.

## Resultado esperado

Para cada gap de observabilidad: tipo (log/métrica/traza), componente afectado, escenario donde sería un problema, solución propuesta con herramientas o cambios de código específicos.

Usa la plantilla de hallazgo del archivo base.
