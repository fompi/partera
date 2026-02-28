---
id: runtime.gemini
type: runtime
category: direct
name: "Google Gemini"
version: 1.0.0
description: "Runtime para modelos Gemini vía Google AI API"
tags: [runtime, gemini, google, direct]
supports_capabilities: [vision, file-analysis]
supports_tool_calling: true
supports_system_prompt: true
context_window: 1000000
recommended_models: ["gemini-2.0-flash", "gemini-1.5-pro", "gemini-1.5-flash"]
estimated_tokens: 210
---

# Runtime: Gemini

## Características

- System prompt: Sí (`system_instruction`)
- Tool calling: Sí (function declarations)
- Vision: Nativa en todos los modelos Gemini
- Context window: 1M tokens (Gemini 1.5 Pro)
- Streaming: Sí

## Capacidades nativas

- `vision`: Análisis de imágenes y video
- `file-analysis`: Documentos, PDFs, audio, video

## Formato de composición

- System prompt en `system_instruction.parts[0].text`
- Tool definitions en `tools[0].function_declarations`
- Formato de schema similar a OpenAI

## Uso via API

```python
import google.generativeai as genai

genai.configure(api_key="...")
model = genai.GenerativeModel(
    model_name="gemini-2.0-flash",
    system_instruction=composed_prompt,
    tools=[...]  # Si aplica
)
response = model.generate_content("...")
```

## Notas

- `system_instruction` es un campo separado del historial
- Soporta multimodal nativo (imagen, video, audio)
- Context window de 1M es ideal para análisis de repositorios completos
