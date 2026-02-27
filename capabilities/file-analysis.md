---
id: capability.file-analysis
type: capability
name: "Análisis de Archivos"
version: 1.0.0
description: "Leer y analizar archivos adjuntos (código, docs, datos)"
tags: [file-analysis, upload, documents, code]
input: "Archivo(s) adjunto(s)"
output: "Análisis del contenido"
native_in: [claude, openai, gemini]
requires_wrapper_in: [ollama]
estimated_tokens: 125
---

# Capability: Análisis de Archivos

## Descripción
Capacidad de leer archivos adjuntos por el usuario.

## Formatos soportados típicamente
- Código: .py, .js, .java, .cpp, etc
- Documentos: .txt, .md, .pdf
- Datos: .json, .csv, .xml, .yaml

## Usos típicos
- Auditoría de código existente
- Análisis de logs
- Revisión de documentación
- Procesamiento de datos

## Implementaciones
- Claude: Nativo (múltiples archivos, PDFs)
- OpenAI: Nativo (via Assistants API o ChatGPT)
- Gemini: Nativo (limitado)
- Ollama: Requiere wrapper para adjuntos
