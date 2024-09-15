//
//  WelcomeViewController.swift
//  MySpotify
//
//  Created by Muhammadjon Madaminov on 16/07/24.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    private let button: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.setTitle("Let's get started", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 20

        return button
    }()
    
    
    private let topBlackRectangle: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    
    private let backgroundPhoto: UIImageView = {
        let image = UIImage(named: "spotifyBack")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    
    private let spotifyIcon: UIImageView = {
        let image = UIImage(named: "spotifyIcon")
        let imageView = UIImageView(image: image)
        
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        
        return imageView
    }()
    
    
    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.clear.cgColor, UIColor.csBackgroundColor?.cgColor]
        gradient.locations = [0.0, 0.95]
        return gradient
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.view.backgroundColor = .csBackgroundColor
        
        view.addSubview(button)
        view.addSubview(backgroundPhoto)
        view.addSubview(topBlackRectangle)
        view.addSubview(spotifyIcon)
        
        button.addTarget(self, action: #selector(didTapSignIn), for: .touchUpInside)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        topBlackRectangle.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 55)
        
        backgroundPhoto.frame = CGRect(x: 0,
                                       y: view.top + 35,
                                       width: view.bounds.width,
                                       height: view.bounds.height / 2)
        
        gradientLayer.frame = backgroundPhoto.bounds
        if gradientLayer.superlayer == nil {
            backgroundPhoto.layer.addSublayer(gradientLayer)
        }
        
        spotifyIcon.frame = CGRect(x: 0,
                                   y: Int(backgroundPhoto.bottom) - 20,
                                   width: Int(view.width),
                                   height: 200
        )
        
        
        button.frame = CGRect(x: 20,
                              y: view.height - 150 - view.safeAreaInsets.bottom,
                              width: view.width - 40,
                              height: 55
        )
    }
    
    
    @objc private func didTapSignIn() {
        let vc = AuthViewController()
        vc.completionHandler = { [weak self] success in
            DispatchQueue.main.async {
                self?.handleSignIn(success: success)
            }
        }
        
        vc.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    
    
    private func handleSignIn(success: Bool) {
        guard success else { 
            let alert = UIAlertController(title: "Oops", message: "Something went wrong!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { action in
                let vc = WelcomeViewController()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }))
            present(alert, animated: true)
            return
        }
        let MainVC = TabBarViewController()
        MainVC.modalPresentationStyle = .fullScreen
        present(MainVC, animated: true)
    }
}



public struct WelcomeView: UIViewControllerRepresentable {
    public func makeUIViewController(context: Context) -> some UIViewController {
        return UINavigationController(rootViewController: WelcomeViewController())
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}






import SwiftUI

struct WelcomeViewPreview: View {
    var body: some View {
        WelcomeView()
            .ignoresSafeArea()
        
    }
}


#Preview {
    WelcomeViewPreview()
}

