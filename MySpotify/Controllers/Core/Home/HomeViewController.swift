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
    private var playlistsCollectionVC: PlaylistsCollectionViewController?
    private var featuredPlaylistCollectionVC: FeatPlaylistViewController?
    private var topArtistsCollectionVC: TopArtistsCollectionViewController?
    
    private let apiManager = APIManager()
    
    var sectionSelector: SectionSelector = .all {
        didSet {
            self.setNavButtons()
        }
    }

    
    
    // UI Components
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
        configuration.cornerStyle = .capsule
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var musicsButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.attributedTitle = AttributedString("Music", attributes: AttributeContainer([.font: UIFont.preferredFont(forTextStyle: .subheadline)]))
        configuration.cornerStyle = .capsule
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var podcastsButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.attributedTitle = AttributedString("Podcast", attributes: AttributeContainer([.font: UIFont.preferredFont(forTextStyle: .subheadline)]))
        configuration.cornerStyle = .capsule
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20)
        
        let button = UIButton(configuration: configuration)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let featPlaylistsLabel: UILabel = {
        let label = UILabel()
        label.text = "Recommended Playlists"
        label.font = UIFont.preferredFont(forTextStyle: .title2).withWeight(.bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let topArtistsLabel: UILabel = {
        let label = UILabel()
        label.text = "Favourite Artists"
        label.font = UIFont.preferredFont(forTextStyle: .title2).withWeight(.bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // StackView and ScrollView
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.alwaysBounceVertical = true
        scrollView.isScrollEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        return scrollView
    }()
    
    
    private let stackView = UIStackView()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .csBackgroundColor
        self.playlistsCollectionVC = PlaylistsCollectionViewController()
        self.featuredPlaylistCollectionVC = FeatPlaylistViewController()
        self.topArtistsCollectionVC = TopArtistsCollectionViewController()
        
        self.setUpNavigationBar()
        self.setUpStackView()
        self.setUpPlaylistsView()
        self.setUpFeatPlaylistsView()
        self.setUpTopArtistView()
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
}








//MARK: setUpFunctions
private extension HomeViewController {
    private func setUpStackView() {
        // Setup scrollView and stackView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 20

        // Add scrollView to main view
        self.view.addSubview(scrollView)
        scrollView.addSubview(stackView)

        // ScrollView and StackView constraints
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 15),
            scrollView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -15),
            scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),

            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 20),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])
    }
    
    private func setUpPlaylistsView() {
        // Add featured playlists label to stackView
        
        // Instantiate and add the playlists collection view controller to stackView
        guard let playlistsCollectionVC = self.playlistsCollectionVC else { return }
        addChild(playlistsCollectionVC)
        stackView.addArrangedSubview(playlistsCollectionVC.view)
        
        playlistsCollectionVC.view.translatesAutoresizingMaskIntoConstraints = false
        let collectionHeightConstraint = playlistsCollectionVC.view.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            collectionHeightConstraint
        ])
        
        playlistsCollectionVC.didMove(toParent: self)
        
        // Set the heightDidChange callback to dynamically adjust height
        playlistsCollectionVC.heightDidChange = { newHeight in
            collectionHeightConstraint.constant = newHeight
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
        
        
        //feat playlists
        stackView.addArrangedSubview(featPlaylistsLabel)
    }
    
    private func setUpFeatPlaylistsView() {
        guard let playlistsCollectionVC = self.featuredPlaylistCollectionVC else { return }
        addChild(playlistsCollectionVC)
        stackView.addArrangedSubview(playlistsCollectionVC.view)
        
        playlistsCollectionVC.view.translatesAutoresizingMaskIntoConstraints = false
        let collectionHeightConstraint = playlistsCollectionVC.view.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            collectionHeightConstraint
        ])
        
        playlistsCollectionVC.didMove(toParent: self)
        
        playlistsCollectionVC.heightDidChange = { newHeight in
            collectionHeightConstraint.constant = 200
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
        
        stackView.addArrangedSubview(topArtistsLabel)
        
    }
    
    private func setUpTopArtistView() {
        guard let playlistsCollectionVC = self.topArtistsCollectionVC else { return }
        addChild(playlistsCollectionVC)
        stackView.addArrangedSubview(playlistsCollectionVC.view)
        
        playlistsCollectionVC.view.translatesAutoresizingMaskIntoConstraints = false
        let collectionHeightConstraint = playlistsCollectionVC.view.heightAnchor.constraint(equalToConstant: 0)
        
        NSLayoutConstraint.activate([
            collectionHeightConstraint
        ])
        
        playlistsCollectionVC.didMove(toParent: self)
        
        playlistsCollectionVC.heightDidChange = { newHeight in
            collectionHeightConstraint.constant = 200
            UIView.animate(withDuration: 0.3) {
                self.view.layoutIfNeeded()
            }
        }
    }
    
    private func setNavButtons() {
        allButton.configuration?.baseBackgroundColor = sectionSelector == .all ? .systemGreen : .systemGray.withAlphaComponent(0.25)
        musicsButton.configuration?.baseBackgroundColor = sectionSelector == .music ? .systemGreen : .systemGray.withAlphaComponent(0.25)
        podcastsButton.configuration?.baseBackgroundColor = sectionSelector == .podcast ? .systemGreen : .systemGray.withAlphaComponent(0.25)
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
            profileButton.heightAnchor.constraint(equalToConstant: 40)
        ])
    }
}
