import Foundation

enum ProductCategory: String, CaseIterable, Codable, Identifiable {
    case fruits = "Frutas y verduras"
    case dairy = "Lácteos"
    case meat = "Carnes"
    case drinks = "Bebidas"
    case cleaning = "Limpieza"
    case pantry = "Despensa"
    case personal = "Cuidado personal"
    case other = "Otros"

    var id: String { rawValue }

    var symbol: String {
        switch self {
        case .fruits: return "carrot.fill"
        case .dairy: return "cup.and.saucer.fill"
        case .meat: return "fork.knife"
        case .drinks: return "waterbottle.fill"
        case .cleaning: return "sparkles"
        case .pantry: return "takeoutbag.and.cup.and.straw.fill"
        case .personal: return "heart.fill"
        case .other: return "basket.fill"
        }
    }
}

struct ShoppingItem: Identifiable, Codable {
    var id = UUID()
    var name: String
    var quantity: Int
    var price: Double
    var category: ProductCategory
    var isPurchased = false

    var subtotal: Double { Double(quantity) * price }
}
