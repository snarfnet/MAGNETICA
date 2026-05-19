import Foundation
import CoreMotion
import Combine

struct MagneticReading {
    let x: Double
    let y: Double
    let z: Double
    let magnitude: Double
    let timestamp: Date

    var normalizedMagnitude: Double {
        min(magnitude / 200.0, 1.0)
    }

    var dominantAxis: String {
        let ax = abs(x), ay = abs(y), az = abs(z)
        if ax >= ay && ax >= az { return "X" }
        if ay >= ax && ay >= az { return "Y" }
        return "Z"
    }

    var auraHue: Double {
        let angle = atan2(y, x)
        return (angle + .pi) / (2 * .pi)
    }
}

final class MagnetometerEngine: ObservableObject {
    @Published var currentReading: MagneticReading?
    @Published var isActive = false
    @Published var readingHistory: [MagneticReading] = []
    @Published var fluctuation: Double = 0
    @Published var peakMagnitude: Double = 0

    private let motionManager = CMMotionManager()
    private let historyLimit = 120
    private var recentMagnitudes: [Double] = []

    var isAvailable: Bool {
        motionManager.isMagnetometerAvailable
    }

    func start() {
        guard motionManager.isMagnetometerAvailable else { return }

        motionManager.magnetometerUpdateInterval = 1.0 / 30.0

        motionManager.startMagnetometerUpdates(to: .main) { [weak self] data, error in
            guard let self, let data else { return }

            let field = data.magneticField
            let mag = sqrt(field.x * field.x + field.y * field.y + field.z * field.z)

            let reading = MagneticReading(
                x: field.x,
                y: field.y,
                z: field.z,
                magnitude: mag,
                timestamp: Date()
            )

            self.currentReading = reading
            self.readingHistory.append(reading)
            if self.readingHistory.count > self.historyLimit {
                self.readingHistory.removeFirst()
            }

            if mag > self.peakMagnitude {
                self.peakMagnitude = mag
            }

            self.recentMagnitudes.append(mag)
            if self.recentMagnitudes.count > 30 {
                self.recentMagnitudes.removeFirst()
            }
            self.updateFluctuation()
        }

        isActive = true
    }

    func stop() {
        motionManager.stopMagnetometerUpdates()
        isActive = false
    }

    func reset() {
        readingHistory.removeAll()
        recentMagnitudes.removeAll()
        peakMagnitude = 0
        fluctuation = 0
    }

    private func updateFluctuation() {
        guard recentMagnitudes.count >= 5 else { fluctuation = 0; return }
        let avg = recentMagnitudes.reduce(0, +) / Double(recentMagnitudes.count)
        let variance = recentMagnitudes.reduce(0.0) { $0 + pow($1 - avg, 2) } / Double(recentMagnitudes.count)
        fluctuation = min(sqrt(variance) / 50.0, 1.0)
    }
}
