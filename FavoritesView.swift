import SwiftUI

struct FavoritesView: View {
    @StateObject private var audioManager = AudioManager.shared
    @AppStorage("favoriteSoundNames") private var favoriteNamesData: String = ""

    // Keep this list synced with SoundBoardView.
    private let allSounds: [FartSound] = [
        .init(name: "Tiny Pop", fileName: "tiny_pop.mp3", color: .pink),
        .init(name: "Wet Squeak", fileName: "wet_squeak.mp3", color: .mint),
        .init(name: "Thunder Rip", fileName: "thunder_rip.mp3", color: .orange),
        .init(name: "Sneaky Puff", fileName: "sneaky_puff.mp3", color: .teal),
        .init(name: "Tuba Blast", fileName: "tuba_blast.mp3", color: .purple),
        .init(name: "Long Creak", fileName: "long_creak.mp3", color: .indigo),
        .init(name: "Bubble Trouble", fileName: "bubble_trouble.mp3", color: .blue),
        .init(name: "Chair Shaker", fileName: "chair_shaker.mp3", color: .green),
        .init(name: "Silly Squeal", fileName: "silly_squeal.mp3", color: .yellow),
        .init(name: "Quick Burst", fileName: "quick_burst.mp3", color: .red),
        .init(name: "Echo Fart", fileName: "echo_fart.mp3", color: .cyan),
        .init(name: "Mega Boom", fileName: "mega_boom.mp3", color: .brown)
    ]

    private var favoriteNames: Set<String> {
        Set(favoriteNamesData.split(separator: "|").map(String.init))
    }

    private var favoriteSounds: [FartSound] {
        allSounds.filter { favoriteNames.contains($0.name) }
    }

    var body: some View {
        NavigationStack {
            VStack {
                if favoriteSounds.isEmpty {
                    ContentUnavailableView("No Favorites", systemImage: "star", description: Text("Long press any sound button to save favorites."))
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
                }

                BannerAdPlaceholderView()
            }
            .navigationTitle("Favorites")
        }
    }
}

#Preview {
    FavoritesView()
}
