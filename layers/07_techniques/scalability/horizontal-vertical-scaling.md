---
id: scalability.horizontal-vertical
type: technique
area: scalability
name: "Análisis de Escalabilidad Horizontal y Vertical"
version: 1.0.0
description: "Evaluación de estrategias de escalado y cuellos de botella"
tags: [scalability, horizontal-scaling, vertical-scaling, bottleneck]
input: "Arquitectura, sistema o proceso a escalar"
output: "Recomendaciones de escalado con trade-offs"
applicable_disciplines: [engineering, data, ai]
sfia_skills: [ARCH, DESN]
estimated_tokens: 320
---

# Técnica: Análisis de Escalabilidad Horizontal y Vertical

## Foco

- Identificación de cuellos de botella que limitan el crecimiento de carga.
- Evaluación de la viabilidad de escalado vertical (más CPU/RAM en el mismo nodo) vs horizontal (más instancias).
- Componentes con estado que dificultan el escalado horizontal (sesiones, caché local, archivos en disco).
- Límites de las bases de datos: conexiones, locks, escrituras únicas, esquemas que no particionan bien.
- Dependencias que concentran carga (single points of throughput): colas únicas, servicios sin réplicas, APIs externas con rate limits.

## Metodología

1. **Mapear la topología actual**: identificar cada componente, su rol y si mantiene estado.
2. **Localizar el cuello de botella dominante**: bajo carga, ¿qué recurso se satura primero? (CPU, memoria, I/O, red, conexiones DB).
3. **Evaluar escalado vertical**: ¿puede resolverse aumentando recursos del nodo? Identificar el techo práctico (coste, disponibilidad de hardware).
4. **Evaluar escalado horizontal**: ¿el componente puede correr en múltiples instancias sin coordinación? Listar los requisitos: stateless, sesiones distribuidas, caché compartida, idempotencia.
5. **Estimar límite teórico**: con el escalado propuesto, ¿cuál sería el siguiente cuello de botella a N instancias?

## Resultado esperado

Para cada cuello de botella: estrategia recomendada (vertical/horizontal/ambas), cambios requeridos en el diseño, trade-offs de complejidad operacional y coste, y el límite aproximado que se alcanza con la mejora.

Usa la plantilla de hallazgo del archivo base.
