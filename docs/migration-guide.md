# Guía de Migración: v1 → v2

## Visión General

Este documento ayuda a migrar del sistema **v1** (estructura plana, enfocado en auditoría de código) al **sistema v2** (universal, multi-disciplina, con 11 capas composables).

El sistema v2 es **compatible hacia atrás**: los comandos v1 siguen funcionando via modo legacy. La migración es opcional y gradual.

---

## Compatibilidad hacia atrás (modo legacy)

Los siguientes comandos v1 siguen funcionando sin cambios:

```bash
# Sintaxis v1 — sigue funcionando
make compose LANG=python ROLE=01_security/_index
make clipboard LANG=python ROLE=00_orchestrator/_index
make compose LANG=bash ROLE=05_quality/_index
```

El modo legacy está implementado en `compose.sh` y se activa automáticamente cuando se usa `LANG=` en lugar de `DISC=`.

Para verificar compatibilidad completa:

```bash
./scripts/test_compose_legacy.sh
```

---

## Tabla de Migración

### Archivos de sistema

| Viejo (v1) | Nuevo (v2) | Notas |
|-----------|-----------|-------|
| `_base_audit.md` | `_base.md` + `disciplines/engineering/_base.md` | Dividido en base universal + base de disciplina |
| `lang/python.md` | `disciplines/engineering/adapters/python.md` | Movido a directorio de disciplina |
| `lang/bash.md` | `disciplines/engineering/adapters/bash.md` | Movido a directorio de disciplina |

### Roles de engineering (audit)

| Viejo (v1) | Nuevo (v2) | Notas |
|-----------|-----------|-------|
| `00_orchestrator/_index.md` | `disciplines/engineering/roles/audit/00_orchestrator/_index.md` | Movido |
| `01_security/_index.md` | `disciplines/engineering/roles/audit/01_security/_index.md` | Movido |
| `01_security/01a_injection_surfaces.md` | `techniques/security/injection-analysis.md` | Promovido a técnica cross-disciplinar |
| `01_security/01b_auth_session.md` | `techniques/security/auth-access-control.md` | Promovido a técnica |
| `01_security/01c_secrets_crypto.md` | `techniques/security/secrets-crypto.md` | Promovido a técnica |
| `01_security/01d_supply_chain.md` | `techniques/security/supply-chain.md` | Promovido a técnica |
| `02_performance/_index.md` | `disciplines/engineering/roles/audit/02_performance/_index.md` | Movido |
| `02_performance/02a_*.md` | `techniques/performance/*.md` | Promovidos a técnicas |
| `03_architecture/_index.md` | `disciplines/engineering/roles/audit/03_architecture/_index.md` | Movido |
| `04_correctness/_index.md` | `disciplines/engineering/roles/audit/04_correctness/_index.md` | Movido |
| `04_correctness/04a_*.md` | `techniques/correctness/*.md` | Promovidos a técnicas |
| `05_quality/_index.md` | Dividido entre techniques/maintainability y techniques/devex | Refactorizado |

### Subtasks → Técnicas reutilizables

En v1, las subtasks vivían dentro de roles específicos y solo eran accesibles desde ese rol. En v2, se promovieron a `techniques/` y son cross-disciplinares:

| Viejo | Nuevo | Disciplinas que lo usan ahora |
|-------|-------|-------------------------------|
| `01_security/01a_injection_surfaces.md` | `techniques/security/injection-analysis.md` | engineering, design |
| `02_performance/02a_algorithmic.md` | `techniques/performance/algorithmic-complexity.md` | engineering |
| `04_correctness/04a_edge_cases.md` | `techniques/correctness/edge-cases-contracts.md` | engineering |
| `05_quality/05a_testing.md` | `techniques/correctness/error-handling.md` | engineering, content |
| `05_quality/05c_maintainability.md` | `techniques/maintainability/code-organization.md` | engineering |

---

## Equivalencias de Comandos

### Auditoría de seguridad en Python

```bash
# Sintaxis v1
make compose LANG=python ROLE=01_security/_index

# Sintaxis v2 equivalente
make compose DISC=engineering ADAPTER=python ROLE=audit/01_security/_index

# Sintaxis v2 con técnicas explícitas (más potente)
make compose DISC=engineering ADAPTER=python ROLE=audit/01_security/_index \
  EXT="techniques/security/injection-analysis techniques/security/auth-access-control"
```

### Auditoría completa

```bash
# Sintaxis v1
make compose LANG=python ROLE=00_orchestrator/_index

# Sintaxis v2 — usando chain completa
make chain CHAIN=full-audit ADAPTER=python

# O directamente
make compose DISC=engineering ADAPTER=python ROLE=audit/00_orchestrator/_index
```

### Copia al portapapeles

```bash
# v1
make clipboard LANG=python ROLE=01_security/_index

# v2
make clipboard DISC=engineering ADAPTER=python ROLE=audit/01_security/_index
```

### Conversión automática de comandos

El script `migrate_compose_cmd.sh` convierte comandos v1 a v2:

```bash
# Convierte un comando v1
./scripts/migrate_compose_cmd.sh "make compose LANG=python ROLE=01_security/_index"
# Output: make compose DISC=engineering ADAPTER=python ROLE=audit/01_security/_index
```

---

## Cambios Conceptuales

### De estructura plana a jerárquica

**Antes (v1)**: todos los roles en el directorio raíz con numeración plana.
```
00_orchestrator/
01_security/
02_performance/
```

**Ahora (v2)**: roles organizados por `disciplina/task_type/nombre`.
```
disciplines/engineering/roles/audit/00_orchestrator/
disciplines/engineering/roles/audit/01_security/
disciplines/engineering/roles/generate/02_implementer/
```

**Por qué**: permite múltiples disciplinas sin colisiones de nombres, y el `task_type` hace explícita la intención del rol (auditar vs. generar vs. planificar).

### De subtasks a técnicas reutilizables

**Antes (v1)**: las subtasks vivían dentro de un rol específico y solo ese rol podía referenciarlas.

**Ahora (v2)**: las técnicas son ciudadanos de primera clase en `techniques/`, con `applicable_disciplines` que declara dónde pueden usarse.

**Por qué**: una técnica como `injection-analysis` es útil para seguridad en ingeniería, pero también para diseño de formularios en design. Mantenerla en un solo lugar evita duplicación y mejora de forma coordinada.

### Metadata estructurada (front-matter)

**Antes (v1)**: sin metadata formal.

**Ahora (v2)**: front-matter YAML en cada archivo con campos obligatorios (`id`, `type`, `version`, `description`) y opcionales (`sfia_skills`, `connects_to`, `capabilities_required`).

**Por qué**: permite descubrimiento automático, validación, y generación de nuevas piezas con meta-prompts.

### Multi-disciplina

**Antes (v1)**: sistema enfocado exclusivamente en auditoría de código (engineering).

**Ahora (v2)**: 5 disciplinas (engineering, content, design, business, management) con estructura extensible para añadir más.

**Por qué**: los mismos principios de composición modular aplican a cualquier trabajo profesional asistido por IA.

---

## Proceso de Migración Gradual

El sistema v2 convive con v1 sin ruptura. Para migrar gradualmente:

### Fase 1: Uso en paralelo (sin cambios)

Los comandos v1 siguen funcionando. Empieza a usar la sintaxis v2 solo para funcionalidades nuevas (disciplinas distintas de engineering, chains, modifiers).

### Fase 2: Migrar comandos existentes

Usa `scripts/migrate_compose_cmd.sh` para convertir tus scripts e integraciones existentes:

```bash
# Ejemplo
./scripts/migrate_compose_cmd.sh "LANG=python make clipboard ROLE=01_security/_index"
```

### Fase 3: Aprovechar las nuevas capacidades

Con la sintaxis v2, activa knowledge packs, modifiers y técnicas explícitas para mejorar la calidad:

```bash
# Antes (v1)
make compose LANG=python ROLE=01_security/_index

# Después (v2 completo)
make compose DISC=engineering ADAPTER=python ROLE=audit/01_security/_index \
  EXT="knowledge/security-awareness modifiers/depth/deep"
```

### Fase 4 (opcional): Deprecar modo legacy

Cuando todos tus flujos usen sintaxis v2, el modo legacy puede desactivarse editando `compose.sh`.

---

## Archivos deprecados

Los siguientes archivos v1 están en `_deprecated/` y no deben editarse:

| Archivo | Estado | Reemplazado por |
|---------|--------|----------------|
| `_deprecated/_base_audit.md.bak` | Deprecated | `_base.md` + `disciplines/engineering/_base.md` |
| `_deprecated/lang/python.md` | Deprecated | `disciplines/engineering/adapters/python.md` |
| `_deprecated/lang/bash.md` | Deprecated | `disciplines/engineering/adapters/bash.md` |
| `_deprecated/00_orchestrator/` | Deprecated | `disciplines/engineering/roles/audit/00_orchestrator/` |
| `_deprecated/01_security/` | Deprecated | `disciplines/engineering/roles/audit/01_security/` + `techniques/security/` |

---

## Preguntas Frecuentes

**¿Mis integraciones con LANG= dejarán de funcionar?**
No. El modo legacy está garantizado indefinidamente mediante `test_compose_legacy.sh`.

**¿Debo migrar todo a la vez?**
No. La migración es gradual y opcional. Empieza por los flujos que quieras mejorar.

**¿Las subtasks desaparecen?**
Los contenidos de subtasks se promovieron a `techniques/`. Se accede a ellos via `EXT="techniques/..."` en la composición.

**¿Cómo sé si una pieza tiene equivalente en v2?**
Consulta las tablas de migración anteriores o ejecuta: `./scripts/migrate_compose_cmd.sh --check <comando-v1>`.

---

## Soporte

- Issues y preguntas: [GitHub Issues](https://github.com/<usuario>/audit-prompts/issues)
- Para migraciones complejas: consultar `docs/architecture.md` para entender el diseño del sistema v2
