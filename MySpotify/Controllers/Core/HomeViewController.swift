//
//  ViewController.swift
//  MySpotify
//
//  Created by Muhammadjon Madaminov on 16/07/24.
//

import UIKit

class HomeViewController: UIViewController {
    
    private var profileButton: UIButton = {
        let button = UIButton()
        button.setTitle("M", for: .normal)
        button.backgroundColor = .systemOrange
        button.tintColor = .black
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var allButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.attributedTitle = AttributedString("All", attributes: AttributeContainer([.font: UIFont.preferredFont(forTextStyle: .subheadline)]))
        configuration.baseBackgroundColor = .systemGray.withAlphaComponent(0.25)
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .capsule
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private var musicsButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.attributedTitle = AttributedString("Music", attributes: AttributeContainer([.font: UIFont.preferredFont(forTextStyle: .subheadline)]))
        configuration.baseBackgroundColor = .systemGray.withAlphaComponent(0.25)
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .capsule
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private var podcastsButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.attributedTitle = AttributedString("Podcast", attributes: AttributeContainer([.font: UIFont.preferredFont(forTextStyle: .subheadline)]))
        configuration.baseBackgroundColor = .systemGray.withAlphaComponent(0.25)
        configuration.baseForegroundColor = .white
        configuration.cornerStyle = .capsule
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .csBackgroundColor
        self.setUpNavigationBar()
    }
    
    
    private func setUpNavigationBar() {
        let navProfileButton = UIBarButtonItem(customView: profileButton)
        let navAllButton = UIBarButtonItem(customView: allButton)
        let navMusicButton = UIBarButtonItem(customView: musicsButton)
        let navPodcastButton = UIBarButtonItem(customView: podcastsButton)
        
        self.navigationItem.setLeftBarButtonItems([navProfileButton, navAllButton, navMusicButton, navPodcastButton], animated: true)
        
        NSLayoutConstraint.activate([
            profileButton.widthAnchor.constraint(equalToConstant: 40),
            profileButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
}




//MARK: For preview, you can delete it
public struct DetailsView: UIViewControllerRepresentable {
    public func makeUIViewController(context: Context) -> some UIViewController {
        return TabBarViewController()
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}



import SwiftUI

struct RandomView: View {
    var body: some View {
        DetailsView()
            .ignoresSafeArea()
    }
}


#Preview {
    RandomView()
}
