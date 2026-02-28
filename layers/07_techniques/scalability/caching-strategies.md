---
id: scalability.caching-strategies
type: technique
area: scalability
name: "Análisis de Estrategias de Caché"
version: 1.0.0
description: "Análisis de estrategias de caché: TTL, invalidación y coherencia"
tags: [scalability, caching, ttl, invalidation, cache-coherence, performance]
input: "Sistema o componente con capas de caché a analizar"
output: "Evaluación de efectividad de caché con propuestas de mejora"
applicable_disciplines: [engineering, data, ai]
sfia_skills: [ARCH, DESN]
estimated_tokens: 310
---

# Técnica: Análisis de Estrategias de Caché

## Foco

- Estrategias de escritura: write-through, write-behind, write-around y sus implicaciones.
- Políticas de TTL: valores inadecuados (demasiado cortos = bajo hit rate, demasiado largos = datos obsoletos).
- Estrategias de invalidación: event-driven vs TTL-based; riesgo de cache stampede.
- Coherencia en entornos distribuidos: múltiples instancias con caché local divergente.
- Cache poisoning y corrupción de datos en caché.
- Hit rate actual: porcentaje de aciertos y su impacto medible en latencia/throughput.
- Cacheo de datos mutables sin invalidación correcta.

## Metodología

1. **Inventariar las capas de caché**: DNS, CDN, HTTP (Cache-Control), aplicación (in-memory, Redis), DB query cache.
2. **Evaluar la política de TTL por capa**: ¿está justificada para la volatilidad de los datos?
3. **Analizar la estrategia de invalidación**: ¿cómo se invalida la caché cuando el dato de origen cambia? ¿Existe el riesgo de stampede?
4. **Verificar coherencia en instancias múltiples**: ¿caché local o compartida? ¿Se pueden leer datos inconsistentes entre instancias?
5. **Medir o estimar el hit rate**: si no hay métricas, identificar los patrones de acceso para estimarlo.

## Resultado esperado

Para cada capa de caché: hit rate actual/estimado, problemas de coherencia o invalidación, estrategia mejorada con TTL recomendado, y el impacto esperado en latencia y carga sobre el origen.

Usa la plantilla de hallazgo del archivo base.
