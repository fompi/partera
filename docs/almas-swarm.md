# Almas para swarm de ayudantes IA

Índice de almas por disciplina y ejemplos de flujos entre almas en un swarm. El adaptador (python, technical, agile, etc.) se elige al invocar; las almas definen el rol y las capas extra.

## Índice por disciplina

- **Engineering (audit)**: audit-orchestrator, security-executive, security-fintech, security-healthcare, security-quick, architecture-review, architecture-teaching, quality-audit, v02/security-deep, v02/performance-deep, v02/correctness-deep
- **Engineering (generate)**: spec-writer, spec-writer-pedagogical, tech-advisor, implementer-claude, implementer-ollama, implementer-crewai, reviewer, reviewer-correctness, reviewer-junior, documenter, frontend-dev
- **Engineering (plan)**: tech-estimator, tech-estimator-agile
- **Content**: doc-writer, doc-writer-official-sources, doc-writer-junior, ops-procedures, content-auditor, content-auditor-seo, clickbait-writer, copywriter-deep, copywriter-marketing
- **Design**: web-designer, web-with-eng, ux-researcher, ux-researcher-accessibility
- **Business**: presales, presales-research, presales-fintech, market-researcher, trend-analyst, content-strategist
- **Management**: project-manager, project-manager-executive

## Ejemplos de flow entre almas

### Flow NL → código → revisión → documentación (Engineering)

1. **spec-writer** — Entrada: requisitos en lenguaje natural. Salida: especificación técnica.
2. **implementer-claude** (o implementer-ollama / implementer-crewai) — Entrada: spec. Salida: código.
3. **reviewer** o **reviewer-correctness** — Entrada: código. Salida: informe de revisión y sugerencias.
4. **documenter** — Entrada: código (y opcionalmente spec). Salida: documentación.

Variante pedagógica: usar `spec-writer-pedagogical` y `reviewer-junior`.

### Flow de auditoría completa (Engineering)

- **audit-orchestrator** (o chain `full-audit`) reparte y agrega hallazgos.
- Especialistas (mismo código/repo como entrada): `v02/security-deep`, `v02/performance-deep`, `architecture-review`, `v02/correctness-deep`. Opcional: `quality-audit`.
- Para dirección: usar `security-executive` en lugar de `v02/security-deep`.

### Flow presales → estimación → propuesta (Business + Engineering)

1. **market-researcher** o **trend-analyst** — Entrada: producto/mercado. Salida: resumen de mercado y tendencias.
2. **presales** (o **presales-fintech** si sector regulado) — Usa ese contexto y genera propuesta; puede delegar estimaciones.
3. **tech-estimator** o **tech-estimator-agile** — Entrada: alcance/requisitos. Salida: estimación (horas, story points). Esa estimación vuelve a presales para la oferta final.

### Flow de contenido: auditoría → copy → revisión (Content)

1. **content-auditor** — Entrada: textos o sitio. Salida: informe de calidad y consistencia.
2. **copywriter-deep** o **copywriter-marketing** — Entrada: brief y recomendaciones. Salida: borrador.
3. **content-auditor-seo** — Entrada: borrador. Salida: criterios SEO y sugerencias (titular, meta, H1–H3, keywords).

### Flow diseño → frontend (Design + Engineering)

1. **web-designer** o **web-with-eng** — Entrada: requisitos y contenido. Salida: criterios de diseño y maquetas.
2. **ux-researcher** o **ux-researcher-accessibility** — Entrada: prototipo o flujos. Salida: hallazgos de usabilidad y accesibilidad.
3. **frontend-dev** — Entrada: diseño y hallazgos. Salida: implementación frontend.

### Flow de planificación de proyecto (Management)

- **project-manager** (adaptador `agile` o `waterfall` al invocar) — Entrada: objetivos y restricciones. Salida: plan, hitos, backlog.
- **project-manager-executive** — Misma entrada; salida: resumen ejecutivo y métricas para dirección.

### Uso con chains existentes

Las chains (`nl-to-code`, `full-audit`, `idea-to-project`) encadenan roles. Para usar almas en esos flujos:

- **nl-to-code**: Invocar en secuencia `spec-writer` → `implementer-claude` (o `implementer-ollama`) → `reviewer` con el mismo adaptador (ej. `ADAPTER=python`).
- **full-audit**: Invocar `audit-orchestrator` y luego, por cada sub-auditoría, `v02/security-deep`, `v02/performance-deep`, `architecture-review`, `v02/correctness-deep` con el mismo adaptador.
