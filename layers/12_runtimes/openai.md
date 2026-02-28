---
id: runtime.openai
type: runtime
category: direct
name: "OpenAI (GPT-4, GPT-4o)"
version: 1.0.0
description: "Runtime para modelos GPT vía OpenAI API"
tags: [runtime, openai, gpt, direct]
supports_capabilities: [vision, code-execution, file-analysis]
supports_tool_calling: true
supports_system_prompt: true
context_window: 128000
recommended_models: ["gpt-4o", "gpt-4-turbo", "gpt-4o-mini"]
estimated_tokens: 230
---

# Runtime: OpenAI

## Características

- System prompt: Sí (rol `system` en messages)
- Tool calling: Sí (via function calling)
- Vision: GPT-4o y GPT-4-turbo
- Context window: 128k tokens (GPT-4o)
- Streaming: Sí

## Capacidades nativas

- `vision`: Análisis de imágenes (GPT-4o)
- `code-execution`: Code Interpreter (Assistants API)
- `file-analysis`: Assistants API con file retrieval

## Formato de composición

- System prompt en `messages[0]` con `role: system`
- Tool definitions con `parameters` (JSON Schema)
- Function calling devuelve `tool_calls` en respuesta

## Uso via API

```python
from openai import OpenAI

client = OpenAI(api_key="...")
response = client.chat.completions.create(
    model="gpt-4o",
    messages=[
        {"role": "system", "content": composed_prompt},
        {"role": "user", "content": "..."}
    ],
    tools=[...],  # Si aplica
    max_tokens=4096
)
```

## Diferencias vs Claude

- Tool schema: usa `parameters` en vez de `input_schema`
- System prompt: va en `messages` (no campo separado)
- Streaming: `stream=True` en create()
