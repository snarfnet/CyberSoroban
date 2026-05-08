import SwiftUI

struct GemBeadView: View {
    let color: Color
    let isActive: Bool
    let width: CGFloat
    let height: CGFloat
    @State private var glowPulse: CGFloat = 0.6

    var body: some View {
        ZStack {
            // Outer glow
            RoundedRectangle(cornerRadius: height * 0.3)
                .fill(
                    RadialGradient(
                        colors: [
                            color.opacity(isActive ? 0.6 : 0.2),
                            color.opacity(0)
                        ],
                        center: .center,
                        startRadius: 0,
                        endRadius: width * 0.8
                    )
                )
                .frame(width: width * 1.4, height: height * 1.4)

            // Main gem body
            RoundedRectangle(cornerRadius: height * 0.25)
                .fill(
                    LinearGradient(
                        colors: [
                            color.opacity(isActive ? 0.9 : 0.4),
                            color.opacity(isActive ? 0.5 : 0.15),
                            color.opacity(isActive ? 0.8 : 0.3)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: width, height: height)

            // Inner facet highlight
            RoundedRectangle(cornerRadius: height * 0.2)
                .fill(
                    LinearGradient(
                        colors: [
                            .white.opacity(isActive ? 0.5 : 0.15),
                            .clear
                        ],
                        startPoint: .topLeading,
                        endPoint: .center
                    )
                )
                .frame(width: width * 0.85, height: height * 0.85)

            // Diamond sparkle at top-left
            Circle()
                .fill(.white.opacity(isActive ? 0.7 * glowPulse : 0.1))
                .frame(width: width * 0.15, height: width * 0.15)
                .offset(x: -width * 0.25, y: -height * 0.2)

            // Bottom reflection
            RoundedRectangle(cornerRadius: height * 0.15)
                .fill(
                    LinearGradient(
                        colors: [.clear, color.opacity(isActive ? 0.3 : 0.05)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: width * 0.6, height: height * 0.3)
                .offset(y: height * 0.2)

            // Edge border glow
            RoundedRectangle(cornerRadius: height * 0.25)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            color.opacity(isActive ? 0.8 : 0.2),
                            .white.opacity(isActive ? 0.3 : 0.05),
                            color.opacity(isActive ? 0.6 : 0.15)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 1.5
                )
                .frame(width: width, height: height)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                glowPulse = 1.0
            }
        }
    }
}
