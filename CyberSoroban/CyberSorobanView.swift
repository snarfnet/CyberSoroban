import SwiftUI

struct CyberSorobanView: View {
    @ObservedObject var model: SorobanModel
    let frameHeight: CGFloat
    let frameWidth: CGFloat

    private let heavenRatio: CGFloat = 0.25
    private let dividerHeight: CGFloat = 4

    private var colWidth: CGFloat { frameWidth / CGFloat(model.columnCount) }
    private var beadWidth: CGFloat { colWidth * 0.78 }
    private var heavenHeight: CGFloat { frameHeight * heavenRatio }
    private var earthHeight: CGFloat { frameHeight * (1 - heavenRatio) - dividerHeight }
    private var beadHeight: CGFloat { min(earthHeight / 5.5, colWidth * 0.55) }

    var body: some View {
        ZStack {
            // Frame outer glow
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(
                    LinearGradient(
                        colors: [CyberTheme.frameGlow.opacity(0.8), CyberTheme.frameGlow.opacity(0.3)],
                        startPoint: .top, endPoint: .bottom
                    ),
                    lineWidth: 2
                )
                .shadow(color: CyberTheme.frameGlow.opacity(0.5), radius: 10)

            // Frame inner fill
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.black.opacity(0.7))

            VStack(spacing: 0) {
                // Heaven section
                HStack(spacing: 0) {
                    ForEach(0..<model.columnCount, id: \.self) { col in
                        heavenColumn(col: col)
                            .frame(width: colWidth, height: heavenHeight)
                    }
                }

                // Divider beam
                dividerBar

                // Earth section
                HStack(spacing: 0) {
                    ForEach(0..<model.columnCount, id: \.self) { col in
                        earthColumn(col: col)
                            .frame(width: colWidth, height: earthHeight)
                    }
                }
            }

            // Rod beams (vertical lines through each column)
            HStack(spacing: 0) {
                ForEach(0..<model.columnCount, id: \.self) { col in
                    ZStack {
                        // Rod glow
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [CyberTheme.rodBeam.opacity(0.05), CyberTheme.rodBeam.opacity(0.15), CyberTheme.rodBeam.opacity(0.05)],
                                    startPoint: .top, endPoint: .bottom
                                )
                            )
                            .frame(width: 3)
                        // Rod core
                        Rectangle()
                            .fill(CyberTheme.rodBeam.opacity(0.3))
                            .frame(width: 1)
                    }
                    .frame(width: colWidth)
                }
            }
            .allowsHitTesting(false)

            // Column value display at top
            HStack(spacing: 0) {
                ForEach(0..<model.columnCount, id: \.self) { col in
                    Text("\(model.columnValue(col))")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundColor(CyberTheme.textValue.opacity(model.columnValue(col) > 0 ? 0.9 : 0.2))
                        .frame(width: colWidth)
                }
            }
            .offset(y: -frameHeight / 2 - 12)

            // Digit place markers
            HStack(spacing: 0) {
                ForEach(0..<model.columnCount, id: \.self) { col in
                    let place = model.columnCount - 1 - col
                    ZStack {
                        if place % 3 == 0 {
                            Circle()
                                .fill(CyberTheme.dividerGlow.opacity(0.5))
                                .frame(width: 4, height: 4)
                        }
                    }
                    .frame(width: colWidth)
                }
            }
            .offset(y: heavenHeight - frameHeight / 2 - 2)
        }
        .frame(width: frameWidth, height: frameHeight)
    }

    private func heavenColumn(col: Int) -> some View {
        let isActive = model.heavenBeads[col] == 1
        let gemColor = CyberTheme.heavenGem

        return ZStack {
            // Bead positioned based on state
            GemBeadView(color: gemColor, isActive: isActive, width: beadWidth, height: beadHeight)
                .offset(y: isActive ? heavenHeight / 2 - beadHeight * 0.7 : -heavenHeight / 2 + beadHeight * 0.7)
                .animation(.spring(response: 0.25, dampingFraction: 0.7), value: isActive)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            model.toggleHeaven(col)
            CyberHaptics.beadClick()
        }
    }

    private func earthColumn(col: Int) -> some View {
        let activeCount = model.earthBeads[col]
        let gemColor = CyberTheme.gemColors[col % CyberTheme.gemColors.count]

        return ZStack {
            ForEach(0..<4, id: \.self) { i in
                let isActive = i < activeCount
                // i=0 is closest to divider (top of earth), i=3 is furthest (bottom)
                let yBase = -earthHeight / 2 + beadHeight * 0.7
                let activeY = yBase + CGFloat(i) * beadHeight * 1.1
                let inactiveY = earthHeight / 2 - beadHeight * 0.7 - CGFloat(3 - i) * beadHeight * 1.1

                GemBeadView(color: gemColor, isActive: isActive, width: beadWidth, height: beadHeight)
                    .offset(y: isActive ? activeY : inactiveY)
                    .animation(.spring(response: 0.25, dampingFraction: 0.7), value: activeCount)
                    .onTapGesture {
                        model.tapEarthBead(col, beadIndex: i)
                        CyberHaptics.beadClick()
                    }
            }
        }
        .contentShape(Rectangle())
    }

    private var dividerBar: some View {
        ZStack {
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [CyberTheme.dividerGlow.opacity(0.1), CyberTheme.dividerGlow.opacity(0.6), CyberTheme.dividerGlow.opacity(0.1)],
                        startPoint: .leading, endPoint: .trailing
                    )
                )
                .frame(height: dividerHeight)
            Rectangle()
                .fill(CyberTheme.dividerGlow.opacity(0.9))
                .frame(height: 1)
                .shadow(color: CyberTheme.dividerGlow, radius: 5)
        }
    }
}
