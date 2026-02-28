---
id: business.adapter.saas
type: adapter
discipline: business
name: "SaaS"
version: 1.0.0
description: "Adaptador para modelos de negocio SaaS"
tags: [saas, subscription, b2b, b2c]
estimated_tokens: 340
---

# Adaptador: SaaS

## Contexto de uso

Empresas de software como servicio con modelo de suscripción. Aplica tanto a B2B (ventas a empresas) como B2C (ventas a consumidores), aunque las métricas y dinámicas difieren significativamente.

## Métricas SaaS críticas

| Métrica | Descripción | Benchmark típico |
| --------- | ------------- | ------------------ |
| MRR/ARR | Ingresos recurrentes mensuales/anuales | Crecimiento 2-3x YoY (early stage) |
| Churn Rate | % clientes que cancelan por período | < 2% mensual (B2B), < 5% (B2C) |
| Net Revenue Retention | MRR retenido + expansión de clientes existentes | > 100% = crecimiento sin nuevos clientes |
| CAC | Coste de adquirir un cliente | Amortizable en < 12 meses idealmente |
| LTV | Valor total de vida del cliente | LTV/CAC > 3x |
| Activation Rate | % usuarios que alcanzan el "aha moment" | Benchmark varía por producto |
| DAU/MAU | Engagement diario vs mensual | > 20% indica hábito |

## Dinámicas específicas del modelo

- **Compounding growth**: el MRR crece sobre la base existente; pequeñas mejoras en churn tienen impacto exponencial a largo plazo.
- **Expansion revenue**: upselling y cross-selling a clientes existentes es más barato y predecible que adquisición.
- **Product-led growth (PLG)**: el producto es el principal canal de adquisición (freemium, trials).
- **Sales-led growth (SLG)**: equipo comercial conduce la adquisición; apropiado para B2B enterprise.

## Anti-patrones en negocio SaaS

- Optimizar CAC sin considerar LTV (tráfico barato que no convierte o no retiene).
- Ignorar el churn porque el crecimiento bruto lo enmascara.
- Pricing sin alineación al valor entregado (demasiado bajo = infravaloración; demasiado alto = barrera).
- Construir features para el cliente más ruidoso en vez del más representativo.
- Net Revenue Retention < 100% en B2B (significa que los clientes existentes valen cada vez menos).

## Estructura de pricing SaaS

Modelos comunes y cuándo usar cada uno:

- **Per seat**: B2B, valor vinculado al número de usuarios.
- **Usage-based**: valor proporcional al uso (API calls, storage, transacciones).
- **Tiered**: paquetes con conjuntos de features, para segmentar el mercado.
- **Freemium**: capa gratuita como canal de adquisición; requiere clara upgrade path.
