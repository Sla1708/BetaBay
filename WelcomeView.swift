import SwiftUI
import WebKit

struct WelcomeView: View {
    let onGetStarted: () -> Void

    @State private var isButtonPressed = false
    @State private var showGetStartedButton = false

    var body: some View {
        GeometryReader { geo in
            ZStack {
                GradientBackground()
                AnimatedIconBackground()

                #if targetEnvironment(simulator) || !targetEnvironment(macCatalyst)
                GifWebView(
                    gifName: "studyzz_hello_text",
                    onLoadingFinished: { /* no-op */ }
                )
                .aspectRatio(400/350, contentMode: .fit)
                .frame(
                    width: min(geo.size.width * 0.9, 400),
                    height: min(geo.size.height * 0.9, 350)
                )
                .allowsHitTesting(false)
                #else
                Text("Studyzz")
                    .font(.system(size: 72, weight: .bold))
                    .foregroundColor(.white)
                    .onAppear { /* no-op */ }
                #endif
            }
            .overlay(bottomOverlay, alignment: .bottom)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
                showGetStartedButton = true
            }
        }
    }

    @ViewBuilder
    private var bottomOverlay: some View {
        if showGetStartedButton {
            HStack {
                Spacer()
                VStack(spacing: 8) {
                    GetStartedButton(isPressed: $isButtonPressed) {
                        onGetStarted()
                    }
                    Text("Get Started")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                }
                Spacer()
            }
            .padding(.bottom, 40)
        }
    }
}