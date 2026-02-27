---
id: devex.local-dev-environment
type: technique
area: devex
name: "Análisis de Entorno de Desarrollo Local"
version: 1.0.0
description: "Análisis de complejidad y fiabilidad del entorno de desarrollo local"
tags: [devex, local-dev, docker, hot-reload, environment, developer-experience]
input: "Configuración de entorno local, scripts de dev, docker-compose"
output: "Problemas de entorno identificados con mejoras priorizadas"
applicable_disciplines: [engineering]
sfia_skills: [DESN, SWDN]
estimated_tokens: 285
---

# Técnica: Análisis de Entorno de Desarrollo Local

## Foco

- Tiempo de arranque del entorno: ¿cuánto tarda desde `git clone` hasta tener el sistema corriendo?
- Paridad con producción: diferencias significativas entre local y producción que causan "works on my machine".
- Hot reload y ciclo de feedback: ¿los cambios en código se reflejan rápidamente sin reinicios manuales?
- Dependencias externas en local: bases de datos, colas, servicios de terceros — ¿están dockerizados o requieren configuración manual?
- Consumo de recursos: ¿el entorno local consume demasiada CPU/RAM para ser usable?
- Reproducibilidad: ¿dos desarrolladores con el mismo setup obtienen el mismo entorno?
- Scripts de utilidad: ¿existen comandos de make/npm/etc. para tareas comunes (seed, reset, lint, test)?

## Metodología

1. **Medir el tiempo de arranque**: desde checkout hasta primer request exitoso, contando cada paso manual.
2. **Identificar divergencias con producción**: versiones de runtime, variables de entorno, dependencias de red.
3. **Evaluar el ciclo de feedback**: cambio de código → verificación del cambio. ¿Requiere rebuild? ¿Cuántos segundos?
4. **Auditar docker-compose o equivalente**: ¿cubre todos los servicios necesarios? ¿Están los volúmenes bien configurados?
5. **Verificar la experiencia en múltiples sistemas operativos**: problemas típicos de path separators, permisos de archivos, scripts shell.

## Resultado esperado

Para cada fricción del entorno: descripción del problema, impacto en productividad diaria, solución propuesta (dockerización, scripts, configuración) y prioridad según frecuencia de impacto.

Usa la plantilla de hallazgo del archivo base.
