---
id: devex.onboarding-friction
type: technique
area: devex
name: "Análisis de Fricción en Onboarding"
version: 1.0.0
description: "Evaluación de complejidad en setup y primeros pasos"
tags: [devex, onboarding, developer-experience, setup]
input: "Documentación, scripts de setup, arquitectura"
output: "Puntos de fricción identificados con soluciones"
applicable_disciplines: [engineering, content]
sfia_skills: [DESN, USUP]
estimated_tokens: 290
---

# Técnica: Análisis de Fricción en Onboarding

## Foco

- Requisitos previos no documentados (versiones de runtime, herramientas, permisos).
- Pasos manuales en el setup que podrían automatizarse.
- Secretos y configuración de entorno: ¿hay un `.env.example`? ¿Se explica cómo obtener cada valor?
- Tiempo hasta "primer output útil": ¿puede un desarrollador nuevo ver algo funcionando en menos de 30 minutos?
- Dependencias de servicios externos difíciles de replicar localmente (bases de datos de producción, servicios SaaS).
- Documentación desactualizada respecto al estado real del proyecto.
- Ausencia de scripts de seed o fixtures para datos de prueba.

## Metodología

1. **Seguir el README desde cero**: simular el proceso de onboarding, identificar cada paso que falla o requiere conocimiento implícito.
2. **Auditar las dependencias de setup**: ¿están pinneadas a versiones específicas? ¿Funcionan en múltiples OSes?
3. **Revisar la gestión de configuración**: ¿todos los valores necesarios están documentados con descripción y ejemplo?
4. **Medir la profundidad del grafo de dependencias de setup**: cada herramienta que hay que instalar es un punto de fricción potencial.
5. **Identificar la primera barrera de entrada**: el primer paso que típicamente bloquea a nuevos desarrolladores.

## Resultado esperado

Lista ordenada de puntos de fricción con: descripción del problema, impacto en tiempo de onboarding, solución propuesta (documentación, automatización, simplificación) y esfuerzo estimado.

Usa la plantilla de hallazgo del archivo base.
