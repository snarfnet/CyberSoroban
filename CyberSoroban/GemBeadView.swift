import SwiftUI

struct GemBeadView: View {
    let color: Color
    let isActive: Bool
    let width: CGFloat
    let height: CGFloat
    @State private var glowPulse: CGFloat = 0.6

    var body: some View {
        ZStack {
            Capsule()
                .fill(color.opacity(isActive ? 0.18 : 0.05))
                .frame(width: width * 1.78, height: height * 0.48)
                .blur(radius: 12)

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

            RoundedRectangle(cornerRadius: height * 0.25)
                .fill(
                    LinearGradient(
                        colors: [
                            .white.opacity(isActive ? 0.34 : 0.10),
                            color.opacity(isActive ? 0.95 : 0.36),
                            color.opacity(isActive ? 0.50 : 0.14),
                            .black.opacity(0.32)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: width, height: height)
                .shadow(color: color.opacity(isActive ? 0.86 : 0.18), radius: isActive ? 13 : 4)

            HStack(spacing: 0) {
                ForEach(0..<5, id: \.self) { index in
                    Rectangle()
                        .fill(
                            LinearGradient(
                                colors: [
                                    .white.opacity(index == 2 ? 0.20 : 0.08),
                                    .clear
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .frame(width: width / 8)
                }
            }
            .frame(width: width * 0.72, height: height * 0.95)
            .clipShape(RoundedRectangle(cornerRadius: height * 0.22))
            .opacity(isActive ? 1 : 0.45)

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

            Capsule()
                .fill(.white.opacity(isActive ? 0.68 * glowPulse : 0.18))
                .frame(width: width * 0.56, height: max(2, height * 0.10))
                .offset(y: -height * 0.22)
                .blur(radius: 0.5)

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

            RoundedRectangle(cornerRadius: height * 0.25)
                .strokeBorder(.white.opacity(isActive ? 0.22 : 0.06), lineWidth: 0.7)
                .frame(width: width * 0.86, height: height * 0.78)
        }
        .onAppear {
            withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                glowPulse = 1.0
            }
        }
    }
}
