import CoreMotion
import Foundation

final class ShakeManager: ObservableObject {
    static let shared = ShakeManager()

    private let motionManager = CMMotionManager()
    private var lastShakeTime: Date = .distantPast

    // Callback assigned by views to react to shake events.
    var onShakeDetected: (() -> Void)?

    private init() {}

    func startDetection() {
        guard motionManager.isAccelerometerAvailable else {
            print("⚠️ Accelerometer unavailable on this device/simulator")
            return
        }

        motionManager.accelerometerUpdateInterval = 0.1
        motionManager.startAccelerometerUpdates(to: .main) { [weak self] data, _ in
            guard let self, let data else { return }

            let x = data.acceleration.x
            let y = data.acceleration.y
            let z = data.acceleration.z
            let magnitude = sqrt(x * x + y * y + z * z)

            // Simple shake threshold with cooldown to prevent rapid repeats.
            let now = Date()
            if magnitude > 2.3 && now.timeIntervalSince(lastShakeTime) > 1.0 {
                lastShakeTime = now
                onShakeDetected?()
            }
        }
    }

    func stopDetection() {
        motionManager.stopAccelerometerUpdates()
    }
}
