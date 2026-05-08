import SwiftUI

struct TronGridBackground: View {
    @State private var phase: CGFloat = 0
    @State private var glowPhase: CGFloat = 0

    var body: some View {
        Canvas { context, size in
            context.fill(Path(CGRect(origin: .zero, size: size)),
                        with: .color(CyberTheme.background))

            let center = CGPoint(x: size.width * 0.5, y: size.height * 0.45)
            let bloomRect = CGRect(x: center.x - size.width * 0.5, y: center.y - size.height * 0.33, width: size.width, height: size.height * 0.66)
            context.fill(
                Path(ellipseIn: bloomRect),
                with: .radialGradient(
                    Gradient(colors: [
                        CyberTheme.gridBlue.opacity(0.18),
                        CyberTheme.magentaPulse.opacity(0.08),
                        .clear
                    ]),
                    center: center,
                    startRadius: 0,
                    endRadius: max(size.width, size.height) * 0.55
                )
            )

            let hSpacing: CGFloat = 38
            for i in 0...Int(size.height / hSpacing) {
                let y = CGFloat(i) * hSpacing
                var path = Path()
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
                context.stroke(path,
                             with: .color(CyberTheme.gridDim.opacity(0.25)),
                             lineWidth: 0.6)
            }

            let vSpacing: CGFloat = 38
            for i in 0...Int(size.width / vSpacing) {
                let x = CGFloat(i) * vSpacing
                var path = Path()
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: size.height))
                context.stroke(path,
                             with: .color(CyberTheme.gridDim.opacity(0.25)),
                             lineWidth: 0.6)
            }

            let centerY = size.height * 0.52
            for offset in stride(from: -5.0, through: 5.0, by: 1.0) {
                var path = Path()
                path.move(to: CGPoint(x: 0, y: centerY + offset))
                path.addLine(to: CGPoint(x: size.width, y: centerY + offset))
                let opacity = 0.22 * (1.0 - abs(offset) / 6.0)
                context.stroke(path,
                             with: .color(CyberTheme.gridBlue.opacity(opacity)),
                             lineWidth: 1)
            }

            let pulseY = (phase.truncatingRemainder(dividingBy: 1.0)) * size.height
            for offset in stride(from: -7.0, through: 7.0, by: 1.0) {
                var path = Path()
                path.move(to: CGPoint(x: 0, y: pulseY + offset))
                path.addLine(to: CGPoint(x: size.width, y: pulseY + offset))
                let opacity = 0.26 * (1.0 - abs(offset) / 8.0)
                context.stroke(path,
                             with: .color(CyberTheme.gridBlue.opacity(opacity)),
                             lineWidth: 1)
            }

            let diagonalOffset = glowPhase * 180
            for i in -8...10 {
                var path = Path()
                let startX = CGFloat(i) * 170 + diagonalOffset
                path.move(to: CGPoint(x: startX, y: -40))
                path.addLine(to: CGPoint(x: startX - size.height * 0.35, y: size.height + 40))
                context.stroke(path, with: .color(CyberTheme.electricCyan.opacity(0.055)), lineWidth: 2)
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
                phase = 1
            }
            withAnimation(.linear(duration: 5).repeatForever(autoreverses: false)) {
                glowPhase = 1
            }
        }
        .ignoresSafeArea()
    }
}
