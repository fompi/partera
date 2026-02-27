---
id: modifier.industry.healthcare
type: modifier
category: industry
name: "Healthcare"
version: 1.0.0
description: "Contextualiza para industria de salud"
tags: [industry, healthcare, medical, hipaa]
affects: [compliance, privacy, examples]
estimated_tokens: 220
---

# Modifier: Industria Healthcare

## Instrucciones de ajuste

Este modifier contextualiza el output para entornos de salud, dispositivos médicos, telemedicina o health tech.

## Compliance relevante

- **HIPAA** (US): protege la información de salud protegida (PHI). Requiere controles técnicos (cifrado, acceso), administrativos (políticas) y físicos. Breach notification obligatoria en ≤60 días.
- **HITECH**: refuerza HIPAA con sanciones más estrictas y extiende obligaciones a Business Associates.
- **FDA 21 CFR Part 11**: regula registros y firmas electrónicas en sistemas que soportan decisiones clínicas o envíos regulatorios.
- **MDR / IVDR** (Europa): regulación de dispositivos médicos y diagnóstico in vitro; aplica a software como dispositivo médico (SaMD).
- **GDPR + datos de salud**: en Europa, los datos de salud son categoría especial; requieren base legal reforzada y DPO.

## Privacidad de datos médicos

- **PHI** (Protected Health Information): cualquier dato que identifique a un paciente en relación a su salud, tratamiento o pago.
- **De-identificación**: proceso para eliminar los 18 identificadores HIPAA o aplicar el método estadístico; los datos de-identificados no son PHI.
- **Mínimo necesario**: solo acceder a los datos estrictamente necesarios para la función; no acceso amplio por defecto.
- Los logs de acceso a registros médicos deben ser completos y revisables.

## Ejemplos contextuales

Cuando se requieran ejemplos, preferir casos del dominio sanitario:
- EHR/EMR: gestión de historiales, interoperabilidad HL7/FHIR.
- Telemedicina: videoconsulta, prescripción electrónica, seguimiento remoto.
- Diagnóstico: procesamiento de imágenes médicas, apoyo a la decisión clínica.
- Dispositivos: wearables de monitorización, bombas de infusión, marcapasos conectados.

## Consideraciones éticas

- Las decisiones que afectan la salud del paciente requieren **supervisión humana**; los sistemas de apoyo a la decisión no reemplazan al clínico.
- La **trazabilidad** de decisiones automatizadas es fundamental para responsabilidad médica.
- Sesgos en datos de entrenamiento o reglas de negocio pueden generar **disparidades de atención**; validar con diversidad demográfica.
