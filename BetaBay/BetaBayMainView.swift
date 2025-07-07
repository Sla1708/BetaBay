import SwiftUI
import WebKit

struct BetaBayMainView: View {
    // This state variable will keep track of the selected tab.
    @State private var selectedTab: Tab = .home

    // The Tab enum provides a safe and clear way to reference our different tabs.
    enum Tab {
        case home
        case website
        case privacy
        case help
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            // Each of these is a new view we will create.
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }

            MyAppsView()
                .tabItem {
                    Label("My Apps", systemImage: "app.grid")
                }

            JoinedTestsView()
                .tabItem {
                    Label("Joined Tests", systemImage: "testtube.2")
                }
            
            NotificationsView()
                .tabItem {
                    Label("Notifications", systemImage: "bell.fill")
                }

            HelpView()
                .tabItem {
                    Label("Help", systemImage: "questionmark.circle.fill")
                }
        }
    }
}

struct BetaBayMainView_Previews: PreviewProvider {
    static var previews: some View {
        BetaBayMainView()
    }
}
