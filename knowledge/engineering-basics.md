---
id: knowledge.engineering-basics
type: knowledge
name: "Fundamentos de Ingeniería"
version: 1.0.0
description: "Conocimientos básicos de ingeniería para no-ingenieros"
tags: [engineering, fundamentals, cross-discipline]
source_discipline: engineering
applicable_to: [design, content, business, management]
sfia_skills: [PROG, ARCH, TEST]
estimated_tokens: 380
---

# Knowledge Pack: Fundamentos de Ingeniería

## Arquitectura de software

- **Monolito**: toda la lógica en un único proceso deployable. Simple de operar, difícil de escalar partes independientes.
- **Microservicios**: servicios pequeños y autónomos que se comunican por red. Escalables, pero añaden complejidad operativa.
- **Serverless**: funciones que se ejecutan bajo demanda; sin gestión de servidores, con cold-start y límites de ejecución.

## Patrones comunes

| Patrón | Propósito |
|--------|-----------|
| MVC | Separar datos (Model), presentación (View) y lógica de control (Controller) |
| REST | API basada en recursos HTTP con operaciones CRUD (GET/POST/PUT/DELETE) |
| Event-driven | Componentes se comunican mediante eventos asíncronos; desacopla emisor y receptor |
| Repository | Abstrae el acceso a datos detrás de una interfaz, independiente del storage |

## Limitaciones técnicas típicas

- **Latencia de red**: las llamadas entre servicios son órdenes de magnitud más lentas que una llamada local.
- **Consistencia eventual**: en sistemas distribuidos, los datos pueden estar desincronizados temporalmente.
- **Rate limits**: las APIs externas limitan el número de peticiones por unidad de tiempo.
- **Tamaño de payload**: enviar ficheros grandes por HTTP tiene implicaciones de memoria y tiempo.

## Terminología esencial

- **API**: interfaz de programación; contrato que define cómo interactuar con un servicio.
- **Endpoint**: URL específica de una API que realiza una operación concreta.
- **Token / JWT**: credencial compacta para autenticar peticiones sin estado de sesión en servidor.
- **Deploy**: proceso de llevar código desde desarrollo a un entorno en ejecución.
- **CI/CD**: integración y entrega continua; automatiza build, tests y despliegue.
- **Container (Docker)**: unidad portable que empaqueta código + dependencias.

## Consideraciones de performance y seguridad

- Las operaciones de I/O (base de datos, disco, red) son el cuello de botella más habitual.
- Nunca confiar en datos del cliente sin validación y saneamiento en servidor.
- Los secretos (contraseñas, API keys) nunca deben estar en el código fuente.
- Los cambios de esquema de base de datos requieren migraciones controladas.
