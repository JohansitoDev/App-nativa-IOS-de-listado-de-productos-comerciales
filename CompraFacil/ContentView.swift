import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: ShoppingStore
    @State private var searchText = ""
    @State private var selectedFilter = "Todos"
    @State private var showingAdd = false
    @State private var editingItem: ShoppingItem?

    private let filters = ["Todos", "Pendientes", "Comprados"]

    private var visibleItems: [ShoppingItem] {
        store.items.filter { item in
            let matchesSearch = searchText.isEmpty || item.name.localizedCaseInsensitiveContains(searchText)
            let matchesFilter = selectedFilter == "Todos"
                || (selectedFilter == "Pendientes" && !item.isPurchased)
                || (selectedFilter == "Comprados" && item.isPurchased)
            return matchesSearch && matchesFilter
        }
    }

    private var groupedItems: [(ProductCategory, [ShoppingItem])] {
        ProductCategory.allCases.compactMap { category in
            let group = visibleItems.filter { $0.category == category }
            return group.isEmpty ? nil : (category, group)
        }
    }

    var body: some View {
        NavigationStack {
            ZStack {
                Color(.systemGroupedBackground).ignoresSafeArea()
                VStack(spacing: 16) {
                    summaryCard
                    searchBar
                    filterPicker
                    if visibleItems.isEmpty {
                        ContentUnavailableView("No hay productos", systemImage: "basket",
                                               description: Text("Agrega productos a tu lista de compra."))
                            .frame(maxHeight: .infinity)
                    } else {
                        List {
                            ForEach(groupedItems, id: \.0) { category, products in
                                Section {
                                    ForEach(products) { item in
                                        ProductRow(item: item) {
                                            store.toggle(item)
                                        }
                                        .contentShape(Rectangle())
                                        .onTapGesture { editingItem = item }
                                        .listRowBackground(Color(.secondarySystemGroupedBackground))
                                    }
                                    .onDelete { offsets in store.delete(at: offsets, from: products) }
                                } header: {
                                    Label(category.rawValue, systemImage: category.symbol)
                                        .font(.subheadline.weight(.semibold))
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                        .listStyle(.insetGrouped)
                        .scrollContentBackground(.hidden)
                    }
                }
                .padding(.top, 8)
            }
            .navigationTitle("Mi compra")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Menu {
                        Button("Eliminar comprados", systemImage: "trash") { store.clearPurchased() }
                        Button("Mostrar todos", systemImage: "line.3.horizontal.decrease") { selectedFilter = "Todos" }
                    } label: { Image(systemName: "ellipsis.circle") }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showingAdd = true } label: {
                        Image(systemName: "plus.circle.fill").font(.title2)
                    }
                    .accessibilityLabel("Agregar producto")
                }
            }
            .sheet(isPresented: $showingAdd) { ProductFormView() }
            .sheet(item: $editingItem) { item in ProductFormView(existingItem: item) }
        }
    }

    private var summaryCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Presupuesto estimado").font(.subheadline).foregroundStyle(.white.opacity(0.8))
                    Text(store.total, format: .currency(code: "DOP"))
                        .font(.system(size: 30, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                }
                Spacer()
                Image(systemName: "cart.fill")
                    .font(.system(size: 30))
                    .foregroundStyle(.white.opacity(0.9))
                    .padding(15)
                    .background(.white.opacity(0.16), in: Circle())
            }
            Rectangle().fill(.white.opacity(0.2)).frame(height: 1)
            HStack {
                Label("\(store.remainingCount) pendientes", systemImage: "circle")
                Spacer()
                Label("\(store.items.count - store.remainingCount) comprados", systemImage: "checkmark.circle.fill")
            }
            .font(.caption.weight(.medium))
            .foregroundStyle(.white.opacity(0.9))
        }
        .padding(18)
        .background(
            LinearGradient(colors: [Color(red: 0.12, green: 0.36, blue: 0.78),
                                    Color(red: 0.08, green: 0.24, blue: 0.56)],
                           startPoint: .topLeading, endPoint: .bottomTrailing),
            in: RoundedRectangle(cornerRadius: 22, style: .continuous)
        )
        .padding(.horizontal)
    }

    private var searchBar: some View {
        HStack(spacing: 10) {
            Image(systemName: "magnifyingglass").foregroundStyle(.secondary)
            TextField("Buscar producto...", text: $searchText)
                .textInputAutocapitalization(.never)
        }
        .padding(12)
        .background(Color(.secondarySystemGroupedBackground), in: RoundedRectangle(cornerRadius: 13))
        .padding(.horizontal)
    }

    private var filterPicker: some View {
        Picker("Filtro", selection: $selectedFilter) {
            ForEach(filters, id: \.self) { Text($0).tag($0) }
        }
        .pickerStyle(.segmented)
        .padding(.horizontal)
    }
}

private struct ProductRow: View {
    let item: ShoppingItem
    let onToggle: () -> Void

    var body: some View {
        HStack(spacing: 12) {
            Button(action: onToggle) {
                Image(systemName: item.isPurchased ? "checkmark.circle.fill" : "circle")
                    .font(.title2)
                    .foregroundStyle(item.isPurchased ? .green : .secondary)
            }
            .buttonStyle(.plain)
            VStack(alignment: .leading, spacing: 4) {
                Text(item.name)
                    .font(.body.weight(.semibold))
                    .strikethrough(item.isPurchased)
                    .foregroundStyle(item.isPurchased ? .secondary : .primary)
                Text("\(item.quantity) × \(item.price, format: .currency(code: "DOP"))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
            Spacer()
            Text(item.subtotal, format: .currency(code: "DOP"))
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(item.isPurchased ? .secondary : .primary)
        }
        .padding(.vertical, 5)
    }
}
