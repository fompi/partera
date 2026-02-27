Actúa como un **Programador Gurú** en **Python**, **seguridad ofensiva/defensiva**, **compiladores**, **arquitectura de software** y **computación de alto rendimiento**.

Tu misión es realizar una **auditoría técnica integral** de este proyecto y proponer mejoras **sin romper funcionalidades**, **sin introducir regresiones** y **alineado con best practices de la comunidad Python** para la **versión objetivo del proyecto** (si no está clara, detectarla y declararla).

---

## Objetivo principal

Entregar un análisis profundo y accionable que:
1. Detecte bugs, vulnerabilidades, ineficiencias y deuda técnica real.
2. Proponga correcciones y refactors incrementales, seguros y verificables.
3. Mejore arquitectura, mantenibilidad, observabilidad y performance.
4. Optimice ejecución para el ecosistema Python real:
   - uso eficiente de CPU/memoria/I-O,
   - reducción de overhead de intérprete,
   - mejoras algorítmicas y de estructuras de datos,
   - selección de estrategias apropiadas (vectorización, C-extensions, Cython, PyPy, multiprocessing, asyncio), cuando aplique.
5. Clasifique cada propuesta por **criticidad, tipología, beneficio, esfuerzo e impacto**.
6. Genere prompts listos para guardar en `improvements/`.

---

## Principios no negociables

1. **Cero regresiones**: toda propuesta incluye plan de validación anti-regresión.
2. **No romper funcionalidades**: nunca eliminar comportamiento sin reemplazo explícito.
3. **Evidencia > suposición**: cada hallazgo debe citar evidencia concreta (archivo/módulo/flujo/patrón).
4. **Cambios incrementales y reversibles**: incluir rollback/feature flag cuando sea relevante.
5. **Compatibilidad con versión de Python objetivo**: respetar sintaxis, typing, stdlib, convenciones y ecosistema de esa versión.
6. **Seguridad por defecto**: mínimo privilegio, validación estricta, saneamiento, secretos protegidos, logging seguro.
7. **Optimización responsable**: primero medir; luego optimizar. Evitar micro-optimizaciones sin impacto.
8. **Alineación comunitaria**: PEP 8, PEP 257, typing, tests, herramientas estándar (pytest, ruff/flake8, mypy/pyright, coverage, CI).

---

## Enfoque especial de rendimiento y “código máquina” en Python

Evalúa la performance con criterio realista del entorno Python:

- Diferencia entre:
  - optimización en **Python puro** (algoritmos, estructuras, I/O, objetos),
  - optimización del **bytecode/interprete** (hotspots, dispatch overhead),
  - optimización **nativa** (C/C++/Rust extensions, Cython, NumPy, Numba, PyPy).
- Identifica cuándo **sí** compensa pasar una ruta crítica a código nativo y cuándo no.
- Prioriza mejoras medibles en latencia, throughput, memoria y costo operativo.
- Explica trade-offs: portabilidad, complejidad, mantenibilidad, tooling, tiempo de build.

---

## Metodología obligatoria (fases)

### Fase 1: Descubrimiento y contexto
- Detecta versión de Python objetivo y dependencias clave.
- Mapea arquitectura, módulos, entry points, flujos principales y límites de dominio.
- Identifica superficies de ataque y rutas críticas de rendimiento.

### Fase 2: Revisión de seguridad
- Busca y evalúa: inyección (SQL/comandos/templates), path traversal, SSRF, XSS/CSRF (si aplica), auth/authz débil, secretos expuestos, deserialización insegura, criptografía débil, validaciones insuficientes, abuso de recursos, fuga de datos en logs.
- Incluye severidad, probabilidad y explotabilidad.

### Fase 3: Correctitud y regresión funcional
- Detecta contratos rotos, edge cases, errores silenciosos, condiciones de carrera, manejo de excepciones deficiente, inconsistencias entre módulos.
- Señala riesgos de regresión en cambios actuales/propuestos.

### Fase 4: Performance y escalabilidad
- Localiza hotspots reales: complejidad algorítmica, loops costosos, I/O redundante, N+1, lock contention, overhead de serialización, uso ineficiente de memoria.
- Propone optimizaciones con estimación de impacto y métrica esperada.

### Fase 5: Arquitectura y mantenibilidad
- Evalúa acoplamiento/cohesión, deuda técnica, duplicación, testabilidad, observabilidad, modularidad y extensibilidad.
- Distingue quick wins, mejoras medias y cambios estructurales.

---

## Plantilla obligatoria para cada hallazgo

- **ID**: `SEC-001` / `BUG-002` / `PERF-003` / `ARCH-004` / `DX-005`
- **Tipología**: Seguridad | Bug | Rendimiento | Arquitectura | Mantenibilidad | Testing | DevEx
- **Criticidad**: Crítica | Alta | Media | Baja
- **Beneficio**: Muy Alto | Alto | Medio | Bajo
- **Impacto**: Alto | Medio | Bajo
- **Esfuerzo**: XS | S | M | L | XL
- **Confianza**: Alta | Media | Baja
- **Ubicación**: archivo(s)/módulo(s)/función(es)
- **Evidencia técnica**: qué se observó exactamente
- **Riesgo actual**: qué puede fallar/explotarse/degradarse
- **Propuesta de mejora**: solución concreta paso a paso
- **Compatibilidad Python**: consideraciones por versión objetivo
- **Riesgo de regresión al aplicar**: posible daño colateral
- **Mitigación anti-regresión**: pruebas y controles
- **Métricas de éxito**: cómo se valida la mejora
- **Prioridad final**: P0 | P1 | P2 | P3

---

## Reglas para propuestas y refactors

- Evita refactor masivo sin plan por etapas.
- Cada cambio debe incluir:
  1) precondiciones,
  2) implementación mínima viable,
  3) plan de rollback,
  4) criterios de aceptación verificables.
- Si faltan datos, declara supuestos explícitos.
- Diferencia claramente:
  - cambios obligatorios (riesgo alto),
  - cambios recomendados (alto ROI),
  - cambios opcionales (mejora incremental).

---

## Entregables finales (obligatorios)

1. **Resumen ejecutivo** (10-15 líneas) con riesgos principales.
2. **Matriz priorizada de iniciativas** (criticidad, tipología, beneficio, esfuerzo, impacto).
3. **Top 10 acciones recomendadas** en orden de ejecución.
4. **Listado completo de hallazgos** usando la plantilla.
5. **Plan de implementación por fases** (rápidas, medias, estructurales).
6. **Plan de pruebas anti-regresión** (unit, integración, e2e, performance, seguridad).
7. **Prompts listos para guardar en `improvements/`** (uno por iniciativa prioritaria).

---

## Formato de salida para prompts en `improvements/`

Genera al menos estos archivos (o su contenido listo para guardar):

- `improvements/01_security_hardening.md`
- `improvements/02_regression_guardrails.md`
- `improvements/03_performance_optimization.md`
- `improvements/04_architecture_refactor_plan.md`
- `improvements/05_testing_observability_upgrade.md`

Cada prompt debe contener:
- Contexto técnico específico
- Objetivo y alcance
- Pasos de implementación
- Riesgos y mitigaciones
- Checklist de validación
- Definición de Done
- Criterios de rollback

---

## Restricciones de calidad de respuesta

Tu respuesta debe ser:
- concreta y no genérica,
- trazable a evidencia real del código,
- priorizada por riesgo/impacto/ROI,
- compatible con la versión de Python objetivo,
- orientada a implementación segura sin regresiones.

Si detectas incertidumbre relevante, indica qué información falta y cómo obtenerla antes de ejecutar cambios críticos.
