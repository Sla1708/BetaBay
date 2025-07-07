import SwiftUI
import WebKit

struct GifWebView: UIViewRepresentable {
    let gifName: String
    let onLoadingFinished: () -> Void

    func makeUIView(context: Context) -> WKWebView {
        let w = WKWebView()
        w.scrollView.isScrollEnabled = false
        w.isOpaque = false
        w.backgroundColor = .clear
        w.configuration.mediaTypesRequiringUserActionForPlayback = []
        w.navigationDelegate = context.coordinator
        return w
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        if let url = Bundle.main.url(forResource: gifName, withExtension: "gif") {
            uiView.load(URLRequest(url: url))
        } else {
            onLoadingFinished()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(onLoadingFinished: onLoadingFinished)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        let onLoadingFinished: () -> Void
        init(onLoadingFinished: @escaping () -> Void) { self.onLoadingFinished = onLoadingFinished }
        func webView(_ w: WKWebView, didFinish nav: WKNavigation!) { onLoadingFinished() }
        func webView(_ w: WKWebView, didFailProvisionalNavigation: WKNavigation!, withError: Error) {
            onLoadingFinished()
        }
    }
}