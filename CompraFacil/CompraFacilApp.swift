import SwiftUI

@main
struct CompraFacilApp: App {
    @StateObject private var store = ShoppingStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
                .tint(Color(red: 0.12, green: 0.36, blue: 0.78))
        }
    }
}
