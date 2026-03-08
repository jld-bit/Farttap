import SwiftUI

struct FartSound: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let fileName: String
    let color: Color
}

struct SoundBoardView: View {
    @StateObject private var audioManager = AudioManager.shared
    @StateObject private var shakeManager = ShakeManager.shared

    @AppStorage("favoriteSoundNames") private var favoriteNamesData: String = ""
    @AppStorage("playOnShake") private var playOnShake = true

    @State private var timerStatus = "No timer scheduled"

    private let columns = [GridItem(.flexible()), GridItem(.flexible())]

    // 12 required fart buttons.
    private let sounds: [FartSound] = [
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

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                Text("FartTap")
                    .font(.largeTitle.bold())

                Button {
                    audioManager.playRandom(from: sounds)
                } label: {
                    Label("RANDOM FART", systemImage: "shuffle")
                        .frame(maxWidth: .infinity)
                }
                .boardActionButton(color: .purple)
                .padding(.horizontal)

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(sounds) { sound in
                            soundButton(sound)
                        }
                    }
                    .padding(.horizontal)
                }

                VStack(spacing: 8) {
                    Text("Timer Mode")
                        .font(.headline)

                    HStack(spacing: 10) {
                        timerButton(seconds: 10)
                        timerButton(seconds: 30)
                        timerButton(seconds: 60)
                    }

                    Text(timerStatus)
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }

                Button {
                    audioManager.stop()
                    timerStatus = "Stopped"
                } label: {
                    Text("Stop Sound")
                        .frame(maxWidth: .infinity)
                }
                .boardActionButton(color: .red)
                .padding(.horizontal)

                BannerAdPlaceholderView()
            }
            .padding(.top)
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            shakeManager.onShakeDetected = {
                guard playOnShake else { return }
                audioManager.playRandom(from: sounds)
            }
            shakeManager.startDetection()
        }
        .onDisappear {
            shakeManager.stopDetection()
        }
    }

    @ViewBuilder
    private func soundButton(_ sound: FartSound) -> some View {
        Button {
            audioManager.play(soundFileName: sound.fileName)
        } label: {
            HStack {
                Text(sound.name)
                    .font(.subheadline.bold())
                    .lineLimit(2)
                    .minimumScaleFactor(0.7)
                Spacer()
                Image(systemName: isFavorite(sound) ? "star.fill" : "star")
            }
            .padding(12)
            .frame(maxWidth: .infinity, minHeight: 70)
            .background(sound.color.gradient, in: RoundedRectangle(cornerRadius: 16))
            .foregroundStyle(.white)
        }
        .contextMenu {
            Button(isFavorite(sound) ? "Remove Favorite" : "Add Favorite") {
                toggleFavorite(sound)
            }
        }
        .simultaneousGesture(
            LongPressGesture(minimumDuration: 0.4)
                .onEnded { _ in toggleFavorite(sound) }
        )
    }

    private func timerButton(seconds: Int) -> some View {
        Button("\(seconds)s") {
            let pickedName = audioManager.schedulePrank(after: TimeInterval(seconds), sounds: sounds) ?? "Unknown"
            timerStatus = "Scheduled \(pickedName) in \(seconds)s"
        }
        .boardActionButton(color: .blue)
    }

    private func isFavorite(_ sound: FartSound) -> Bool {
        favoriteNames.contains(sound.name)
    }

    private func toggleFavorite(_ sound: FartSound) {
        var working = favoriteNames
        if working.contains(sound.name) {
            working.remove(sound.name)
        } else {
            working.insert(sound.name)
        }
        favoriteNamesData = working.sorted().joined(separator: "|")
    }
}

private extension View {
    func boardActionButton(color: Color) -> some View {
        self
            .font(.headline)
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(color.opacity(0.9), in: Capsule())
            .foregroundStyle(.white)
    }
}

struct BannerAdPlaceholderView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.gray.opacity(0.2))
            .frame(height: 56)
            .overlay {
                Text("Banner Ad")
                    .font(.caption.bold())
                    .foregroundStyle(.secondary)
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
    }
}

#Preview {
    SoundBoardView()
}
