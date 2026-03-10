import CoreMotion
import Foundation

final class ShakeManager: ObservableObject {
    static let shared = ShakeManager()

    private let motionManager = CMMotionManager()
    private var lastShakeDate: Date = .distantPast

    // Assign this closure from the view that wants shake events.
    var onShakeDetected: (() -> Void)?

    private init() {}

    func startDetection() {
        guard motionManager.isAccelerometerAvailable else {
            print("Accelerometer is unavailable (simulator may not support shake).")
            return
        }

        motionManager.accelerometerUpdateInterval = 0.12
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, _ in
            guard let self, let acceleration = data?.acceleration else { return }

            let strength = sqrt(
                acceleration.x * acceleration.x +
                acceleration.y * acceleration.y +
                acceleration.z * acceleration.z
            )

            let now = Date()
            if strength > 2.3, now.timeIntervalSince(lastShakeDate) > 1.0 {
                lastShakeDate = now
                onShakeDetected?()
            }
        }
    }

    func stopDetection() {
        motionManager.stopAccelerometerUpdates()
    }
}
