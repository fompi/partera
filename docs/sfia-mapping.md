# Mapeo SFIA 9

**Propósito**: Trazabilidad entre las piezas del sistema (roles, técnicas, adaptadores) y el [SFIA 9](https://sfia-online.org/en/sfia-9) (Skills Framework for the Information Age). Sirve para alinear competencias profesionales, identificar gaps de cobertura y comunicar qué skills se ejercitan con cada composición.

El framework SFIA define competencias del sector tecnológico y digital en 7 categorías. Este documento mapea las piezas del sistema a los skills SFIA más relevantes.

---

## Categorías SFIA Cubiertas

### Strategy and Architecture

Disciplinas principales: **business**, **management**

| Skill SFIA | Código | Piezas del sistema |
| ---------- | ------ | ------------------ |
| IT Strategy and Planning | ITSP | business/plan/00_presales |
| Solution Architecture | ARCH | engineering/roles/audit/03_architecture |
| Business Analysis | BUAN | business/adapters/saas, business/adapters/ecommerce |
| Strategic Planning | STPL | business/plan/00_presales |

### Solution Development and Implementation

Disciplinas principales: **engineering**, **design**

| Skill SFIA | Código | Piezas del sistema |
| ---------- | ------ | ------------------ |
| Programming/Software Development | PROG | engineering/roles/generate/02_implementer |
| Software Design | SWDN | engineering/roles/generate/00_spec-writer |
| Testing | TEST | engineering/roles/generate/03_reviewer, techniques/correctness/* |
| Database Administration | DBAD | engineering/roles/audit/* (parcial) |
| User Experience Design | HCEV | design/roles/create/00_web-designer |
| Usability Evaluation | USEV | design/roles/create/01_ux-researcher |
| Security Design | SCTY | engineering/roles/audit/01_security, techniques/security/* |

### Delivery and Operation

Disciplinas principales: **management**, **engineering** (ops)

| Skill SFIA | Código | Piezas del sistema |
| ---------- | ------ | ------------------ |
| Project Management | PRMG | management/roles/plan/00_project-manager |
| Delivery Management | DLMG | management/roles/plan/00_project-manager |
| Release and Deployment | RELM | engineering/roles/audit/* (parcial) |
| IT Operations | ITOP | engineering/roles/generate/05_frontend-dev (parcial) |

### Skills and Quality

Disciplinas: todas (cross-cutting)

| Skill SFIA | Código | Piezas del sistema |
| ---------- | ------ | ------------------ |
| Quality Assurance | QUAS | engineering/roles/audit/04_correctness |
| Audit | AUDT | engineering/roles/audit/* |
| Measurement | MEAS | modifiers/depth/deep, chains/full-audit |
| Information Management | IRMG | content/roles/generate/01_doc-writer |

### Relationships and Engagement

Disciplinas principales: **content**, **business**

| Skill SFIA | Código | Piezas del sistema |
| ---------- | ------ | ------------------ |
| Relationship Management | RLMT | business/roles/plan/00_presales |
| Sales Support | SSUP | business/roles/plan/00_presales |
| Marketing | MKTG | content/roles/generate/03_copywriter, content/adapters/marketing |
| Customer/User Support | CFMG | content/roles/generate/02_ops-procedures |

### People and Skills

Disciplinas: **management** (parcial)

| Skill SFIA | Código | Piezas del sistema |
| ---------- | ------ | ------------------ |
| Learning and Development | ETDL | knowledge/* (indirecto) |
| Performance Management | PEMT | management/roles/plan/00_project-manager (parcial) |

### Change and Transformation

Disciplinas: **management**, **business** (parcial)

| Skill SFIA | Código | Piezas del sistema |
| ---------- | ------ | ------------------ |
| Change Management | CHMG | management/adapters/agile, management/adapters/waterfall |
| Business Process Improvement | BPRE | business/roles/plan/00_presales (parcial) |

---

## Tabla Completa: Pieza → SFIA Skills

| ID de Pieza | Tipo | SFIA Skills |
| ----------- | ---- | ----------- |
| engineering.audit.00_orchestrator | role | AUDT, QUAS |
| engineering.audit.01_security | role | SCTY, HSIN, RLMT |
| engineering.audit.02_performance | role | PROG, MEAS |
| engineering.audit.03_architecture | role | ARCH, SWDN |
| engineering.audit.04_correctness | role | TEST, QUAS |
| engineering.generate.00_spec-writer | role | SWDN, BUAN |
| engineering.generate.01_tech-advisor | role | ARCH, ITSP |
| engineering.generate.02_implementer | role | PROG, SWDN |
| engineering.generate.03_reviewer | role | TEST, QUAS |
| engineering.generate.04_documenter | role | IRMG, DOCM |
| engineering.generate.05_frontend-dev | role | PROG, HCEV |
| engineering.plan.00_tech-estimator | role | PRMG, MEAS |
| content.audit.00_content-auditor | role | IRMG, QUAS |
| content.generate.00_clickbait-writer | role | MKTG |
| content.generate.01_doc-writer | role | IRMG, DOCM |
| content.generate.02_ops-procedures | role | IRMG, CFMG |
| content.generate.03_copywriter | role | MKTG, SSUP |
| design.create.00_web-designer | role | HCEV, USEV |
| design.create.01_ux-researcher | role | USEV, HCEV |
| business.plan.00_presales | role | STPL, CFMG, BURM |
| management.plan.00_project-manager | role | PRMG, DLMG, RLMT |
| security.injection-analysis | technique | SCTY, HSIN |
| security.auth-access-control | technique | SCTY |
| security.secrets-crypto | technique | SCTY |
| security.supply-chain | technique | SCTY, RELM |
| performance.algorithmic-complexity | technique | PROG, MEAS |
| performance.io-network-concurrency | technique | PROG |
| performance.memory-resources | technique | PROG |
| correctness.edge-cases-contracts | technique | TEST |
| correctness.error-handling | technique | TEST, PROG |
| correctness.concurrency-state | technique | PROG, TEST |
| maintainability.code-organization | technique | SWDN, PROG |
| maintainability.documentation-standards | technique | IRMG, DOCM |
| maintainability.tech-debt | technique | ARCH, SWDN |
| resilience.failure-modes | technique | TEST, ARCH |
| resilience.graceful-degradation | technique | ARCH |
| resilience.recovery-strategies | technique | ARCH, ITOP |
| scalability.caching-strategies | technique | ARCH, PROG |
| scalability.horizontal-vertical-scaling | technique | ARCH, ITOP |
| scalability.load-distribution | technique | ARCH |
| devex.debugging-observability | technique | PROG, MEAS |
| devex.local-dev-environment | technique | PROG |
| devex.onboarding-friction | technique | ETDL, IRMG |

---

## Gaps Identificados

### Skills SFIA sin cubrir (alta prioridad)

| Skill | Código | Por qué importa | Cómo cubrir |
| ----- | ------ | -------------- | ------------ |
| Data Analytics | DTAN | Análisis cuantitativo de datos | Nueva disciplina `data` |
| Data Visualisation | VISL | Representación visual de información | Nueva disciplina `data` |
| Machine Learning | MLNG | Ingeniería de modelos ML | Nueva disciplina `ai` |
| AI/ML Framework | AISF | Seguridad y ética en IA | Nueva disciplina `ai` |
| IT Operations | ITOP | Operaciones de sistemas | Nuevo rol `engineering/generate/ops-procedures` |
| Asset Management | ITAM | Gestión de infraestructura | Nuevo rol en engineering |
| Learning & Development | ETDL | Formación y onboarding | Nuevos roles en management |

### Skills SFIA sin cubrir (media prioridad)

| Skill | Código | Por qué importa |
| ----- | ------ | --------------- |
| Enterprise and Business Architecture | STPL | Arquitectura empresarial |
| Accessibility | ACCS | Accesibilidad digital (WCAG) |
| Internationalisation | LAIN | i18n/l10n |
| Contract Management | ITCM | Gestión de contratos y SLAs |
| Compliance Management | COPL | Compliance regulatorio (GDPR, HIPAA) |

---

## Cobertura por Categoría SFIA

| Categoría SFIA | Cobertura | Notas |
| -------------- | --------- | ----- |
| Strategy and Architecture | ⚠️ Parcial | Falta arquitectura empresarial, governance |
| Solution Development | ✅ Buena | Engineering y design bien cubiertos |
| Delivery and Operation | ⚠️ Parcial | Falta ops, ITAM, release management |
| Skills and Quality | ✅ Buena | Auditoría y calidad bien cubiertos |
| Relationships and Engagement | ✅ Buena | Content y business la cubren |
| People and Skills | ❌ Escasa | Solo management plan de forma parcial |
| Change and Transformation | ⚠️ Parcial | Agile y waterfall, sin change management explícito |

**Leyenda**: ✅ Buena (>60% de skills clave cubiertos) | ⚠️ Parcial (30-60%) | ❌ Escasa (<30%)

---

## Comparación con O*NET

El framework O*NET (Occupational Information Network) define actividades de trabajo por ocupación. Correspondencia aproximada:

| Categoría O*NET | Elemento del sistema |
| --------------- | -------------------- |
| Information Input | capabilities/, sources/ |
| Mental Processes | patterns/, techniques/ |
| Work Output | role (verb: generate, create) |
| Interacting with Others | protocols/ |
| Working Conditions | adapters/ |

---

## Referencias

- [SFIA 9 Framework](https://sfia-online.org/en/sfia-9)
- [SFIA Skills Browser](https://sfia-online.org/en/sfia-9/all-skills-a-z)
- [O*NET OnLine](https://www.onetonline.org/)
