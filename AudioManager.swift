import AVFoundation
import Foundation

final class AudioManager: ObservableObject {
    static let shared = AudioManager()

    private var player: AVAudioPlayer?
    private var scheduledWorkItem: DispatchWorkItem?

    private init() {}

    // Place sound files in Xcode inside: Project Navigator > FartTap > Sounds/
    // Ensure each file has "Target Membership" enabled for your app target.
    // Example placeholder files expected by this app:
    // tiny_pop.mp3, wet_squeak.mp3, thunder_rip.mp3, sneaky_puff.mp3, tuba_blast.mp3,
    // long_creak.mp3, bubble_trouble.mp3, chair_shaker.mp3, silly_squeal.mp3,
    // quick_burst.mp3, echo_fart.mp3, mega_boom.mp3
    func play(soundFileName: String) {
        stop()

        guard let url = Bundle.main.url(forResource: soundFileName, withExtension: nil) else {
            print("⚠️ Missing sound file: \(soundFileName)")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("⚠️ Failed to play \(soundFileName): \(error.localizedDescription)")
        }
    }

    func playRandom(from sounds: [FartSound]) {
        guard let random = sounds.randomElement() else { return }
        play(soundFileName: random.fileName)
    }

    // Schedules a delayed prank playback and returns the selected sound label.
    @discardableResult
    func schedulePrank(after delay: TimeInterval, sounds: [FartSound]) -> String? {
        cancelScheduledPrank()

        guard let random = sounds.randomElement() else { return nil }

        let workItem = DispatchWorkItem { [weak self] in
            self?.play(soundFileName: random.fileName)
        }
        scheduledWorkItem = workItem

        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem)
        return random.name
    }

    func cancelScheduledPrank() {
        scheduledWorkItem?.cancel()
        scheduledWorkItem = nil
    }

    func stop() {
        cancelScheduledPrank()
        player?.stop()
    }
}
