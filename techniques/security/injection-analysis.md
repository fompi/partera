---
id: security.injection-analysis
type: technique
area: security
name: "Análisis de Superficies de Inyección"
version: 1.0.0
description: "Rastreo de flujo de datos contaminados desde entry points hasta sinks"
tags: [security, injection, taint-analysis, vulnerability]
input: "Sistema, proceso o código a analizar"
output: "Mapa de flujos de taint con evaluación de saneamiento"
applicable_disciplines: [engineering, ai, data]
sfia_skills: [SCTY, HSIN]
estimated_tokens: 280
migrated_from: "01_security/01a_injection_surfaces.md"
---

# Técnica: Análisis de Superficies de Inyección

## Foco

- Inyección SQL
- Inyección de comandos (command injection)
- Inyección en plantillas (template injection)
- Path traversal
- SSRF (Server-Side Request Forgery)
- Deserialización insegura

## Metodología

1. **Rastrear flujo de datos contaminados**: desde puntos de entrada (inputs HTTP, argumentos CLI, ficheros, variables de entorno) hasta sinks (queries SQL, exec/subprocess, eval, plantillas, rutas de fichero, requests HTTP).
2. **Evaluar saneamiento**: en cada sink encontrado, verificar si existe validación, escapado o uso de APIs seguras (p.ej. prepared statements, parametrización).
3. **Valorar adecuación**: el saneamiento actual, ¿es suficiente para el contexto de uso? ¿Bypass plausible?

## Resultado esperado

Para cada sink identificado: muestra el **flujo de taint** (origen → transformaciones → sink) y evalúa la **adecuación del saneamiento**. Marca como hipótesis si falta contexto para confirmar explotabilidad.

Usa la plantilla de hallazgo del archivo base.
