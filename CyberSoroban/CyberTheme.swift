import SwiftUI

enum CyberTheme {
    // TRON-inspired colors
    static let gridBlue = Color(red: 0.0, green: 0.8, blue: 1.0)
    static let gridDim = Color(red: 0.0, green: 0.3, blue: 0.5)
    static let background = Color(red: 0.02, green: 0.02, blue: 0.08)
    static let frameGlow = Color(red: 0.0, green: 0.7, blue: 0.9)
    static let rodBeam = Color(red: 0.3, green: 0.8, blue: 1.0)

    // Gem bead colors
    static let sapphire = Color(red: 0.1, green: 0.3, blue: 1.0)
    static let emerald = Color(red: 0.0, green: 0.9, blue: 0.5)
    static let ruby = Color(red: 1.0, green: 0.1, blue: 0.3)
    static let amethyst = Color(red: 0.6, green: 0.2, blue: 1.0)
    static let topaz = Color(red: 1.0, green: 0.8, blue: 0.0)
    static let diamond = Color(red: 0.8, green: 0.95, blue: 1.0)

    static let gemColors: [Color] = [sapphire, emerald, ruby, amethyst, topaz, diamond]

    // Heaven bead (5-value) color
    static let heavenGem = Color(red: 1.0, green: 0.4, blue: 0.1) // orange crystal

    static let dividerGlow = Color(red: 0.0, green: 1.0, blue: 0.8)

    static let textPrimary = Color(red: 0.7, green: 0.95, blue: 1.0)
    static let textValue = Color(red: 0.0, green: 1.0, blue: 0.7)
}
