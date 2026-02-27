# Subtask: Observabilidad y Operaciones

## Persona

Mismo rol que el padre: **Tech Lead** enfocado en operaciones. Enfócate exclusivamente en observabilidad y capacidad operativa.

## Foco

- Logging estructurado (formato, niveles, correlación)
- Métricas (contadores, latencias, gauges) y su exposición
- Trazabilidad (request IDs, spans, contexto)
- Healthchecks (liveness, readiness)
- Alertabilidad (qué señales existen para disparar alertas)
- Seguimiento de errores (error tracking, integración con herramientas)
- Configuración de despliegue y operación en producción

## Metodología

1. **Errores detectables**: ante un fallo típico (timeout, excepción, fallo de dependencia), ¿un operador lo detectaría? ¿con qué información?
2. **Correlación**: ¿se puede trazar una petición o transacción a través de logs y spans?
3. **Configuración**: ¿la configuración de producción está documentada y es auditable?

## Resultado esperado

Para cada hallazgo: indica qué señal falta o es insuficiente, y qué implicación tiene para detectar y diagnosticar incidencias.

Usa la plantilla de hallazgo de `_base_audit.md`.
