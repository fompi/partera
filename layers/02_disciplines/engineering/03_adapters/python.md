---
id: engineering.adapter.python
type: adapter
discipline: engineering
name: "Adaptador Python"
version: 1.0.0
description: "Convenciones, anti-patterns y tooling idiomático para Python"
tags: [python, adapter, engineering, idioms]
sfia_category: "Programming/software development"
estimated_tokens: 420
migrated_from: "lang/python.md"
---

# Adaptador Idiomático: Python

## Detección de contexto

Antes de analizar, identifica y declara:

- **Versión objetivo** de Python (buscar en `pyproject.toml`, `setup.cfg`, `Dockerfile`, `.python-version`, CI config).
- **Framework principal**: Django, FastAPI, Flask, CLI puro, librería, script autónomo.
- **Gestor de dependencias**: pip, poetry, pdm, uv, conda.
- **Modo de typing**: gradual, strict, ninguno (revisar `mypy.ini`, `pyproject.toml [tool.mypy]`, `py.typed`).

Si no puedes determinarlo, declara supuestos y continúa.

## Convenciones del lenguaje

Evalúa conformidad con:

- **PEP 8** (estilo), **PEP 257** (docstrings), **PEP 484/526** (type hints), **PEP 585** (generics nativos, 3.9+), **PEP 695** (type params, 3.12+).
- Idioms pythónicos: comprensiones vs loops explícitos, context managers (`with`), `pathlib` vs `os.path`, `dataclasses`/`NamedTuple`/`TypedDict` según el caso.
- Manejo de errores: excepciones específicas, nunca bare `except:`, `raise from` para preservar tracebacks.

## Anti-patterns específicos

Busca activamente:

- `except:` o `except Exception:` sin re-raise ni logging.
- Argumentos mutables por defecto (`def f(x=[])`).
- Late binding en closures dentro de loops.
- `import *` fuera de `__init__.py`.
- `type()` para comprobación de tipos en vez de `isinstance`.
- `==` para comparar con `None`/`True`/`False` en vez de `is`.
- Strings como enums en vez de `enum.Enum`.
- `os.path` manual cuando `pathlib` es más seguro y legible.

## Rendimiento — tres niveles

Evalúa la performance diferenciando:

1. **Python puro**: algoritmos, estructuras de datos (`dict`/`set` para lookups O(1)), generadores vs listas, `__slots__`, `functools.cache`/`lru_cache`, comprehensions en vez de `map`/`filter`.
2. **Bytecode/intérprete**: reducir attribute lookups en hot loops, evitar dispatch overhead innecesario, localizar variables en funciones internas.
3. **Nativo**: cuándo escalar a NumPy, Numba, Cython, extensiones C/Rust o PyPy. Justificar con trade-offs: portabilidad, complejidad de build, mantenibilidad.

Recuerda: **medir primero** con `cProfile`, `py-spy`, `memray` o `scalene` antes de proponer optimización nativa.

## Seguridad específica

Además del checklist general de seguridad, busca:

- `pickle.load`/`loads` de fuentes no confiables.
- `yaml.load()` sin `Loader=SafeLoader`.
- `eval()`, `exec()`, `compile()` con input externo.
- `subprocess` con `shell=True` o sin sanitizar argumentos.
- `os.system()` (preferir `subprocess.run`).
- Template injection en Jinja2 sin `autoescape=True`.
- SQL construido con f-strings o `%` en vez de queries parametrizadas.
- Revisar `pip audit` / `safety check` para CVEs en dependencias.

## Tooling de referencia

Verifica si el proyecto usa (y recomienda si no):

- **Linting**: ruff (preferido) o flake8/pylint.
- **Typing**: mypy (strict) o pyright.
- **Testing**: pytest + coverage. hypothesis para property-based testing en lógica crítica.
- **Formatting**: ruff format o black.
- **Profiling**: cProfile, py-spy, memray, scalene.
- **Seguridad**: pip audit, safety, bandit.

## Campo extra por hallazgo

Cuando uses la plantilla de hallazgo del archivo base, añade este campo:

- **Compatibilidad Python**: consideraciones por versión objetivo (syntax, stdlib, deprecations).
