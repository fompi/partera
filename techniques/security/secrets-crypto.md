---
id: security.secrets-crypto
type: technique
area: security
name: "Análisis de Secretos y Criptografía"
version: 1.0.0
description: "Detección de secretos hardcodeados y evaluación de decisiones criptográficas"
tags: [security, cryptography, secrets, keys, tls, entropy]
input: "Código, configuración y dependencias del sistema"
output: "Lista de secretos expuestos y decisiones criptográficas discutibles con mitigaciones"
applicable_disciplines: [engineering, ai, data]
sfia_skills: [SCTY, HSIN]
estimated_tokens: 260
migrated_from: "01_security/01c_secrets_crypto.md"
---

# Técnica: Análisis de Secretos y Criptografía

## Foco

- Secretos hardcodeados: API keys, contraseñas, tokens en código o configuración
- Algoritmos criptográficos débiles (MD5, SHA1 para firma, DES, RC4, cifrados por defecto débiles)
- Gestión de claves: rotación, almacenamiento, derivación
- Hashing de contraseñas: bcrypt/Argon2/scrypt vs MD5/SHA sin salt
- Configuración TLS: versión mínima, cipher suites, verificación de certificados
- Fuentes de entropía: ¿se usa CSPRNG para tokens, nonces, salts?

## Metodología

1. **Escanear patrones**: buscar en código y config strings que coincidan con claves API, contraseñas, tokens, URLs con credenciales.
2. **Evaluar decisiones cripto**: para cada uso de cifrado, firma o hash, comprobar algoritmo, modo y parámetros.
3. **Revisar gestión de claves**: ¿dónde se almacenan? ¿Cómo se cargan? ¿Rotación posible?
4. **Comprobar entropía**: uso de `random` vs `secrets` (Python), `Math.random` vs `crypto` (JS), etc.

## Resultado esperado

Lista de secretos potencialmente expuestos y decisiones criptográficas discutibles. Indica mitigación (variables de entorno, vault, algoritmo seguro).

Usa la plantilla de hallazgo del archivo base.
