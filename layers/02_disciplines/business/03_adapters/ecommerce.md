---
id: business.adapter.ecommerce
type: adapter
discipline: business
name: "E-commerce"
version: 1.0.0
description: "Adaptador para comercio electrónico y retail online"
tags: [ecommerce, retail, marketplace]
estimated_tokens: 330
---

# Adaptador: E-commerce

## Contexto de uso

Tiendas online, marketplaces, direct-to-consumer (DTC), y retail omnicanal con presencia digital. Cubre tanto modelos propios (marca vende directamente) como marketplace (plataforma agrega vendedores).

## Métricas e-commerce críticas

| Métrica | Descripción | Referencia |
| --------- | ------------- | ------------ |
| Conversion Rate | % visitantes que compran | 2-4% promedio sector |
| AOV | Valor medio del pedido | Benchmark varía por vertical |
| ROAS | Retorno sobre inversión publicitaria | > 4x como objetivo general |
| Cart Abandonment | % usuarios que abandonan antes de pagar | ~70% promedio; reducible con remarketing |
| COGS | Coste de bienes vendidos | Determina el margen bruto máximo |
| Repeat Purchase Rate | % clientes que vuelven | > 30% indica loyalty |
| Fulfillment Cost per Order | Coste de pick, pack, ship | Debe estar en el modelo financiero |

## Dinámicas específicas del modelo

- **Estacionalidad**: el e-commerce tiene picos muy marcados (Black Friday, navidades, vuelta al cole). El modelo financiero debe contemplarlos.
- **Gestión de inventario**: el sobrestock tiene coste de capital; el substock tiene coste de oportunidad y pérdida de clientes.
- **Logística como diferenciador**: velocidad y fiabilidad de entrega son factores de conversión y retención.
- **Devoluciones**: en moda/calzado las tasas son > 30%; el modelo debe absorberlas.

## Anti-patrones en e-commerce

- UX de checkout con demasiados pasos o campos (cada paso adicional baja la conversión).
- Costes de envío revelados solo al final del checkout (mayor causa de abandono de carrito).
- Sin guest checkout (obligar a registrarse antes de comprar pierde ventas).
- Ficha de producto sin información suficiente para decidir (imágenes, tallas, materiales, reviews).
- Ignorar el SEO orgánico como canal de adquisición.

## Modelos de negocio e-commerce

- **Propio**: la marca controla precio, experiencia y margen. Mayor inversión, mayor control.
- **Marketplace seller**: vender en Amazon, Etsy, etc. Menor inversión, menor margen, dependencia de la plataforma.
- **Dropshipping**: sin inventario propio; márgenes bajos, alta competencia.
- **D2C (Direct-to-Consumer)**: marca que antes vendía a través de retailers ahora vende directamente. Mayor margen, relación directa con el cliente.
- **Suscripción**: pedidos recurrentes (replenishment). Predecibilidad de ingresos; churn es la métrica clave.
