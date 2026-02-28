---
id: modifier.audience.technical
type: modifier
category: audience
name: "Audiencia Técnica"
version: 1.0.0
description: "Ajusta output para audiencia con expertise técnico"
tags: [audience, technical, expert]
affects: [tone, depth, terminology]
estimated_tokens: 180
---

# Modifier: Audiencia Técnica

## Instrucciones de ajuste

Este modifier adapta el output para una audiencia con conocimiento técnico avanzado.

**Tono y terminología**:
- Usar terminología técnica precisa sin añadir definiciones ni explicaciones básicas.
- Asumir familiaridad con patrones de diseño, algoritmos, protocolos y herramientas estándar del área.
- Referencias a RFCs, papers académicos, especificaciones oficiales y CVEs son apropiadas.

**Profundidad**:
- Incluir detalles de implementación relevantes (complejidad algorítmica, edge cases de bajo nivel, trade-offs de arquitectura).
- Mostrar razonamiento técnico completo, no solo conclusiones.
- Señalar limitaciones conocidas y matices que un experto esperaría ver.

**Formato**:
- Código, pseudocódigo y diagramas textuales son bienvenidos para ilustrar puntos.
- Los ejemplos deben ser concretos y realistas, no simplificados para pedagogía.
- Omitir secciones de "¿Qué es X?" o "Fundamentos de Y" que ya conoce la audiencia.
