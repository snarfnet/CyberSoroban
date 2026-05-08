import SwiftUI

struct ContentView: View {
    @StateObject private var model = SorobanModel()
    @State private var showValue = true

    var body: some View {
        GeometryReader { geo in
            let isLandscape = geo.size.width > geo.size.height
            let sorobanWidth = isLandscape ? geo.size.width * 0.92 : geo.size.width * 0.95
            let sorobanHeight = isLandscape ? geo.size.height * 0.7 : geo.size.height * 0.55

            ZStack {
                // TRON grid background
                TronGridBackground()

                VStack(spacing: 0) {
                    // Top bar
                    HStack {
                        // Title
                        Text("CYBER SOROBAN")
                            .font(.system(size: 16, weight: .bold, design: .monospaced))
                            .foregroundColor(CyberTheme.gridBlue)
                            .shadow(color: CyberTheme.gridBlue.opacity(0.5), radius: 5)

                        Spacer()

                        // Value display
                        if showValue {
                            valueDisplay
                        }

                        Spacer()

                        // Controls
                        HStack(spacing: 16) {
                            cyberButton(icon: "eye", isActive: showValue) {
                                showValue.toggle()
                            }
                            cyberButton(icon: "arrow.counterclockwise", isActive: false) {
                                model.reset()
                                CyberHaptics.beadClick()
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 8)

                    Spacer()

                    // Soroban
                    CyberSorobanView(
                        model: model,
                        frameHeight: sorobanHeight,
                        frameWidth: sorobanWidth
                    )

                    Spacer()

                    // Ad banner
                    BannerAdView(adUnitID: "ca-app-pub-9404799280370656/PLACEHOLDER")
                        .frame(width: 320, height: 50)
                        .padding(.bottom, 4)
                }
            }
        }
    }

    private var valueDisplay: some View {
        let value = model.totalValue()
        let formatted = formatNumber(value)

        return HStack(spacing: 2) {
            Text("VALUE")
                .font(.system(size: 10, weight: .medium, design: .monospaced))
                .foregroundColor(CyberTheme.textPrimary.opacity(0.5))

            Text(formatted)
                .font(.system(size: 22, weight: .bold, design: .monospaced))
                .foregroundColor(CyberTheme.textValue)
                .shadow(color: CyberTheme.textValue.opacity(0.6), radius: 4)
                .animation(.none, value: value)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.black.opacity(0.5))
                .overlay(
                    RoundedRectangle(cornerRadius: 6)
                        .strokeBorder(CyberTheme.textValue.opacity(0.3), lineWidth: 1)
                )
        )
    }

    private func cyberButton(icon: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(isActive ? CyberTheme.gridBlue : CyberTheme.gridBlue.opacity(0.5))
                .frame(width: 36, height: 36)
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.black.opacity(0.5))
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .strokeBorder(CyberTheme.gridBlue.opacity(isActive ? 0.6 : 0.2), lineWidth: 1)
                        )
                )
                .shadow(color: isActive ? CyberTheme.gridBlue.opacity(0.3) : .clear, radius: 4)
        }
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
