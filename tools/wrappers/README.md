# Tool Wrappers

Implementaciones de referencia para las capabilities declaradas en `capabilities/`.

> **Nota**: Estos wrappers son implementaciones de referencia, no producción-ready.
> Adaptar según necesidades específicas de cada proyecto.

## Instalación

### web_search
```bash
# Opción 1: ddgr (DuckDuckGo CLI)
pip install ddgr

# Opción 2: Tavily API
pip install tavily-python
export TAVILY_API_KEY="tu-api-key"
```

### image_analysis
```bash
pip install anthropic
export ANTHROPIC_API_KEY="tu-api-key"

# Alternativa con OpenAI GPT-4o
pip install openai
```

## Uso

### Web Search
```bash
chmod +x web_search.sh
./web_search.sh "latest Python security vulnerabilities" 5
./web_search.sh "Django 5.0 changelog" 3
```

### Image Analysis
```bash
# Análisis general
python image_analysis.py mockup.png

# OCR (extracción de texto)
python image_analysis.py screenshot.png ocr

# Elementos de UI
python image_analysis.py wireframe.png ui-elements

# Diagrama
python image_analysis.py architecture.png diagram
```

## Schemas asociados

Cada wrapper tiene su schema JSON en `tools/schemas/`:

| Wrapper | Schema |
|---------|--------|
| `web_search.sh` | `tools/schemas/web_search.json` |
| `image_analysis.py` | `tools/schemas/image_analysis.json` |

## Extensión

Para añadir nuevas herramientas:
1. Crear schema JSON en `tools/schemas/`
2. Implementar wrapper en este directorio
3. Documentar en este README
4. Actualizar declaración en `capabilities/`

## Relación con capabilities

Los wrappers implementan las capabilities declaradas en `capabilities/`:
- `capabilities/web-search.md` → `web_search.sh`
- `capabilities/vision.md` → `image_analysis.py`
- `capabilities/code-execution.md` → implementación pendiente (usar sandbox nativo del runtime)
