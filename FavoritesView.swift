import SwiftUI

struct FavoritesView: View {
    @StateObject private var favoritesManager = FavoritesManager.shared
    @StateObject private var audioManager = AudioManager.shared

    private let allSounds = FartBoardView().sounds

    var favoriteSounds: [FartSound] {
        allSounds.filter { favoritesManager.favorites.contains($0.name) }
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                if favoriteSounds.isEmpty {
                    ContentUnavailableView("No Favorites Yet", systemImage: "star", description: Text("Tap stars on the board to save your top fart sounds."))
                } else {
                    List(favoriteSounds) { sound in
                        HStack {
                            Text(sound.name)
                            Spacer()
                            Button("Play") {
                                audioManager.play(soundFileName: sound.fileName)
                            }
                            .buttonStyle(.borderedProminent)
                        }
                    }
                    .listStyle(.plain)
                }

                BannerAdPlaceholder()
            }
            .navigationTitle("Favorites")
        }
    }
}

#Preview {
    FavoritesView()
}
