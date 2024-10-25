//
//  PlaylistPageViewController.swift
//  MySpotify
//
//  Created by Muhammadjon Madaminov on 04/10/24.
//



import UIKit
import ColorKit

class PlaylistPageViewController: UIViewController {

    let playlist: PlaylistModel
    private let mediaManager = MediaDownloader()
    private var gradientColor: UIColor = UIColor.systemGray

    init(playlist: PlaylistModel) {
        self.playlist = playlist
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .csBackgroundColor
        self.navigationItem.hidesBackButton = true
        self.setUpUI()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = backgroundGradientView.bounds // Ensure gradient layer has the correct frame
        
        circleNameLabel.layer.cornerRadius = circleNameLabel.frame.height / 2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    // MARK: - Views
    private func setUpUI() {
        self.setBackgroundGradient()
        
        self.view.addSubview(vstack)
        self.view.addSubview(backButton)
        backButton.addTarget(self, action: #selector (backButtonTapped), for: .touchUpInside)
        vstack.translatesAutoresizingMaskIntoConstraints = false
        self.setStacks()

        // Add and configure name label
        
        self.view.addSubview(playlistCoverImageView)
        self.playlistCoverImageView.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            vstack.topAnchor.constraint(equalTo: self.playlistCoverImageView.bottomAnchor, constant: 20),
            vstack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            vstack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            
            backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
            backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 25),
            backButton.heightAnchor.constraint(equalToConstant: 25),
            
            playlistCoverImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            playlistCoverImageView.bottomAnchor.constraint(equalTo: self.vstack.topAnchor, constant: -20),
            playlistCoverImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            
            playlistCoverImageView.widthAnchor.constraint(equalToConstant: self.view.frame.width/5*3),
            playlistCoverImageView.heightAnchor.constraint(equalToConstant: self.view.frame.width/5*3),
        ])
    }
    
    
    private func downloadImage(image: String?) {
        Task {
            do {
                let image = try await mediaManager.downloadImage(url: image ?? "")
                await MainActor.run {
                    ownerDisplayImage.image = image
                }
            } catch {
                print(error)
            }
        }
    }
    
    
    
    private func setStacks() {
        vstack.addArrangedSubview(nameLabel)
        self.nameLabel.text = playlist.name
        
        
        vstack.addArrangedSubview(hstack)
        hstack.translatesAutoresizingMaskIntoConstraints = false
        
        if playlist.owner.images?.count ?? 0 > 0 {
            self.downloadImage(image: playlist.owner.images?.first?.url)
            hstack.addArrangedSubview(ownerDisplayImage)
        } else {
            self.circleNameLabel.text = playlist.owner.displayName.first?.uppercased()
            circleNameLabel.translatesAutoresizingMaskIntoConstraints = false
            circleNameLabel.layer.cornerRadius = circleNameLabel.height / 2
            circleNameLabel.clipsToBounds = true
            hstack.addArrangedSubview(circleNameLabel)
        }
        
        hstack.addArrangedSubview(ownerLabel)
        self.ownerLabel.text = playlist.owner.displayName.capitalized
        
        vstack.addArrangedSubview(playlistTotalTimeLabel)
        self.playlistTotalTimeLabel.text = self.getPlaylistTotalTime()
        
        
        NSLayoutConstraint.activate([
            circleNameLabel.widthAnchor.constraint(equalTo: hstack.heightAnchor, constant: 20),
            circleNameLabel.heightAnchor.constraint(equalTo: hstack.heightAnchor, constant: 20),
        ])
    }
    
    
    private func setBackgroundGradient() {
        // Add the background view and gradient
        self.downloadTheImage(image: playlist.images.first?.url)
        self.gradientLayer.colors = [self.gradientColor.cgColor, UIColor.clear.cgColor]
        self.view.addSubview(backgroundGradientView)
        backgroundGradientView.layer.addSublayer(gradientLayer)

        NSLayoutConstraint.activate([
            backgroundGradientView.topAnchor.constraint(equalTo: self.view.topAnchor),
            backgroundGradientView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            backgroundGradientView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            backgroundGradientView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
        ])
    }
    
    private func downloadTheImage(image: String?) {
        Task {
            do {
                let image = try await mediaManager.downloadImage(url: image ?? "")
                let dominantColor = try image.averageColor()
                
                await MainActor.run {
                    // Update the playlist cover image
                    playlistCoverImageView.image = image
                    
                    // Update the gradient color
                    self.gradientColor = dominantColor
                    self.updateGradientColor()
                }
            } catch {
                print(error)
            }
        }
    }

    private func updateGradientColor() {
        // Update the gradient layer's colors
        gradientLayer.colors = [self.gradientColor.cgColor, UIColor.clear.cgColor]
        
        // Optionally, trigger a layout update to ensure the gradient applies correctly
        self.view.setNeedsLayout()
    }
    
    
    private let vstack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 25
        return stackView
    }()
    
    private let ownerDisplayImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    private let circleNameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .brown
        label.font = .systemFont(ofSize: 10, weight: .semibold)
        label.layer.cornerRadius = label.frame.width/2
        label.clipsToBounds = true
        return label
    }()
    
    private let hstack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let ownerLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let playlistTotalTimeLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 13, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.locations = [0, 0.8]
        return gradient
    }()

    private let backgroundGradientView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    private let backButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: button.height, weight: .semibold, scale: .large)
        button.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    private let playlistCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    //functions
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
    
    private func getPlaylistTotalTime() -> String {
        let tracks = self.playlist.tracks
        
        return ""
    }
}
