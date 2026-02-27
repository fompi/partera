# Archivos Deprecados

Este directorio contiene los archivos de la arquitectura **legacy** de audit-prompts, archivados durante la **Fase 2** de migración.

**No eliminar** — se conservan como referencia y para auditoría del proceso de migración.

---

## Mapa de migración

| Archivo legacy | Migrado a | Tipo |
|---|---|---|
| `_base_audit.md.bak` | `_base.md` (universal) + `disciplines/engineering/_base.md` | base |
| `lang/python.md` | `disciplines/engineering/adapters/python.md` | adapter |
| `lang/bash.md` | `disciplines/engineering/adapters/bash.md` | adapter |
| `00_orchestrator/_index.md` | `disciplines/engineering/roles/audit/00_orchestrator/_index.md` | role |
| `01_security/_index.md` | `disciplines/engineering/roles/audit/01_security/_index.md` | role |
| `01_security/01a_injection_surfaces.md` | `techniques/security/injection-analysis.md` | technique |
| `01_security/01b_auth_access_control.md` | `techniques/security/auth-access-control.md` | technique |
| `01_security/01c_secrets_crypto.md` | `techniques/security/secrets-crypto.md` | technique |
| `01_security/01d_supply_chain.md` | `techniques/security/supply-chain.md` | technique |
| `02_performance/_index.md` | `disciplines/engineering/roles/audit/02_performance/_index.md` | role |
| `02_performance/02a_algorithmic_complexity.md` | `techniques/performance/algorithmic-complexity.md` | technique |
| `02_performance/02b_io_network_concurrency.md` | `techniques/performance/io-network-concurrency.md` | technique |
| `02_performance/02c_memory_resources.md` | `techniques/performance/memory-resources.md` | technique |
| `03_architecture/_index.md` | `disciplines/engineering/roles/audit/03_architecture/_index.md` | role |
| `04_correctness/_index.md` | `disciplines/engineering/roles/audit/04_correctness/_index.md` | role |
| `04_correctness/04a_edge_cases_contracts.md` | `techniques/correctness/edge-cases-contracts.md` | technique |
| `04_correctness/04b_concurrency_state.md` | `techniques/correctness/concurrency-state.md` | technique |
| `04_correctness/04c_error_handling.md` | `techniques/correctness/error-handling.md` | technique |

## Comandos equivalentes

```bash
# Legacy (ya no funciona directamente)
make compose ADAPTER=python ROLE=01_security/_index
bash compose.sh python 01_security/01a_injection_surfaces

# Nuevo (equivalente)
DISC=engineering make compose-legacy ADAPTER=python ROLE=01_security/_index
DISC=engineering bash compose.sh python audit/01_security/_index

# Con técnica como extensión
DISC=engineering EXT="techniques/security/injection-analysis" bash compose.sh python audit/01_security/_index

# Script de ayuda para conversión
./scripts/migrate_compose_cmd.sh "make compose ADAPTER=python ROLE=01_security/_index"
```

## Fecha de archivo

Fase 2 — 2026-02-27
