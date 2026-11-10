import SwiftUI

@main
struct AutoLogApp: App {
    @StateObject private var store = VehicleStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
