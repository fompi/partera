---
id: resilience.failure-modes
type: technique
area: resilience
name: "Análisis de Modos de Fallo"
version: 1.0.0
description: "Identificación de puntos únicos de falla y degradación"
tags: [resilience, fault-tolerance, spof, degradation]
input: "Arquitectura, sistema o proceso crítico"
output: "Mapa de failure modes con mitigaciones"
applicable_disciplines: [engineering, data, ai]
sfia_skills: [ARCH, RLMT]
estimated_tokens: 310
---

# Técnica: Análisis de Modos de Fallo

## Foco

- Single Points of Failure (SPOF): componentes cuya caída detiene el sistema completo.
- Modos de fallo en cascada: fallos que se propagan a componentes dependientes.
- Dependencias síncronas sin timeout: llamadas que bloquean indefinidamente ante fallos externos.
- Componentes sin redundancia: bases de datos sin réplicas, colas sin persistencia, servicios sin failover.
- Fallos silenciosos: errores que no se detectan y corrompen el estado del sistema gradualmente.
- Límites de capacidad como modo de fallo: thread pools, connection pools, disk space que si se agotan causan fallo total.

## Metodología

1. **Construir el mapa de dependencias**: para cada componente, listar sus dependencias síncronas y asíncronas.
2. **Aplicar análisis FMEA (Failure Mode and Effects Analysis)**: para cada componente, preguntar "¿qué pasa si este falla?".
3. **Identificar SPOFs**: componentes sin redundancia en rutas críticas.
4. **Evaluar la propagación**: ¿un fallo en el componente A se propaga a B y C? ¿Existe circuit breaker o bulkhead?
5. **Clasificar por impacto**: disponibilidad total, degradación parcial, pérdida de datos, corrupción silenciosa.

## Resultado esperado

Mapa de failure modes con: componente afectado, tipo de fallo, impacto en el sistema, probabilidad estimada (alta/media/baja), y mitigación recomendada (redundancia, circuit breaker, timeout, graceful degradation).

Usa la plantilla de hallazgo del archivo base.
