import UIKit
import AVFoundation

enum CyberHaptics {
    private static var feedbackGenerator: UIImpactFeedbackGenerator = {
        let gen = UIImpactFeedbackGenerator(style: .light)
        gen.prepare()
        return gen
    }()

    private static var synthesizer: AVAudioEngine?
    private static var playerNode: AVAudioPlayerNode?

    static func beadClick() {
        feedbackGenerator.impactOccurred()
        feedbackGenerator.prepare()
        playClickSound()
    }

    private static func playClickSound() {
        // Short cyber click using AudioEngine
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let engine = AVAudioEngine()
                let player = AVAudioPlayerNode()
                engine.attach(player)

                let sampleRate: Double = 44100
                let duration: Double = 0.06
                let frameCount = AVAudioFrameCount(sampleRate * duration)

                guard let format = AVAudioFormat(standardFormatWithSampleRate: sampleRate, channels: 1),
                      let buffer = AVAudioPCMBuffer(pcmFormat: format, frameCapacity: frameCount) else { return }

                buffer.frameLength = frameCount
                guard let data = buffer.floatChannelData?[0] else { return }

                // Cyber click: short high-frequency burst with decay
                for i in 0..<Int(frameCount) {
                    let t = Double(i) / sampleRate
                    let envelope = exp(-t * 80) // fast decay
                    let freq1 = 2400.0  // high metallic
                    let freq2 = 3800.0  // shimmer
                    let signal = sin(2 * .pi * freq1 * t) * 0.5 + sin(2 * .pi * freq2 * t) * 0.3
                    data[i] = Float(signal * envelope * 0.15)
                }

                engine.connect(player, to: engine.mainMixerNode, format: format)
                try engine.start()
                player.play()
                player.scheduleBuffer(buffer, completionHandler: nil)

                Thread.sleep(forTimeInterval: duration + 0.05)
                engine.stop()
            } catch {
                // Silent fail
            }
        }
    }
}
