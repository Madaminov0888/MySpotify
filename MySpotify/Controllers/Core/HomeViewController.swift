//
//  ViewController.swift
//  MySpotify
//
//  Created by Muhammadjon Madaminov on 16/07/24.
//

import UIKit


enum SectionSelector {
    case all, music, podcast
}

class HomeViewController: UIViewController {
    
    
    var sectionSelector: SectionSelector = .all {
        didSet {
            self.setNavButtons()
        }
    }
    
    var playlists: [PlaylistModel] = [] {
        didSet {
            
        }
    }
    
    
    private let apiManager = APIManager()
    
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
//        configuration.baseBackgroundColor = .systemGray.withAlphaComponent(0.25)
//        configuration.baseForegroundColor = .white
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
    
    
    //MARK: -Home view
    private let playlistView: UIView = {
        let view = UIView()
        
        return view
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .csBackgroundColor
        self.setUpNavigationBar()
        self.setTasks()
    }
    
    
    private func setNavButtons() {
        allButton.configuration?.baseBackgroundColor = sectionSelector == .all ? .systemGreen : .systemGray.withAlphaComponent(0.25)
        allButton.configuration?.baseForegroundColor = sectionSelector == .all ? .black : .white
        allButton.layer.cornerRadius = 20
        allButton.addTarget(self, action: #selector(allButtonActions), for: .touchUpInside)
        
        musicsButton.configuration?.baseBackgroundColor = sectionSelector == .music ? .systemGreen : .systemGray.withAlphaComponent(0.25)
        musicsButton.configuration?.baseForegroundColor = sectionSelector == .music ? .black : .white
        musicsButton.layer.cornerRadius = 20
        musicsButton.addTarget(self, action: #selector(musicButtonActions), for: .touchUpInside)
        
        podcastsButton.configuration?.baseBackgroundColor = sectionSelector == .podcast ? .systemGreen : .systemGray.withAlphaComponent(0.25)
        podcastsButton.configuration?.baseForegroundColor = sectionSelector == .podcast ? .black : .white
        podcastsButton.layer.cornerRadius = 20
        podcastsButton.addTarget(self, action: #selector(podcastButtonActions), for: .touchUpInside)
    }
    
    
    private func setUpNavigationBar() {
        setNavButtons()
        
        profileButton.addTarget(self, action: #selector(profileButtonAction), for: .touchUpInside)
        
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
    
    @objc private func profileButtonAction() {
        let vc = ProfileViewController()
        vc.navigationItem.largeTitleDisplayMode = .automatic
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func allButtonActions() {
        self.sectionSelector = .all
        self.setNavButtons()
        self.view.layoutIfNeeded()
    }
    
    @objc private func musicButtonActions() {
        self.sectionSelector = .music
        self.setNavButtons()
        self.view.layoutIfNeeded()
    }
    
    @objc private func podcastButtonActions() {
        self.sectionSelector = .podcast
        self.setNavButtons()
        self.view.layoutIfNeeded()
    }
    
    
    //MARK: -TASKS
    func setTasks() {
        Task {
            do {
                let featuredPlaylists = try await apiManager.getUserPlaylists()
                await MainActor.run {
                    self.playlists = featuredPlaylists
                }
            } catch {
                print(error)
            }
        }
    }
    
    
}




//MARK: For preview, you can delete it
public struct DetailsView: UIViewControllerRepresentable {
    public func makeUIViewController(context: Context) -> some UIViewController {
        return UINavigationController(rootViewController: TabBarViewController())
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
