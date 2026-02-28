---
id: resilience.recovery-strategies
type: technique
area: resilience
name: "Análisis de Estrategias de Recuperación"
version: 1.0.0
description: "Evaluación de backups, disaster recovery y estrategias de rollback"
tags: [resilience, disaster-recovery, backup, rollback, rto, rpo]
input: "Sistema con requisitos de disponibilidad y datos críticos"
output: "Evaluación de capacidades de recuperación con gaps y mejoras"
applicable_disciplines: [engineering, data]
sfia_skills: [ARCH, RLMT, DTAN]
estimated_tokens: 300
---

# Técnica: Análisis de Estrategias de Recuperación

## Foco

- RTO (Recovery Time Objective): tiempo máximo tolerable hasta restaurar el servicio.
- RPO (Recovery Point Objective): pérdida máxima tolerable de datos en tiempo.
- Backups: frecuencia, retención, almacenamiento offsite, cifrado, y verificación de restauración.
- Disaster Recovery: ¿existe un plan documentado? ¿Ha sido probado? ¿Quién lo ejecuta?
- Rollback de deploys: ¿se puede revertir a la versión anterior en minutos? ¿Qué pasa con las migraciones de BD?
- Runbooks de incidentes: ¿existen procedimientos documentados para los fallos más probables?
- Blue-green / canary deployments: ¿permiten rollback inmediato sin downtime?

## Metodología

1. **Documentar RTO/RPO actuales vs requeridos**: ¿están definidos? ¿Se han medido en un simulacro?
2. **Auditar la estrategia de backup**: ¿cuándo fue la última restauración exitosa probada? Backups no verificados no son fiables.
3. **Revisar el proceso de rollback**: ejecutar mentalmente un rollback de deploy con migración de base de datos — ¿funciona?
4. **Evaluar el DR plan**: ¿está documentado, actualizado y conocido por el equipo? ¿Incluye contactos de emergencia?
5. **Identificar datos no incluidos en backup**: logs, caché persistida, uploads de usuarios, configuración en infraestructura.

## Resultado esperado

Para cada gap: RTO/RPO actual vs objetivo, componente o dato en riesgo, estrategia de mejora (tipo de backup, procedimiento de DR, mejora del proceso de deploy), y prioridad según criticidad del dato.

Usa la plantilla de hallazgo del archivo base.
