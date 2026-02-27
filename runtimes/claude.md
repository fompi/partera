---
id: runtime.claude
type: runtime
category: direct
name: "Claude (Anthropic)"
version: 1.0.0
description: "Runtime para modelos Claude vía API o claude.ai"
tags: [runtime, claude, anthropic, direct]
supports_capabilities: [vision, web-search, code-execution, file-analysis]
supports_tool_calling: true
supports_system_prompt: true
context_window: 200000
recommended_models: ["claude-opus-4-6", "claude-sonnet-4-6", "claude-haiku-4-5"]
estimated_tokens: 220
---

# Runtime: Claude

## Características
- System prompt: Sí (recomendado)
- Tool calling: Sí (via function calling)
- Vision: Nativa en Claude 3+
- Context window: 200k tokens (Claude 3/4)
- Streaming: Sí

## Capacidades nativas
- `vision`: Análisis de imágenes
- `web-search`: Con extensión habilitada
- `code-execution`: Con feature habilitada
- `file-analysis`: Múltiples archivos, PDFs

## Formato de composición
- Incluir system prompt completo
- Tool definitions en formato JSON (Anthropic schema)
- Capabilities nativas no requieren wrapper

## Uso via API
```python
import anthropic

client = anthropic.Anthropic(api_key="...")
response = client.messages.create(
    model="claude-sonnet-4-6",
    system=composed_prompt,
    messages=[{"role": "user", "content": "..."}],
    tools=[...],  # Si aplica
    max_tokens=4096
)
```

## Notas
- El system prompt compuesto va en el campo `system`
- Los tool schemas usan `input_schema` (no `parameters` como OpenAI)
- Streaming disponible con `stream=True`
