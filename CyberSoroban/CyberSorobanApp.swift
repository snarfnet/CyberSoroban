import SwiftUI
import AppTrackingTransparency
import GoogleMobileAds

@main
struct CyberSorobanApp: App {
    @Environment(\.scenePhase) private var scenePhase
    @State private var attRequested = false

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
                .onChange(of: scenePhase) {
                    if scenePhase == .active && !attRequested {
                        attRequested = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                            ATTrackingManager.requestTrackingAuthorization { _ in
                                DispatchQueue.main.async {
                                    GADMobileAds.sharedInstance().start { _ in }
                                }
                            }
                        }
                    }
                }
        }
    }
}
