---
id: management.adapter.waterfall
type: adapter
discipline: management
name: "Waterfall"
version: 1.0.0
description: "Adaptador para gestión en cascada"
tags: [waterfall, sequential, phased]
estimated_tokens: 320
---

# Adaptador: Waterfall

## Contexto de uso

Proyectos con requisitos estables y bien definidos desde el inicio, entornos regulados que requieren documentación exhaustiva (industria farmacéutica, defensa, gobierno), o contratos de precio fijo con alcance cerrado.

## Fases estándar

```
1. INICIACIÓN
   ├─ Project charter aprobado
   ├─ Stakeholders identificados
   └─ Viabilidad inicial evaluada

2. PLANIFICACIÓN
   ├─ Requisitos detallados documentados (BRD/FRD)
   ├─ Plan de proyecto (WBS, Gantt, recursos)
   ├─ Plan de gestión de riesgos
   ├─ Plan de comunicación
   └─ Baseline aprobado (scope, schedule, cost)

3. EJECUCIÓN
   ├─ Diseño (arquitectura, especificaciones técnicas)
   ├─ Desarrollo/Construcción
   └─ Integración

4. TESTING / VERIFICACIÓN
   ├─ Testing funcional
   ├─ UAT (User Acceptance Testing)
   └─ Corrección de defectos

5. DESPLIEGUE / IMPLEMENTACIÓN
   ├─ Deployment plan ejecutado
   ├─ Formación de usuarios
   └─ Go-live

6. CIERRE
   ├─ Acceptance sign-off del cliente
   ├─ Documentación final entregada
   ├─ Lecciones aprendidas
   └─ Liberación de recursos
```

## Documentos clave en waterfall

- **Project Charter**: autorización formal del proyecto y del PM.
- **Business Requirements Document (BRD)**: qué necesita el negocio.
- **Functional Requirements Document (FRD)**: cómo debe funcionar el sistema.
- **Work Breakdown Structure (WBS)**: descomposición jerárquica del trabajo.
- **Project Plan (Gantt)**: tareas, dependencias, responsables, fechas.
- **Risk Register**: riesgos, probabilidad, impacto, mitigación, estado.
- **Change Request Log**: todo cambio al baseline pasa por control de cambios.

## Control de cambios

En waterfall, el scope creep es el enemigo principal. Todo cambio debe:
1. Documentarse formalmente (Change Request).
2. Analizarse en impacto (coste, plazo, calidad).
3. Aprobarse por el Change Control Board antes de implementarse.

## Anti-patrones waterfall

- Iniciar la ejecución sin baseline aprobado por todos los stakeholders.
- Descubrir requisitos durante el desarrollo (fallo en la fase de requisitos).
- Testing al final del proyecto, cuando el coste de corrección es máximo.
- No actualizar el plan cuando hay desviaciones (el plan pierde validez como herramienta de control).
- Change requests informales sin aprobación formal.

## Cuándo waterfall es inapropiado

- Cuando los requisitos son exploratorios o van a cambiar significativamente.
- Cuando el time-to-market es prioritario y el feedback temprano es valioso.
- Cuando el equipo es pequeño y la overhead documental supera el beneficio.
