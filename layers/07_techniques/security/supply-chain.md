---
id: security.supply-chain
type: technique
area: security
name: "Análisis de Cadena de Suministro"
version: 1.0.0
description: "Evaluación de seguridad de dependencias: CVEs, fijación de versiones y lockfiles"
tags: [security, supply-chain, dependencies, cve, lockfile]
input: "Archivos de dependencias del proyecto (requirements.txt, package.json, Cargo.toml, etc.)"
output: "Estado de dependencias: CVEs conocidos, fijación, lockfile y recomendaciones"
applicable_disciplines: [engineering, ai, data]
sfia_skills: [SCTY, RLMT]
estimated_tokens: 250
migrated_from: "0001_security/01d_supply_chain.md"
---

# Técnica: Análisis de Cadena de Suministro

## Foco

- Dependencias con CVEs conocidos
- Versiones sin fijar (rangos amplios, `^`, `~`, `*`)
- Presencia y uso de lockfile (`package-lock.json`, `Pipfile.lock`, `poetry.lock`, etc.)
- Riesgo de typosquatting (nombres similares a paquetes populares)
- Dependencias abandonadas (sin mantenimiento, sin actualizaciones)
- Herramientas de auditoría: uso de `npm audit`, `pip-audit`, `cargo audit`, Dependabot, etc.

## Metodología

1. **Revisar archivos de dependencias**: `requirements.txt`, `pyproject.toml`, `package.json`, `Cargo.toml`, etc.
2. **Comprobar fijación de versiones**: ¿existen versiones exactas o rangos peligrosos?
3. **Verificar lockfile**: ¿existe? ¿Se usa en CI/CD?
4. **Evaluar madurez**: dependencias con muchos maintainers, última actualización, adopción.
5. **Buscar tooling de auditoría**: scripts, workflows, integración en pipeline.

## Resultado esperado

Resumen del estado de dependencias: CVEs conocidos, prácticas de fijación, recomendaciones para lockfile y auditoría automatizada.

Usa la plantilla de hallazgo del archivo base.
