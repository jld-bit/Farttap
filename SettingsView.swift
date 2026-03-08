import SwiftUI

struct SettingsView: View {
    @AppStorage("playOnShake") private var playOnShake = true
    @AppStorage("adsRemoved") private var adsRemoved = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Behavior") {
                    Toggle("Play random fart on shake", isOn: $playOnShake)
                    Text("Note: Shake uses CoreMotion and works best on a physical iPhone.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Section("Monetization Placeholders") {
                    Button("Remove Ads (Placeholder Purchase)") {
                        adsRemoved = true
                    }
                    Text(adsRemoved ? "Ads marked as removed (placeholder state)." : "Ads currently enabled.")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    HStack {
                        Text("Premium Fart Pack")
                        Spacer()
                        Text("Locked")
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Sound File Setup") {
                    Text("1) Create a folder named Sounds in Xcode.")
                    Text("2) Add your licensed/original files (mp3 or wav).")
                    Text("3) Use these sample names: tiny_pop.mp3, wet_squeak.mp3, thunder_rip.mp3, sneaky_puff.mp3, tuba_blast.mp3, long_creak.mp3, bubble_trouble.mp3, chair_shaker.mp3, silly_squeal.mp3, quick_burst.mp3, echo_fart.mp3, mega_boom.mp3")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
