---
id: content.adapter.technical
type: adapter
discipline: content
name: "Técnico"
version: 1.0.0
description: "Adaptador para documentación técnica y tutoriales"
tags: [technical, documentation, tutorial]
estimated_tokens: 290
---

# Adaptador: Técnico

## Contexto de uso

Documentación de software, guías de integración, tutoriales, referencias de API, runbooks, READMEs. El lector quiere resolver un problema concreto lo antes posible; no viene a ser entretenido.

## Convenciones del género

- **Task-oriented writing**: organizar por lo que el usuario quiere hacer, no por cómo está construido el sistema.
- **Progressive disclosure**: conceptos básicos primero; profundidad en secciones avanzadas opcionales.
- **Ejemplos ejecutables**: código que se puede copiar y ejecutar sin modificaciones.
- **Versionado explícito**: indicar siempre la versión del software a la que aplica la documentación.
- **Comandos literales**: usar bloques de código para toda instrucción de terminal o código; nunca en prosa.

## Anti-patrones específicos

- Asumir conocimiento previo sin enlazarlo ("como vimos en la sección anterior").
- Capturas de pantalla como única documentación (no accesibles, se desactualizan rápido).
- Mezclar conceptos con procedimientos en el mismo párrafo.
- Ejemplos que requieren setup no documentado para funcionar.
- "Simplemente haz X" — nunca es tan simple para quien lo necesita documentado.

## Tipos de documentación (Diátaxis)

| Tipo | Propósito | Ejemplo |
|------|-----------|---------|
| Tutorial | Aprender haciendo | "Crea tu primer proyecto en 5 minutos" |
| How-to | Resolver tarea concreta | "Cómo configurar autenticación OAuth" |
| Reference | Consulta técnica precisa | "Referencia de la API REST" |
| Explanation | Entender el porqué | "Arquitectura del sistema de caché" |

Cada tipo tiene estructura y tono distintos; no mezclar.

## Criterios de calidad técnica

- Reproducibilidad: ¿un usuario nuevo puede completar el tutorial sin asistencia?
- Completitud: ¿están todos los prerequisitos explícitos?
- Actualidad: ¿refleja la versión actual del software?
- Accesibilidad: headings jerárquicos, código en bloques, sin jerga sin definir.
