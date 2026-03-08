import SwiftUI

struct SettingsView: View {
    @AppStorage("playOnShake") private var playOnShake = true
    @AppStorage("adsRemoved") private var adsRemoved = false

    var body: some View {
        NavigationStack {
            Form {
                Section("Behavior") {
                    Toggle("Play random fart on shake", isOn: $playOnShake)
                    Text("Shake detection uses CoreMotion and is best tested on a real iPhone.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Section("Monetization") {
                    Button("Remove Ads (Placeholder)") {
                        adsRemoved.toggle()
                    }
                    Text(adsRemoved ? "Ads removed placeholder: ON" : "Ads removed placeholder: OFF")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    HStack {
                        Text("Premium Fart Pack")
                        Spacer()
                        Text("Locked")
                            .foregroundStyle(.secondary)
                    }
                }

                Section("Sound Files") {
                    Text("Add original or licensed sounds to your Xcode project.")
                    Text("Suggested folder: Sounds")
                    Text("Expected file names: tiny_pop.mp3, wet_squeak.mp3, thunder_rip.mp3, sneaky_puff.mp3, tuba_blast.mp3, long_creak.mp3, bubble_trouble.mp3, chair_shaker.mp3, silly_squeal.mp3, quick_burst.mp3, echo_fart.mp3, mega_boom.mp3")
                }
            }
            .navigationTitle("Settings")
        }
    }
}

#Preview {
    SettingsView()
}
