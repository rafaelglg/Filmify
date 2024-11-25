//
//  WebViewWrapper.swift
//  RafaDBPlayer
//
//  Created by Rafael Loggiodice on 24/11/24.
//

import WebKit
import SwiftUI

struct WebViewWrapper: UIViewRepresentable {
    let videoID: String
    @Binding var isLoading: Bool
    
    func makeUIView(context: Context) -> WKWebView {
        
        let configuration = WKWebViewConfiguration()
        configuration.defaultWebpagePreferences.allowsContentJavaScript = true
        configuration.allowsInlineMediaPlayback = false // to maximize after clicking in video
        configuration.mediaTypesRequiringUserActionForPlayback = [.video]
        configuration.websiteDataStore = .nonPersistent()
        
        let webView = WKWebView(frame: .zero, configuration: configuration)
        webView.navigationDelegate = context.coordinator
        webView.uiDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID)") else {
            print("URL inválida")
            return
        }
        
        if uiView.url != youtubeURL {
            uiView.load(URLRequest(url: youtubeURL))
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate, WKUIDelegate {
        var parent: WebViewWrapper
        
        init(_ parent: WebViewWrapper) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isLoading = true
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isLoading = false
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            parent.isLoading = false
        }
        
        // To open external links inside WKWebWiew
        func webView(_ webView: WKWebView, createWebViewWith configuration: WKWebViewConfiguration, for navigationAction: WKNavigationAction, windowFeatures: WKWindowFeatures) -> WKWebView? {
            if let url = navigationAction.request.url {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
            return nil
        }
    }
}
