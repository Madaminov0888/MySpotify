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
        button.setTitle("Sign up", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 20
        return button
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "MySpotify"
        self.view.backgroundColor = .csBackgroundColor
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    
    @objc private func didTapSignIn() {
        let vc = AuthViewController()
        vc.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
