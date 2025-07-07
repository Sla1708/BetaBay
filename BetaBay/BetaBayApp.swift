import SwiftUI

@main
struct BetaBayApp: App {
    // Persistently stores whether the user has finished the entire onboarding flow.
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    // A temporary state to track if the user has passed the Welcome screen.
    @State private var showFeaturesView = false
    
    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                // If onboarding is fully completed, show the main tabbed view.
                BetaBayMainView()
                
            } else if showFeaturesView {
                // The user tapped "Get Started", so show the Features view next.
                BetaBayFeaturesView {
                    // When the Features view is finished, mark onboarding as complete.
                    hasCompletedOnboarding = true
                }
                
            } else {
                // This is the very first screen the user sees.
                BetaBayWelcomeView(onGetStarted: {
                    // When "Get Started" is tapped, update state to show the Features view.
                    showFeaturesView = true
                })
            }
        }
    }
}