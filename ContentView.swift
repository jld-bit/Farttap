import SwiftUI

struct ContentView: View {
    // First-launch flag for showing disclaimer.
    @AppStorage("hasAcceptedDisclaimer") private var hasAcceptedDisclaimer = false

    var body: some View {
        Group {
            if hasAcceptedDisclaimer {
                AppTabsView()
            } else {
                DisclaimerView {
                    hasAcceptedDisclaimer = true
                }
            }
        }
    }
}

struct AppTabsView: View {
    var body: some View {
        TabView {
            SoundBoardView()
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
