import SwiftUI

class SorobanModel: ObservableObject {
    let columnCount = 13

    // Each column: heavenBead (0=up/inactive, 1=down/active), earthBeads (0-4 active from bottom)
    @Published var heavenBeads: [Int]  // 0 or 1
    @Published var earthBeads: [Int]   // 0...4

    init() {
        heavenBeads = Array(repeating: 0, count: 13)
        earthBeads = Array(repeating: 0, count: 13)
    }

    func toggleHeaven(_ col: Int) {
        heavenBeads[col] = heavenBeads[col] == 0 ? 1 : 0
    }

    func setEarth(_ col: Int, count: Int) {
        earthBeads[col] = min(4, max(0, count))
    }

    func tapEarthBead(_ col: Int, beadIndex: Int) {
        // beadIndex 0 = closest to divider, 3 = furthest
        // If tapping a bead that's already up (active), push it and all above down
        // If tapping a bead that's down (inactive), push it and all below up
        let activeCount = earthBeads[col]
        if beadIndex < activeCount {
            // This bead is active, deactivate it and all above
            earthBeads[col] = beadIndex
        } else {
            // This bead is inactive, activate it and all below
            earthBeads[col] = beadIndex + 1
        }
    }

    func columnValue(_ col: Int) -> Int {
        return heavenBeads[col] * 5 + earthBeads[col]
    }

    func totalValue() -> Int {
        var total = 0
        for col in 0..<columnCount {
            let digitPlace = columnCount - 1 - col
            var multiplier = 1
            for _ in 0..<digitPlace { multiplier *= 10 }
            total += columnValue(col) * multiplier
        }
        return total
    }

    func reset() {
        heavenBeads = Array(repeating: 0, count: columnCount)
        earthBeads = Array(repeating: 0, count: columnCount)
    }
}
