import SwiftUI
import WebKit

struct BetaBayWebView: UIViewRepresentable {
    let urlString: String

    func makeUIView(context: Context) -> WKWebView {
        guard let url = URL(string: self.urlString) else {
            // Return an empty WebView if the URL is invalid
            return WKWebView()
        }
        
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}