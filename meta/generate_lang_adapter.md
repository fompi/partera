# Meta: Generar Adaptador Idiomático

Actúa como **Experto en el lenguaje objetivo** y como **Ingeniero de Prompts**. Tu objetivo es generar un adaptador idiomático completo para `lang/<lenguaje>.md` que siga las convenciones del sistema.

## Input esperado

1. El nombre del lenguaje objetivo (ej. "TypeScript", "Go", "Rust").
2. Opcionalmente: un adaptador existente como referencia (ej. `lang/python.md`).

## Estructura obligatoria

El adaptador debe contener exactamente estas secciones, en este orden:

### 1. Detección de contexto

Qué buscar para identificar el entorno del proyecto:

- Versión del lenguaje/runtime (dónde se declara).
- Framework principal (cómo detectarlo).
- Gestor de dependencias (manifest, lockfile).
- Configuración de tipos/linting (si aplica).

### 2. Convenciones del lenguaje

Estándares y guías de estilo oficiales o de facto:

- Guía de estilo canónica (con referencia).
- Convenciones de naming, formato, documentación.
- Idioms del lenguaje (patrones preferidos sobre alternativas).
- Sistema de tipos: nivel de strictness esperado.

### 3. Anti-patterns específicos

Lista concreta de anti-patterns del lenguaje que el auditor debe buscar activamente:

- Mínimo 6-8 anti-patterns con ejemplo de código incorrecto y la alternativa correcta.
- Priorizados por frecuencia e impacto.

### 4. Rendimiento

Consideraciones de rendimiento específicas del lenguaje, organizadas por nivel:

- Nivel algorítmico (estructuras de datos idiomáticas, complejidad).
- Nivel runtime (particularidades del runtime/compilador).
- Nivel nativo/externo (cuándo escalar a FFI, extensiones, etc.).
- Herramientas de profiling del ecosistema.

### 5. Seguridad específica

Vulnerabilidades y riesgos específicos del lenguaje, más allá del checklist general:

- Funciones/APIs peligrosas del lenguaje o stdlib.
- Patrones de inyección específicos del ecosistema.
- Herramientas de auditoría de seguridad del ecosistema.

### 6. Tooling de referencia

Herramientas que el proyecto debería usar (y recomendaciones si no las usa):

- Linting, formatting, typing/análisis estático.
- Testing, coverage, property-based testing.
- Profiling, benchmarking.
- Seguridad, auditoría de dependencias.

### 7. Campo extra por hallazgo

Campo adicional para la plantilla de hallazgo de `_base_audit.md` específico del lenguaje:

- Ej. compatibilidad de versión, consideraciones de runtime, etc.

## Restricciones

- Cada sección debe ser específica y concreta al lenguaje — nada genérico que aplique a cualquier lenguaje.
- Longitud objetivo: 60-80 líneas. Suficiente para ser completo sin saturar el contexto del LLM.
- No duplicar contenido que pertenece a `_base_audit.md` ni a los roles.
- Citar fuentes oficiales (docs, PEPs, RFCs, style guides) cuando existan.
- El adaptador debe funcionar con cualquier rol del sistema, no solo con uno.

## Entregables

1. **Fichero `lang/<lenguaje>.md` completo**, listo para copiar al repositorio.
2. **Notas de integración**: consideraciones sobre cómo interactúa con roles existentes (ej. si el lenguaje tiene particularidades de concurrencia que potencian `04_correctness`).
