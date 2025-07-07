import SwiftUI

struct HelpView: View {
    var body: some View {
        NavigationView {
            BetaBayWebView(urlString: "https://betabay.app/help")
                .navigationTitle("Help & Support")
                .navigationBarTitleDisplayMode(.inline)
        }
    }
}