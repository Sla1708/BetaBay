import SwiftUI

struct GradientBackground: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        LinearGradient(
            colors: colorScheme == .dark
                ? [Color(red: 20/255, green: 43/255, blue: 59/255),
                   Color(red: 12/255, green: 28/255, blue: 44/255)]
                : [Color(red: 0, green: 0.63, blue: 1),
                   Color(red: 0, green: 0.48, blue: 1)],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}