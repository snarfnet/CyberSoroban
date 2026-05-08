import SwiftUI

struct TronGridBackground: View {
    @State private var phase: CGFloat = 0

    var body: some View {
        Canvas { context, size in
            // Deep dark background
            context.fill(Path(CGRect(origin: .zero, size: size)),
                        with: .color(CyberTheme.background))

            // Horizontal grid lines
            let hSpacing: CGFloat = 40
            for i in 0...Int(size.height / hSpacing) {
                let y = CGFloat(i) * hSpacing
                var path = Path()
                path.move(to: CGPoint(x: 0, y: y))
                path.addLine(to: CGPoint(x: size.width, y: y))
                context.stroke(path,
                             with: .color(CyberTheme.gridDim.opacity(0.3)),
                             lineWidth: 0.5)
            }

            // Vertical grid lines
            let vSpacing: CGFloat = 40
            for i in 0...Int(size.width / vSpacing) {
                let x = CGFloat(i) * vSpacing
                var path = Path()
                path.move(to: CGPoint(x: x, y: 0))
                path.addLine(to: CGPoint(x: x, y: size.height))
                context.stroke(path,
                             with: .color(CyberTheme.gridDim.opacity(0.3)),
                             lineWidth: 0.5)
            }

            // Glowing horizon line at center
            let centerY = size.height * 0.5
            for offset in stride(from: -3.0, through: 3.0, by: 1.0) {
                var path = Path()
                path.move(to: CGPoint(x: 0, y: centerY + offset))
                path.addLine(to: CGPoint(x: size.width, y: centerY + offset))
                let opacity = 0.15 * (1.0 - abs(offset) / 4.0)
                context.stroke(path,
                             with: .color(CyberTheme.gridBlue.opacity(opacity)),
                             lineWidth: 1)
            }

            // Scanning pulse line
            let pulseY = (phase.truncatingRemainder(dividingBy: 1.0)) * size.height
            for offset in stride(from: -5.0, through: 5.0, by: 1.0) {
                var path = Path()
                path.move(to: CGPoint(x: 0, y: pulseY + offset))
                path.addLine(to: CGPoint(x: size.width, y: pulseY + offset))
                let opacity = 0.2 * (1.0 - abs(offset) / 6.0)
                context.stroke(path,
                             with: .color(CyberTheme.gridBlue.opacity(opacity)),
                             lineWidth: 1)
            }
        }
        .onAppear {
            withAnimation(.linear(duration: 8).repeatForever(autoreverses: false)) {
                phase = 1
            }
        }
        .ignoresSafeArea()
    }
}
