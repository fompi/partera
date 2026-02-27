#!/usr/bin/env python3
"""Wrapper para análisis de imágenes usando API de visión.

Uso:
    python image_analysis.py <image_path> [analysis_type]

analysis_type: general | ocr | ui-elements | diagram (default: general)

Requiere: pip install anthropic
"""

import sys
import base64
import json
import anthropic


def analyze_image(image_path: str, analysis_type: str = "general") -> dict:
    with open(image_path, "rb") as f:
        image_data = base64.b64encode(f.read()).decode()

    # Detectar media_type por extensión
    ext = image_path.rsplit(".", 1)[-1].lower()
    media_types = {"jpg": "image/jpeg", "jpeg": "image/jpeg", "png": "image/png",
                   "gif": "image/gif", "webp": "image/webp"}
    media_type = media_types.get(ext, "image/png")

    client = anthropic.Anthropic()

    prompts = {
        "general": "Describe this image in detail.",
        "ocr": "Extract all text visible in this image. Return it as plain text.",
        "ui-elements": "List all UI elements visible in this interface (buttons, inputs, labels, etc.).",
        "diagram": "Describe the structure and components of this diagram, including relationships."
    }

    message = client.messages.create(
        model="claude-sonnet-4-6",
        max_tokens=1024,
        messages=[{
            "role": "user",
            "content": [
                {
                    "type": "image",
                    "source": {
                        "type": "base64",
                        "media_type": media_type,
                        "data": image_data
                    }
                },
                {
                    "type": "text",
                    "text": prompts.get(analysis_type, prompts["general"])
                }
            ]
        }]
    )

    return {"analysis": message.content[0].text, "analysis_type": analysis_type}


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print(f"Uso: {sys.argv[0]} <image_path> [analysis_type]", file=sys.stderr)
        print("  analysis_type: general | ocr | ui-elements | diagram", file=sys.stderr)
        sys.exit(1)

    image_path = sys.argv[1]
    analysis_type = sys.argv[2] if len(sys.argv) > 2 else "general"
    result = analyze_image(image_path, analysis_type)
    print(result["analysis"])
