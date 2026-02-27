# Subtask: Autenticación y Control de Acceso

## Persona

Mismo rol que el padre: **Pentester Senior + Ingeniero de Seguridad Defensiva**. Enfócate exclusivamente en autenticación y control de acceso.

## Foco

- Mecanismos de autenticación (login, logout, recuperación de contraseña)
- Gestión de sesiones (persistencia, invalidez, fijación)
- Comprobaciones de autorización (¿existe check explícito antes de operaciones sensibles?)
- IDOR (Insecure Direct Object Reference): acceso a recursos por ID sin verificar pertenencia
- Escalada de privilegios (usuarios normales → admin, roles cruzados)
- Manejo de tokens (JWT, API keys, refresh tokens: almacenamiento, expiración, revocación)
- Almacenamiento de contraseñas (hashing, salt, algoritmo)

## Metodología

1. **Mapear fronteras de auth**: identificar todos los puntos donde se exige autenticación o autorización.
2. **Verificar cumplimiento en cada frontera**: comprobar que la decisión se aplica realmente antes de ejecutar la lógica sensible.
3. **Buscar rutas alternativas**: endpoints, APIs internas o parámetros que permitan bypass.
4. **Revisar flujos críticos**: ¿qué pasa si el token expira durante una operación? ¿Se valida el ownership del recurso?

## Resultado esperado

Para cada frontera de auth: indica si la comprobación existe, dónde está y si es suficiente. Señala gaps (p.ej. endpoint sin auth, IDOR, sesiones no invalidables).

Usa la plantilla de hallazgo de `_base_audit.md`.
