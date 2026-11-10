# CompraFácil — SwiftUI

Aplicación nativa de lista de compras para iPhone, desarrollada con **Swift + SwiftUI**, sin dependencias externas.

## Funciones
- Crear y editar productos comerciales.
- Categorías: frutas y verduras, lácteos, carnes, bebidas, limpieza, despensa y cuidado personal.
- Cantidad y precio unitario en pesos dominicanos (DOP).
- Cálculo automático de subtotal y presupuesto estimado.
- Marcar productos como comprados.
- Buscar y filtrar productos.
- Eliminar productos deslizando la fila o limpiar los comprados.
- Guardado local automático con `UserDefaults`.

## Abrir en Xcode
1. Descomprime `CompraFacilSwift.zip`.
2. Abre `CompraFacil.xcodeproj` en Xcode (macOS).
3. Selecciona un simulador de iPhone o conecta tu iPhone.
4. En **Signing & Capabilities**, selecciona tu equipo de desarrollo.
5. Ejecuta con `⌘R`.

**Requisitos:** Xcode 15 o superior, iOS 17 o superior.

## Estructura
- `CompraFacilApp.swift`: punto de entrada.
- `ContentView.swift`: pantalla principal y lista.
- `ProductFormView.swift`: formulario para crear/editar.
- `ShoppingItem.swift`: modelo y categorías.
- `ShoppingStore.swift`: estado, cálculos y persistencia local.

Los precios de ejemplo son demostrativos. Puedes reemplazarlos o agregar tus productos reales.
