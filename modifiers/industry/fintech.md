---
id: modifier.industry.fintech
type: modifier
category: industry
name: "Fintech"
version: 1.0.0
description: "Contextualiza para industria de servicios financieros"
tags: [industry, fintech, finance, banking]
affects: [compliance, security, examples]
estimated_tokens: 210
---

# Modifier: Industria Fintech

## Instrucciones de ajuste

Este modifier contextualiza el output para entornos de servicios financieros, pagos, banca o inversión.

## Compliance relevante

- **PCI-DSS**: estándar obligatorio para cualquier sistema que procese, almacene o transmita datos de tarjetas de pago. Nivel de compliance según volumen de transacciones.
- **SOX**: aplica a empresas cotizadas en US; requiere controles sobre datos financieros y auditoría de sistemas que los procesan.
- **KYC / AML**: obligaciones regulatorias de verificación de identidad del cliente y detección de lavado de dinero. Impacta el onboarding y monitorización de transacciones.
- **PSD2 / Open Banking**: en Europa, requiere autenticación reforzada (SCA) y APIs abiertas a terceros autorizados.

## Consideraciones de seguridad financiera

- Toda transacción debe ser **idempotente**: reintentos no deben generar cobros duplicados.
- **Segregación de funciones**: quien autoriza pagos no debe ser quien los ejecuta.
- Los **logs de auditoría** de transacciones deben ser inmutables y con timestamp fiable.
- Datos de tarjetas: nunca en logs, nunca en texto plano; tokenización y truncación son obligatorias.

## Ejemplos contextuales

Cuando se requieran ejemplos, preferir casos del dominio financiero:
- Sistemas de pagos: procesamiento de transacciones, reconciliación, chargebacks.
- Fraud detection: reglas de scoring, modelos de comportamiento anómalo.
- Trading: latencia, consistencia de órdenes, circuit breakers.
- Lending: cálculo de riesgos, gestión de covenants, originación de créditos.

## Consideraciones adicionales

- Los sistemas financieros exigen **alta disponibilidad** (típicamente 99.99%+) y **recuperación ante fallos** con cero pérdida de datos.
- Los cambios en producción suelen requerir **aprobación regulatoria** o ventanas de cambio estrictas.
