import UIKit
import AVFoundation

enum CyberHaptics {
    private static var feedbackGenerator: UIImpactFeedbackGenerator = {
        let gen = UIImpactFeedbackGenerator(style: .light)
        gen.prepare()
        return gen
    }()

    static func beadClick() {
        feedbackGenerator.impactOccurred()
        feedbackGenerator.prepare()
        playCyberSound(kind: .bead)
    }

    static func resetPulse() {
        feedbackGenerator.impactOccurred(intensity: 0.85)
        feedbackGenerator.prepare()
        playCyberSound(kind: .reset)
    }

    private enum SoundKind {
        case bead
        case reset
    }

    private static func playCyberSound(kind: SoundKind) {
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let engine = AVAudioEngine()
                let player = AVAudioPlayerNode()
                engine.attach(player)

                let sampleRate: Double = 44100
                let duration: Double = kind == .bead ? 0.095 : 0.18
                let frameCount = AVAudioFrameCount(sampleRate * duration)

                guard let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1),
                      let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else { return }

                buffer.frameLength = frameCount
                guard let data = buffer.floatChannelData?[0] else { return }

                for i in 0..<Int(frameCount) {
                    let t = Double(i) / sampleRate
                    let signal: Double
                    let envelope: Double

                    switch kind {
                    case .bead:
                        let chirp = 1850.0 + 900.0 * exp(-t * 36)
                        let tick = sin(2 * .pi * chirp * t) * 0.45
                        let glass = sin(2 * .pi * 4200.0 * t) * 0.18
                        let sub = sin(2 * .pi * 130.0 * t) * 0.12
                        envelope = exp(-t * 42)
                        signal = (tick + glass + sub) * envelope
                    case .reset:
                        let sweep = 130.0 + 760.0 * min(1.0, t / duration)
                        let core = sin(2 * .pi * sweep * t) * 0.38
                        let shimmer = sin(2 * .pi * 2600.0 * t) * 0.12
                        let attack = min(1.0, t / 0.025)
                        envelope = attack * exp(-t * 7.0)
                        signal = (core + shimmer) * envelope
                    }

                    data[i] = Float(signal * 0.18)
                }

                engine.connect(player, to: engine.mainMixerNode, format: format)
                try engine.start()
                player.play()
                player.scheduleBuffer(buffer, completionHandler: nil)

                Thread.sleep(forTimeInterval: duration + 0.05)
                engine.stop()
            } catch {
                // Audio is a cosmetic layer. Haptics still carry the interaction if playback fails.
            }
        }
    }
}
