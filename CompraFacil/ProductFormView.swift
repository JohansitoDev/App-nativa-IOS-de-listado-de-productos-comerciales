import SwiftUI

struct ProductFormView: View {
    @EnvironmentObject private var store: ShoppingStore
    @Environment(\.dismiss) private var dismiss

    private let existingItem: ShoppingItem?
    @State private var name: String
    @State private var quantity: Int
    @State private var price: String
    @State private var category: ProductCategory

    init(existingItem: ShoppingItem? = nil) {
        self.existingItem = existingItem
        _name = State(initialValue: existingItem?.name ?? "")
        _quantity = State(initialValue: existingItem?.quantity ?? 1)
        _price = State(initialValue: existingItem.map { String($0.price) } ?? "")
        _category = State(initialValue: existingItem?.category ?? .pantry)
    }

    private var parsedPrice: Double { Double(price.replacingOccurrences(of: ",", with: ".")) ?? 0 }
    private var isValid: Bool { !name.trimmingCharacters(in: .whitespaces).isEmpty && parsedPrice >= 0 }

    var body: some View {
        NavigationStack {
            Form {
                Section("Información del producto") {
                    TextField("Ej. Aceite, arroz, jabón...", text: $name)
                    Stepper("Cantidad: \(quantity)", value: $quantity, in: 1...99)
                    HStack {
                        Text("Precio por unidad")
                        Spacer()
                        TextField("0.00", text: $price)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                            .frame(width: 110)
                    }
                    Picker("Categoría", selection: $category) {
                        ForEach(ProductCategory.allCases) { category in
                            Label(category.rawValue, systemImage: category.symbol).tag(category)
                        }
                    }
                }
                Section {
                    HStack {
                        Text("Subtotal")
                        Spacer()
                        Text(Double(quantity) * parsedPrice, format: .currency(code: "DOP"))
                            .fontWeight(.bold)
                    }
                }
            }
            .navigationTitle(existingItem == nil ? "Nuevo producto" : "Editar producto")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Guardar") { save() }.disabled(!isValid)
                }
            }
        }
    }

    private func save() {
        let item = ShoppingItem(id: existingItem?.id ?? UUID(),
                                name: name.trimmingCharacters(in: .whitespaces),
                                quantity: quantity, price: parsedPrice,
                                category: category,
                                isPurchased: existingItem?.isPurchased ?? false)
        if existingItem == nil { store.add(item) } else { store.update(item) }
        dismiss()
    }
}
