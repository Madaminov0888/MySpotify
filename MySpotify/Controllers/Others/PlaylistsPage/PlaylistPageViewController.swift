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
    private let apiManager = APIManager()
    private var gradientColor: UIColor = UIColor.systemGray
    private var playlistDuration: String = ""
    
    // Reference to MusicsViewController
    private let musicsViewController: MusicsViewController
    
    init(playlist: PlaylistModel) {
        self.playlist = playlist
        self.musicsViewController = MusicsViewController(playlist: playlist, layout: UICollectionViewFlowLayout())
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .csBackgroundColor
        self.navigationItem.hidesBackButton = true
        setupUI()
        addMusicsViewController()  // Embed MusicsViewController
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientLayer.frame = backgroundGradientView.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    private func setupUI() {
        setBackgroundGradient()
        
        view.addSubview(backButton)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        
        view.addSubview(playlistCoverImageView)
        playlistCoverImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            playlistCoverImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            playlistCoverImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            playlistCoverImageView.widthAnchor.constraint(equalToConstant: view.frame.width / 5 * 3),
            playlistCoverImageView.heightAnchor.constraint(equalToConstant: view.frame.width / 5 * 3),
            
            backButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backButton.widthAnchor.constraint(equalToConstant: 25),
            backButton.heightAnchor.constraint(equalToConstant: 25),
        ])
    }
    
    // Embed MusicsViewController within PlaylistPageViewController
    private func addMusicsViewController() {
        addChild(musicsViewController)
        view.addSubview(musicsViewController.view)
        musicsViewController.didMove(toParent: self)
        
        musicsViewController.view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            musicsViewController.view.topAnchor.constraint(equalTo: playlistCoverImageView.bottomAnchor, constant: 20),
            musicsViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            musicsViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            musicsViewController.view.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private let backButton: UIButton = {
        let button = UIButton()
        let config = UIImage.SymbolConfiguration(pointSize: 25, weight: .semibold, scale: .large)
        button.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.tintColor = .white
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private func updateGradientColor() {
        gradientLayer.colors = [gradientColor.cgColor, UIColor.clear.cgColor]
        view.setNeedsLayout()
    }
    
    private func setBackgroundGradient() {
        downloadTheImage(image: playlist.images.first?.url)
        gradientLayer.colors = [gradientColor.cgColor, UIColor.clear.cgColor]
        view.addSubview(backgroundGradientView)
        backgroundGradientView.layer.addSublayer(gradientLayer)

        NSLayoutConstraint.activate([
            backgroundGradientView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundGradientView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundGradientView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundGradientView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private let gradientLayer: CAGradientLayer = {
        let gradient = CAGradientLayer()
        gradient.locations = [0, 1]
        return gradient
    }()

    private let backgroundGradientView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let playlistCoverImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private func downloadTheImage(image: String?) {
        Task {
            do {
                let image = try await mediaManager.downloadImage(url: image ?? "")
                let dominantColor = try image.averageColor()
                
                await MainActor.run {
                    playlistCoverImageView.image = image
                    gradientColor = dominantColor
                    updateGradientColor()
                }
            } catch {
                print(error)
            }
        }
    }
    
    @objc private func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}





//
//class PlaylistPageViewController: UIViewController {
//
//    let playlist: PlaylistModel
//    private let mediaManager = MediaDownloader()
//    private let apiManager = APIManager()
//    private var gradientColor: UIColor = UIColor.systemGray
//
//    private var playlistDuration: String = ""
//    
//    init(playlist: PlaylistModel) {
//        self.playlist = playlist
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.view.backgroundColor = .csBackgroundColor
//        self.navigationItem.hidesBackButton = true
//        self.setupUI()
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        gradientLayer.frame = backgroundGradientView.bounds // Ensure gradient layer has the correct frame
//        
//        
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        self.navigationController?.setNavigationBarHidden(true, animated: animated)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        self.navigationController?.setNavigationBarHidden(false, animated: animated)
//    }
//
//    // MARK: - Views
//    
//    
//    
//    private func setupUI() {
//        self.setBackgroundGradient()
//        
//        self.view.addSubview(backButton)
//        backButton.addTarget(self, action: #selector (backButtonTapped), for: .touchUpInside)
//        
//        self.view.addSubview(playlistCoverImageView)
//        self.playlistCoverImageView.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            playlistCoverImageView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
////            playlistCoverImageView.bottomAnchor.constraint(equalTo: self.vstack.topAnchor, constant: -20),
//            playlistCoverImageView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
//            
//            playlistCoverImageView.widthAnchor.constraint(equalToConstant: self.view.frame.width/5*3),
//            playlistCoverImageView.heightAnchor.constraint(equalToConstant: self.view.frame.width/5*3),
//            
//            backButton.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10),
//            backButton.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
//            backButton.widthAnchor.constraint(equalToConstant: 25),
//            backButton.heightAnchor.constraint(equalToConstant: 25),
//        ])
//    }
//    
//    
//    private let backButton: UIButton = {
//        let button = UIButton()
//        let config = UIImage.SymbolConfiguration(pointSize: button.height, weight: .semibold, scale: .large)
//        button.setImage(UIImage(systemName: "chevron.left", withConfiguration: config), for: .normal)
//        button.imageView?.contentMode = .scaleAspectFill
//        button.tintColor = .white
//        button.translatesAutoresizingMaskIntoConstraints = false
//        return button
//    }()
//    
//    
//    private func updateGradientColor() {
//        // Update the gradient layer's colors
//        gradientLayer.colors = [self.gradientColor.cgColor, UIColor.clear.cgColor]
//        
//        // Optionally, trigger a layout update to ensure the gradient applies correctly
//        self.view.setNeedsLayout()
//    }
//    
//    
//    
//    private func setBackgroundGradient() {
//        // Add the background view and gradient
//        self.downloadTheImage(image: playlist.images.first?.url)
//        self.gradientLayer.colors = [self.gradientColor.cgColor, UIColor.clear.cgColor]
//        self.view.addSubview(backgroundGradientView)
//        backgroundGradientView.layer.addSublayer(gradientLayer)
//
//        NSLayoutConstraint.activate([
//            backgroundGradientView.topAnchor.constraint(equalTo: self.view.topAnchor),
//            backgroundGradientView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
//            backgroundGradientView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
//            backgroundGradientView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
//        ])
//    }
//    
//    
//    private let gradientLayer: CAGradientLayer = {
//        let gradient = CAGradientLayer()
//        gradient.locations = [0, 1]
//        return gradient
//    }()
//
//    private let backgroundGradientView: UIView = {
//        let view = UIView()
//        view.translatesAutoresizingMaskIntoConstraints = false
//        return view
//    }()
//    
//    
//    
//    private let playlistCoverImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        return imageView
//    }()
//    
//    private func downloadTheImage(image: String?) {
//        Task {
//            do {
//                let image = try await mediaManager.downloadImage(url: image ?? "")
//                let dominantColor = try image.averageColor()
//                
//                await MainActor.run {
//                    // Update the playlist cover image
//                    playlistCoverImageView.image = image
//                    
//                    // Update the gradient color
//                    self.gradientColor = dominantColor
//                    self.updateGradientColor()
//                }
//            } catch {
//                print(error)
//            }
//        }
//    }
//    
//    
//    
//    @objc private func backButtonTapped() {
//        self.navigationController?.popViewController(animated: true)
//    }
//    
//    
//    //MARK: - jsjsjsj
//    
//}
