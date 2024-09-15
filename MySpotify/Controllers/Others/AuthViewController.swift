//
//  AuthViewController.swift
//  MySpotify
//
//  Created by Muhammadjon Madaminov on 16/07/24.
//

import UIKit
import WebKit

class AuthViewController: UIViewController, WKNavigationDelegate {
    
    private let webView: CustomWKWebView = {
        let preference = WKWebpagePreferences()
        preference.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = preference
        let webView = CustomWKWebView(frame: .zero, configuration: config)
        webView.isOpaque = false
        return webView
    }()
    
    public var completionHandler: ((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        navigationController?.navigationBar.tintColor = .white
        
        self.view.backgroundColor = .csBackgroundColor
        
        webView.navigationDelegate = self
        self.view.addSubview(webView)
        
        guard let url = AuthManager.shared.singInURL else { return }
        webView.load(URLRequest(url: url))
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        guard let url = navigationAction.request.url else {
            decisionHandler(.allow)
            return
        }
        
        // Check if the URL contains the authorization code
        let component = URLComponents(string: url.absoluteString)
        if let code = component?.queryItems?.first(where: { $0.name == "code" })?.value {
            // Exchange the code for a token
            Task {
                let response = await AuthManager.shared.exchangeCodeToken(code: code)
                await MainActor.run {
                    completionHandler?(response)
                    dismiss(animated: true, completion: nil)
                }
            }
            decisionHandler(.cancel) // Stop the navigation
            return
        }
        
        decisionHandler(.allow) // Allow other navigations
    }
}
