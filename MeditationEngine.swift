import Foundation
import AVFoundation

final class MeditationEngine: ObservableObject {
    @Published var isActive = false
    @Published var elapsed: TimeInterval = 0
    @Published var breathPhase: Double = 0

    private var audioEngine: AVAudioEngine?
    private var toneNode: AVAudioSourceNode?
    private var timer: Timer?
    private var startTime: Date?
    private var phase: Double = 0

    private var targetFrequency: Double = 220
    private var targetAmplitude: Double = 0.15
    private var currentFrequency: Double = 220
    private var currentAmplitude: Double = 0.15

    func start() {
        setupAudio()
        startTime = Date()
        isActive = true

        timer = Timer.scheduledTimer(withTimeInterval: 1.0 / 30.0, repeats: true) { [weak self] _ in
            guard let self, let start = self.startTime else { return }
            self.elapsed = Date().timeIntervalSince(start)
            let breathCycle = 8.0
            self.breathPhase = (sin(self.elapsed * 2 * .pi / breathCycle) + 1) / 2
        }
    }

    func stop() {
        timer?.invalidate()
        timer = nil
        audioEngine?.stop()
        audioEngine = nil
        toneNode = nil
        isActive = false
        elapsed = 0
    }

    func updateFromMagneticField(magnitude: Double, fluctuation: Double) {
        let normalized = min(magnitude / 200.0, 1.0)
        targetFrequency = 110 + normalized * 330
        targetAmplitude = 0.05 + fluctuation * 0.15
    }

    private func setupAudio() {
        let engine = AVAudioEngine()
        let mainMixer = engine.mainMixerNode
        let outputFormat = mainMixer.outputFormat(forBus: 0)
        let sampleRate = outputFormat.sampleRate

        let sourceNode = AVAudioSourceNode { [weak self] _, _, frameCount, audioBufferList -> OSStatus in
            guard let self else { return noErr }

            self.currentFrequency += (self.targetFrequency - self.currentFrequency) * 0.01
            self.currentAmplitude += (self.targetAmplitude - self.currentAmplitude) * 0.01

            let ablPointer = UnsafeMutableAudioBufferListPointer(audioBufferList)
            let freq = self.currentFrequency
            let amp = self.currentAmplitude

            for frame in 0..<Int(frameCount) {
                let value = Float(sin(self.phase * 2 * .pi) * amp)

                let harmonicValue = value
                    + Float(sin(self.phase * 4 * .pi) * amp * 0.3)
                    + Float(sin(self.phase * 6 * .pi) * amp * 0.1)

                for buffer in ablPointer {
                    let buf = buffer.mData?.assumingMemoryBound(to: Float.self)
                    buf?[frame] = harmonicValue
                }

                self.phase += freq / sampleRate
                if self.phase > 1 { self.phase -= 1 }
            }

            return noErr
        }

        engine.attach(sourceNode)
        engine.connect(sourceNode, to: mainMixer, format: outputFormat)

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            try engine.start()
            self.audioEngine = engine
            self.toneNode = sourceNode
        } catch {
            print("Meditation audio error: \(error)")
        }
    }

    var elapsedString: String {
        let m = Int(elapsed) / 60
        let s = Int(elapsed) % 60
        return String(format: "%d:%02d", m, s)
    }

    deinit {
        stop()
    }
}
