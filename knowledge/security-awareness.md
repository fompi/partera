---
id: knowledge.security-awareness
type: knowledge
name: "Conciencia de Seguridad"
version: 1.0.0
description: "Principios de seguridad para todos los roles"
tags: [security, awareness, cross-discipline]
source_discipline: engineering
applicable_to: [content, design, business, management]
sfia_skills: [SCTY]
estimated_tokens: 340
---

# Knowledge Pack: Conciencia de Seguridad

## Principios de seguridad (CIA triad)

- **Confidencialidad**: solo las personas autorizadas pueden acceder a la información.
- **Integridad**: la información no puede ser modificada sin autorización; los cambios son detectables.
- **Disponibilidad**: el sistema debe estar accesible para los usuarios legítimos cuando lo necesiten.

Todo control de seguridad existe para proteger uno o más de estos tres principios.

## Amenazas comunes

| Amenaza | Descripción |
|---------|-------------|
| Phishing | Engañar a una persona para que revele credenciales o ejecute malware mediante comunicación falsa |
| MITM | Interceptar la comunicación entre dos partes para espiar o modificar datos en tránsito |
| SQL Injection | Insertar código SQL malicioso en inputs para manipular la base de datos |
| XSS | Inyectar scripts en páginas web que se ejecutan en el navegador de otros usuarios |
| Social engineering | Manipular personas para obtener información o acceso sin necesidad de explotar software |

## Prácticas seguras

- **Contraseñas**: únicas por servicio, largas (≥16 caracteres) y gestionadas con un password manager; nunca reutilizar.
- **2FA / MFA**: segundo factor de autenticación; prefiere apps de autenticación (TOTP) sobre SMS.
- **Backups**: regla 3-2-1: 3 copias, en 2 medios distintos, con 1 copia offsite. Verificar que las copias son restaurables.
- **Principio de mínimo privilegio**: cada persona y sistema debe tener solo los permisos que necesita para su función.
- **Actualizaciones**: aplicar parches de seguridad con prontitud; la mayoría de brechas explotan vulnerabilidades conocidas y parcheadas.

## Compliance básico

- **GDPR**: regulación europea de protección de datos; requiere base legal para procesar datos personales, derecho de acceso y borrado.
- **HIPAA**: regulación US para datos de salud; exige controles técnicos y administrativos estrictos.
- **PCI-DSS**: estándar para procesar tarjetas de pago; aplica si la organización maneja datos de tarjetas.
- **Datos personales**: nombre, email, IP, geolocalización, cookies de identificación y cualquier dato que permita identificar a una persona.

## Incident response básico

1. **Detectar**: identificar que ha ocurrido un incidente (alertas, reportes de usuarios, anomalías).
2. **Contener**: aislar el sistema afectado para evitar propagación.
3. **Erradicar**: eliminar la causa raíz (malware, credenciales comprometidas).
4. **Recuperar**: restaurar el sistema a operación normal desde un estado conocido y limpio.
5. **Documentar**: registrar qué ocurrió, cómo se detectó, impacto y acciones tomadas. Notificar si es requerido por ley.
