import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationView {
            BetaBayWebView(urlString: "https://app.beta-bay.com/")
                .navigationTitle("BetaBay Home")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}