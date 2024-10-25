//
//  FeatViewCell.swift
//  MySpotify
//
//  Created by Muhammadjon Madaminov on 11/10/24.
//

import UIKit

class FeatViewCell: UICollectionViewCell {
    private let mediaManager = MediaDownloader()
    
    private let playlistNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let playlistArtistLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 10, weight: .semibold)
        label.textAlignment = .left
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private let playlistImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(playlistImageView)
        contentView.addSubview(playlistArtistLabel)
        setupConstraints()
        contentView.backgroundColor = .csBackgroundColor // Placeholder background color
//        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            playlistImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            playlistImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            playlistImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            playlistImageView.bottomAnchor.constraint(equalTo: playlistNameLabel.topAnchor),
            
            playlistImageView.widthAnchor.constraint(equalToConstant: 150),
            playlistImageView.heightAnchor.constraint(equalToConstant: 150),
            
            playlistNameLabel.topAnchor.constraint(equalTo: playlistImageView.bottomAnchor),
            playlistNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            playlistNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            playlistNameLabel.bottomAnchor.constraint(equalTo: playlistArtistLabel.topAnchor),
            
            playlistArtistLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            playlistArtistLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            playlistArtistLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            playlistArtistLabel.topAnchor.constraint(equalTo: playlistNameLabel.bottomAnchor),
        ])
    }
    
    func configure(with name: String, image: String?, description: String) {
        playlistNameLabel.text = name
        playlistArtistLabel.text = description
        Task {
            do {
                let image = try await mediaManager.downloadImage(url: image ?? "")
                await MainActor.run {
                    playlistImageView.image = image
                }
            } catch {
                print(error)
            }
        }
    }
    
    
    
}
