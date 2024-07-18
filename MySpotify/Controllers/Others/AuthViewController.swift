//
//  AuthViewController.swift
//  MySpotify
//
//  Created by Muhammadjon Madaminov on 16/07/24.
//

import UIKit
import WebKit


class AuthViewController: UIViewController, WKNavigationDelegate {
    
    private let webView: WKWebView = {
        let preference = WKWebpagePreferences()
        preference.allowsContentJavaScript = true
        let config = WKWebViewConfiguration()
        config.defaultWebpagePreferences = preference
        let webView = WKWebView(frame: .zero, configuration: config)
        
        return webView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Sign In"
        self.view.backgroundColor = .systemBackground
        webView.navigationDelegate = self
        self.view.addSubview(webView)
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        webView.frame = view.bounds
    }
}
