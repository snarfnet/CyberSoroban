import SwiftUI

struct ContentView: View {
    @StateObject private var model = SorobanModel()
    @State private var showValue = true
    @State private var hudPulse = false

    var body: some View {
        GeometryReader { geo in
            let isLandscape = geo.size.width > geo.size.height
            let sorobanWidth = isLandscape ? geo.size.width * 0.9 : geo.size.width * 0.94
            let sorobanHeight = isLandscape ? geo.size.height * 0.68 : geo.size.height * 0.54

            ZStack {
                TronGridBackground()

                VStack(spacing: 0) {
                    topHUD
                        .padding(.horizontal, isLandscape ? 26 : 16)
                        .padding(.top, isLandscape ? 10 : 8)

                    Spacer()

                    CyberSorobanView(
                        model: model,
                        frameHeight: sorobanHeight,
                        frameWidth: sorobanWidth
                    )

                    Spacer()

                    BannerAdView(adUnitID: "ca-app-pub-9404799280370656/6346173268")
                        .frame(width: 320, height: 50)
                        .padding(.bottom, 4)
                }
            }
            .onAppear {
                withAnimation(.easeInOut(duration: 1.8).repeatForever(autoreverses: true)) {
                    hudPulse = true
                }
            }
        }
    }

    private var topHUD: some View {
        HStack(spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text("CYBER SOROBAN")
                    .font(.system(size: 17, weight: .black, design: .monospaced))
                    .tracking(1.6)
                    .foregroundColor(CyberTheme.electricCyan)
                    .shadow(color: CyberTheme.electricCyan.opacity(hudPulse ? 0.85 : 0.35), radius: hudPulse ? 10 : 4)

                Text("NEON CALCULATION INTERFACE")
                    .font(.system(size: 8, weight: .semibold, design: .monospaced))
                    .tracking(1.2)
                    .foregroundColor(CyberTheme.textDim)
            }

            Spacer(minLength: 8)

            if showValue {
                valueDisplay
            }

            Spacer(minLength: 8)

            HStack(spacing: 10) {
                cyberButton(icon: showValue ? "eye.fill" : "eye.slash", isActive: showValue) {
                    showValue.toggle()
                    CyberHaptics.beadClick()
                }

                cyberButton(icon: "arrow.counterclockwise", isActive: false) {
                    model.reset()
                    CyberHaptics.resetPulse()
                }
            }
        }
        .padding(12)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(CyberTheme.voidBlack.opacity(0.66))
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(CyberTheme.gridBlue.opacity(0.28), lineWidth: 1)
                HStack {
                    Rectangle()
                        .fill(CyberTheme.electricCyan.opacity(0.78))
                        .frame(width: 58, height: 2)
                        .shadow(color: CyberTheme.electricCyan, radius: 8)
                    Spacer()
                    Rectangle()
                        .fill(CyberTheme.warningOrange.opacity(0.8))
                        .frame(width: 36, height: 2)
                        .shadow(color: CyberTheme.warningOrange, radius: 7)
                }
                .padding(.horizontal, 18)
                .offset(y: 27)
            }
        )
    }

    private var valueDisplay: some View {
        let value = model.totalValue()
        let formatted = formatNumber(value)

        return VStack(alignment: .trailing, spacing: 1) {
            Text("VALUE")
                .font(.system(size: 8, weight: .bold, design: .monospaced))
                .tracking(1.1)
                .foregroundColor(CyberTheme.textDim)

            Text(formatted)
                .font(.system(size: 24, weight: .black, design: .monospaced))
                .foregroundColor(CyberTheme.textValue)
                .minimumScaleFactor(0.42)
                .lineLimit(1)
                .shadow(color: CyberTheme.textValue.opacity(0.86), radius: 8)
                .animation(.none, value: value)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(CyberTheme.panelBlack.opacity(0.84))
                .overlay(
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .strokeBorder(CyberTheme.textValue.opacity(0.36), lineWidth: 1)
                )
        )
    }

    private func cyberButton(icon: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 15, weight: .bold))
                .foregroundColor(isActive ? CyberTheme.electricCyan : CyberTheme.gridBlue.opacity(0.62))
                .frame(width: 40, height: 40)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(CyberTheme.panelBlack.opacity(0.76))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12, style: .continuous)
                                .strokeBorder(CyberTheme.gridBlue.opacity(isActive ? 0.75 : 0.25), lineWidth: 1)
                        )
                )
                .shadow(color: isActive ? CyberTheme.electricCyan.opacity(0.7) : .clear, radius: 8)
        }
        .buttonStyle(.plain)
    }

    private func formatNumber(_ value: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: value)) ?? "0"
    }
}

#Preview {
    ContentView()
        .preferredColorScheme(.dark)
}
