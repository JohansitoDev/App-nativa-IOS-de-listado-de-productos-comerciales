import Foundation
import SwiftUI

@MainActor
final class ShoppingStore: ObservableObject {
    @Published var items: [ShoppingItem] = [] {
        didSet { save() }
    }

    private let storageKey = "compra_facil_items_v1"

    init() {
        load()
        if items.isEmpty {
            items = [
                ShoppingItem(name: "Arroz", quantity: 2, price: 45, category: .pantry),
                ShoppingItem(name: "Leche", quantity: 1, price: 75, category: .dairy),
                ShoppingItem(name: "Huevos", quantity: 1, price: 120, category: .dairy),
                ShoppingItem(name: "Manzanas", quantity: 4, price: 25, category: .fruits),
                ShoppingItem(name: "Agua", quantity: 2, price: 30, category: .drinks)
            ]
        }
    }

    var total: Double { items.reduce(0) { $0 + $1.subtotal } }
    var purchasedTotal: Double { items.filter(\.isPurchased).reduce(0) { $0 + $1.subtotal } }
    var remainingCount: Int { items.filter { !$0.isPurchased }.count }

    func add(_ item: ShoppingItem) { items.insert(item, at: 0) }

    func toggle(_ item: ShoppingItem) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[index].isPurchased.toggle()
    }

    func update(_ item: ShoppingItem) {
        guard let index = items.firstIndex(where: { $0.id == item.id }) else { return }
        items[index] = item
    }

    func delete(at offsets: IndexSet, from filtered: [ShoppingItem]) {
        let ids = offsets.map { filtered[$0].id }
        items.removeAll { ids.contains($0.id) }
    }

    func clearPurchased() { items.removeAll { $0.isPurchased } }

    private func save() {
        guard let data = try? JSONEncoder().encode(items) else { return }
        UserDefaults.standard.set(data, forKey: storageKey)
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([ShoppingItem].self, from: data) else { return }
        items = decoded
    }
}
