import SwiftUI

struct ContentView: View {
    // Tracks first-launch disclaimer state.
    @AppStorage("hasAcceptedDisclaimer") private var hasAcceptedDisclaimer = false

    var body: some View {
        Group {
            if hasAcceptedDisclaimer {
                MainTabView()
            } else {
                DisclaimerView {
                    hasAcceptedDisclaimer = true
                }
            }
        }
    }
}

struct MainTabView: View {
    var body: some View {
        TabView {
            FartBoardView()
                .tabItem {
                    Label("Board", systemImage: "square.grid.2x2.fill")
                }

            FavoritesView()
                .tabItem {
                    Label("Favorites", systemImage: "star.fill")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape.fill")
                }
        }
    }
}

#Preview {
    ContentView()
}
