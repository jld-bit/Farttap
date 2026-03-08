import AVFoundation
import Foundation

final class AudioManager: ObservableObject {
    static let shared = AudioManager()

    private var player: AVAudioPlayer?
    private var scheduledWorkItem: DispatchWorkItem?

    private init() {}

    // Place sound files inside Xcode project (example folder: Sounds).
    // Ensure each file has target membership enabled.
    // Example file names:
    // tiny_pop.mp3, wet_squeak.mp3, thunder_rip.mp3, sneaky_puff.mp3,
    // tuba_blast.mp3, long_creak.mp3, bubble_trouble.mp3, chair_shaker.mp3,
    // silly_squeal.mp3, quick_burst.mp3, echo_fart.mp3, mega_boom.mp3
    func play(soundFileName: String) {
        stopCurrentPlaybackOnly()

        guard let fileURL = Bundle.main.url(forResource: soundFileName, withExtension: nil) else {
            print("Missing sound file: \(soundFileName)")
            return
        }

        do {
            player = try AVAudioPlayer(contentsOf: fileURL)
            player?.prepareToPlay()
            player?.play()
        } catch {
            print("Could not play sound: \(error.localizedDescription)")
        }
    }

    func playRandom(from sounds: [FartSound]) {
        guard let randomSound = sounds.randomElement() else { return }
        play(soundFileName: randomSound.fileName)
    }

    // Timer prank mode.
    @discardableResult
    func schedulePrank(after delay: TimeInterval, sounds: [FartSound]) -> String? {
        cancelScheduledPrank()

        guard let randomSound = sounds.randomElement() else { return nil }
        let workItem = DispatchWorkItem { [weak self] in
            self?.play(soundFileName: randomSound.fileName)
        }

        scheduledWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: workItem)

        return randomSound.name
    }

    func stop() {
        cancelScheduledPrank()
        stopCurrentPlaybackOnly()
    }

    private func cancelScheduledPrank() {
        scheduledWorkItem?.cancel()
        scheduledWorkItem = nil
    }

    private func stopCurrentPlaybackOnly() {
        player?.stop()
        player = nil
    }
}
