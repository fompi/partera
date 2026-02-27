---
id: scalability.load-distribution
type: technique
area: scalability
name: "Análisis de Distribución de Carga"
version: 1.0.0
description: "Evaluación de balanceo de carga, particionamiento y sharding"
tags: [scalability, load-balancing, sharding, partitioning, distribution]
input: "Arquitectura o sistema con distribución de carga a evaluar"
output: "Análisis de distribución actual con estrategias de mejora"
applicable_disciplines: [engineering, data]
sfia_skills: [ARCH, DESN, DTAN]
estimated_tokens: 300
---

# Técnica: Análisis de Distribución de Carga

## Foco

- Estrategias de balanceo de carga: round-robin, least-connections, consistent hashing, weighted.
- Distribución no uniforme (hot spots): particiones o nodos que reciben desproporcionalmente más carga.
- Sharding de bases de datos: shard key, distribución de datos, cross-shard queries.
- Particionamiento de colas y eventos: topic partitions, consumer groups, rebalanceo.
- Afinidad de sesión (sticky sessions) y su impacto en la distribución.
- Heterogeneidad de nodos: instancias con diferente capacidad recibiendo el mismo peso.

## Metodología

1. **Revisar la estrategia de distribución actual**: ¿qué algoritmo se usa y por qué?
2. **Buscar evidencia de hot spots**: métricas de carga por nodo/partición, diferencias de latencia entre instancias.
3. **Evaluar la shard key o partition key**: ¿genera distribución uniforme? ¿Puede convertirse en hot spot con patrones reales de acceso?
4. **Analizar impacto de sticky sessions**: ¿comprometen la distribución uniforme? ¿Son necesarias o son un workaround de diseño?
5. **Proponer rebalanceo o cambio de estrategia**: con estimación del impacto en uniformidad.

## Resultado esperado

Para cada problema de distribución: estrategia actual, evidencia del desequilibrio, alternativa propuesta con trade-offs de complejidad y consistencia, y mejora esperada en uniformidad.

Usa la plantilla de hallazgo del archivo base.
