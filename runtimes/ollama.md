---
id: runtime.ollama
type: runtime
category: direct
name: "Ollama (Local LLMs)"
version: 1.0.0
description: "Runtime para modelos locales vía Ollama"
tags: [runtime, ollama, local, open-source]
supports_capabilities: [vision]
supports_tool_calling: false
supports_system_prompt: true
context_window: varies
recommended_models: ["qwen2.5-coder:32b", "llama3.3", "mixtral", "codellama"]
estimated_tokens: 195
---

# Runtime: Ollama

## Características
- System prompt: Sí (campo `system`)
- Tool calling: No (depende del modelo; algunos soportan experimentalmente)
- Vision: Solo modelos multimodales (llava, bakllava)
- Context window: Variable según modelo y cuantización
- Streaming: Sí
- Privacidad: 100% local, sin envío de datos

## Capacidades nativas
- `vision`: Solo con modelos LLaVA o similares (requiere wrapper)

## Limitaciones
- Sin tool calling nativo en la mayoría de modelos
- Sin web-search, code-execution ni file-analysis nativos
- Rendimiento dependiente del hardware local

## Formato de composición
- System prompt en `system` de la API REST local
- Sin tool definitions (ignorar si el prompt las incluye)

## Uso via CLI
```bash
ollama run qwen2.5-coder:32b \
  --system "$(cat composed_prompt.md)" \
  "Analiza este código: $(cat code.py)"
```

## Uso via API REST
```python
import requests

response = requests.post("http://localhost:11434/api/generate", json={
    "model": "qwen2.5-coder:32b",
    "system": composed_prompt,
    "prompt": "Analiza este código: ...",
    "stream": False
})
```

## Recomendaciones para prompts
- Mantener prompts concisos (los modelos locales tienen menos capacidad de seguir instrucciones largas)
- Evitar capabilities que requieran tool calling
- Usar modelos especializados en código (qwen2.5-coder, codellama) para auditorías
