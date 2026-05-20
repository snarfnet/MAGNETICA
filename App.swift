import SwiftUI
import GoogleMobileAds

class MAGNETICAAppDelegate: NSObject, UIApplicationDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        MobileAds.shared.start()
        return true
    }
}

@main
struct MAGNETICAApp: App {
    @UIApplicationDelegateAdaptor(MAGNETICAAppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.dark)
        }
    }
}
