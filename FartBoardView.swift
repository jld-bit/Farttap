import SwiftUI

struct FartSound: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let fileName: String
    let color: Color
}

struct FartBoardView: View {
    @AppStorage("playOnShake") private var playOnShake = true
    @StateObject private var favoritesManager = FavoritesManager.shared
    @StateObject private var audioManager = AudioManager.shared
    @StateObject private var shakeManager = ShakeManager.shared

    @State private var prankStatus = "No timer scheduled"

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    // Primary fart library (12 required sounds)
    let sounds: [FartSound] = [
        .init(name: "Tiny Pop", fileName: "tiny_pop.mp3", color: .mint),
        .init(name: "Wet Squeak", fileName: "wet_squeak.mp3", color: .cyan),
        .init(name: "Thunder Rip", fileName: "thunder_rip.mp3", color: .purple),
        .init(name: "Sneaky Puff", fileName: "sneaky_puff.mp3", color: .indigo),
        .init(name: "Tuba Blast", fileName: "tuba_blast.mp3", color: .orange),
        .init(name: "Long Creak", fileName: "long_creak.mp3", color: .teal),
        .init(name: "Bubble Trouble", fileName: "bubble_trouble.mp3", color: .pink),
        .init(name: "Chair Shaker", fileName: "chair_shaker.mp3", color: .green),
        .init(name: "Silly Squeal", fileName: "silly_squeal.mp3", color: .yellow),
        .init(name: "Quick Burst", fileName: "quick_burst.mp3", color: .red),
        .init(name: "Echo Fart", fileName: "echo_fart.mp3", color: .blue),
        .init(name: "Mega Boom", fileName: "mega_boom.mp3", color: .brown)
    ]

    var body: some View {
        NavigationStack {
            VStack(spacing: 14) {
                Text("Fart Tap")
                    .font(.largeTitle.bold())

                Text("Tap, prank, and laugh 🎉")
                    .foregroundStyle(.secondary)

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(sounds) { sound in
                            fartButton(for: sound)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 4)
                }

                controls
                prankTimerRow

                Text(prankStatus)
                    .font(.footnote)
                    .foregroundStyle(.secondary)

                LockedPremiumPackCard()

                BannerAdPlaceholder()
            }
            .padding(.top)
            .navigationTitle("Sound Board")
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
    private func fartButton(for sound: FartSound) -> some View {
        Button {
            audioManager.play(soundFileName: sound.fileName)
        } label: {
            HStack {
                Text(sound.name)
                    .font(.headline)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                Spacer()
                Button {
                    favoritesManager.toggle(sound)
                } label: {
                    Image(systemName: favoritesManager.isFavorite(sound) ? "star.fill" : "star")
                        .foregroundStyle(.white)
                }
                .buttonStyle(.plain)
            }
            .padding()
            .frame(maxWidth: .infinity, minHeight: 74)
            .background(sound.color.gradient, in: RoundedRectangle(cornerRadius: 18))
            .foregroundStyle(.white)
        }
        .buttonStyle(.plain)
    }

    private var controls: some View {
        HStack(spacing: 12) {
            Button {
                audioManager.playRandom(from: sounds)
            } label: {
                Label("Random Fart", systemImage: "shuffle")
            }
            .controlButtonStyle(color: .purple)

            Button {
                audioManager.stop()
            } label: {
                Label("Stop", systemImage: "stop.fill")
            }
            .controlButtonStyle(color: .red)
        }
        .padding(.horizontal)
    }

    private var prankTimerRow: some View {
        HStack(spacing: 10) {
            timerButton(seconds: 10)
            timerButton(seconds: 30)
            timerButton(seconds: 60)
        }
        .padding(.horizontal)
    }

    private func timerButton(seconds: Int) -> some View {
        Button("\(seconds)s") {
            let selected = audioManager.schedulePrank(after: TimeInterval(seconds), sounds: sounds) ?? "Unknown"
            prankStatus = "Timer set: \(selected) in \(seconds) sec"
        }
        .controlButtonStyle(color: .blue)
    }
}

private struct LockedPremiumPackCard: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text("Premium Fart Pack")
                    .font(.headline)
                Text("Locked placeholder • Add in-app purchase later")
                    .font(.caption)
            }
            Spacer()
            Image(systemName: "lock.fill")
                .font(.title2)
        }
        .padding()
        .background(Color.gray.opacity(0.2), in: RoundedRectangle(cornerRadius: 16))
        .padding(.horizontal)
    }
}

struct BannerAdPlaceholder: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 12)
            .fill(Color.black.opacity(0.08))
            .frame(height: 52)
            .overlay {
                Text("Banner Ad Placeholder")
                    .font(.caption.bold())
            }
            .padding(.horizontal)
            .padding(.bottom, 8)
    }
}

private extension View {
    func controlButtonStyle(color: Color) -> some View {
        self
            .font(.subheadline.bold())
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .background(color.gradient, in: Capsule())
            .foregroundStyle(.white)
    }
}

#Preview {
    FartBoardView()
}
