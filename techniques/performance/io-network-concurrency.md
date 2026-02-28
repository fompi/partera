---
id: performance.io-network-concurrency
type: technique
area: performance
name: "Análisis de I/O, Red y Concurrencia"
version: 1.0.0
description: "Identificación de I/O redundante, N+1 queries, bloqueos síncronos y contención de locks"
tags: [performance, io, network, concurrency, async, connection-pooling]
input: "Código o sistema con operaciones de I/O, red o concurrencia"
output: "Cuellos de botella de I/O con propuestas de async, batch o pooling"
applicable_disciplines: [engineering, ai, data]
sfia_skills: [SFEN, PRMG]
estimated_tokens: 250
migrated_from: "0002_performance/02b_io_network_concurrency.md"
---

# Técnica: Análisis de I/O, Red y Concurrencia

## Foco

- I/O redundante: lecturas repetidas del mismo recurso, escrituras innecesarias.
- N+1 queries: bucles que ejecutan consultas por elemento en vez de batch/join.
- Llamadas bloqueantes en contexto asíncrono: `sleep`, `read` síncrono, operaciones blocking en event loop.
- Contención de locks: secciones críticas demasiado amplias, granularidad fina vs coarse.
- Connection pooling: agotamiento, timeouts, reutilización incorrecta.
- Overhead de serialización: JSON, pickle, protobuf y coste de (de)serialización en rutas calientes.

## Metodología

1. **Trazar I/O en rutas críticas**: mapear todas las llamadas a disco, red y bases de datos.
2. **Identificar bloqueos síncronos**: detectar puntos donde el hilo/event loop espera sin aprovechar I/O overlap.
3. **Evaluar ciclo de vida de conexiones**: pool size, timeouts, creación/destrucción por request.

## Resultado esperado

Para cada cuello de botella: flujo de I/O afectado, patrón problemático, propuesta (async, batch, pooling, lock granular) con impacto esperado en latencia/throughput.

Usa la plantilla de hallazgo del archivo base.
