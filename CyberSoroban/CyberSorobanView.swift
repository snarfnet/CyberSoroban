import SwiftUI

struct CyberSorobanView: View {
    @ObservedObject var model: SorobanModel
    let frameHeight: CGFloat
    let frameWidth: CGFloat

    private let heavenRatio: CGFloat = 0.25
    private let dividerHeight: CGFloat = 8
    private let contentInset: CGFloat = 16

    private var usableWidth: CGFloat { max(1, frameWidth - contentInset * 2) }
    private var usableHeight: CGFloat { max(1, frameHeight - contentInset * 2) }
    private var colWidth: CGFloat { usableWidth / CGFloat(model.columnCount) }
    private var beadWidth: CGFloat { colWidth * 0.74 }
    private var heavenHeight: CGFloat { usableHeight * heavenRatio }
    private var earthHeight: CGFloat { usableHeight * (1 - heavenRatio) - dividerHeight }
    private var beadHeight: CGFloat { min(earthHeight / 5.6, colWidth * 0.58) }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 26, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: [
                            CyberTheme.panelBlack.opacity(0.96),
                            CyberTheme.voidBlack.opacity(0.92),
                            CyberTheme.panelBlack.opacity(0.86)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .overlay {
                    RoundedRectangle(cornerRadius: 26, style: .continuous)
                        .strokeBorder(CyberTheme.electricCyan.opacity(0.28), lineWidth: 1)
                }
                .shadow(color: CyberTheme.electricCyan.opacity(0.35), radius: 28)
                .shadow(color: CyberTheme.warningOrange.opacity(0.16), radius: 22)

            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .strokeBorder(
                    LinearGradient(
                        colors: [
                            CyberTheme.electricCyan.opacity(0.98),
                            CyberTheme.neonMint.opacity(0.75),
                            CyberTheme.warningOrange.opacity(0.46),
                            CyberTheme.electricCyan.opacity(0.88)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ),
                    lineWidth: 3
                )
                .padding(9)
                .shadow(color: CyberTheme.electricCyan.opacity(0.8), radius: 16)

            VStack {
                terminalRail
                Spacer()
                terminalRail
            }
            .padding(.horizontal, 28)
            .padding(.vertical, 14)
            .allowsHitTesting(false)

            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    ForEach(0..<model.columnCount, id: \.self) { col in
                        heavenColumn(col: col)
                            .frame(width: colWidth, height: heavenHeight)
                    }
                }

                dividerBar

                HStack(spacing: 0) {
                    ForEach(0..<model.columnCount, id: \.self) { col in
                        earthColumn(col: col)
                            .frame(width: colWidth, height: earthHeight)
                    }
                }
            }
            .padding(contentInset)

            HStack(spacing: 0) {
                ForEach(0..<model.columnCount, id: \.self) { col in
                    ZStack {
                        Rectangle()
                            .fill(
                                LinearGradient(
                                    colors: [
                                        CyberTheme.rodBeam.opacity(0.03),
                                        CyberTheme.rodBeam.opacity(0.28),
                                        CyberTheme.rodBeam.opacity(0.03)
                                    ],
                                    startPoint: .top, endPoint: .bottom
                                )
                            )
                            .frame(width: 5)
                            .blur(radius: 1.5)
                        Rectangle()
                            .fill(CyberTheme.rodBeam.opacity(0.48))
                            .frame(width: 1)
                            .shadow(color: CyberTheme.rodBeam.opacity(0.85), radius: 4)
                    }
                    .frame(width: colWidth)
                }
            }
            .padding(contentInset)
            .allowsHitTesting(false)

            HStack(spacing: 0) {
                ForEach(0..<model.columnCount, id: \.self) { col in
                    Text("\(model.columnValue(col))")
                        .font(.system(size: 10, weight: .bold, design: .monospaced))
                        .foregroundColor(CyberTheme.textValue.opacity(model.columnValue(col) > 0 ? 0.9 : 0.2))
                        .frame(width: colWidth)
                }
            }
            .offset(y: -frameHeight / 2 - 12)

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
            .offset(y: heavenHeight - frameHeight / 2 + 2)
        }
        .frame(width: frameWidth, height: frameHeight)
    }

    private var terminalRail: some View {
        HStack(spacing: 7) {
            ForEach(0..<9, id: \.self) { index in
                Capsule()
                    .fill(index == 4 ? CyberTheme.warningOrange.opacity(0.86) : CyberTheme.electricCyan.opacity(0.42))
                    .frame(width: index == 4 ? 46 : 22, height: 3)
                    .shadow(color: index == 4 ? CyberTheme.warningOrange : CyberTheme.electricCyan, radius: 6)
            }
        }
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
                        colors: [
                            CyberTheme.warningOrange.opacity(0.1),
                            CyberTheme.dividerGlow.opacity(0.85),
                            CyberTheme.electricCyan.opacity(0.95),
                            CyberTheme.dividerGlow.opacity(0.85),
                            CyberTheme.warningOrange.opacity(0.1)
                        ],
                        startPoint: .leading, endPoint: .trailing
                    )
                )
                .frame(height: dividerHeight)
            Rectangle()
                .fill(.white.opacity(0.72))
                .frame(height: 1.5)
                .shadow(color: CyberTheme.dividerGlow, radius: 9)
        }
    }
}
