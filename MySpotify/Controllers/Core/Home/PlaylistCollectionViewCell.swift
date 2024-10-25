//
//  PlaylistCollectionViewCell.swift
//  MySpotify
//
//  Created by Muhammadjon Madaminov on 27/09/24.
//

import Foundation
import UIKit


class PlaylistCollectionViewCell: UICollectionViewCell {
    
    private let mediaManager = MediaDownloader()
    
    private let playlistNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .left
        label.numberOfLines = 2
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private let playlistImageView: UIImageView = {
        
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(playlistImageView)
        setupConstraints()
        contentView.backgroundColor = .csLightGray // Placeholder background color
        contentView.layer.cornerRadius = 5
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            playlistImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            playlistImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            playlistImageView.trailingAnchor.constraint(equalTo: self.playlistNameLabel.leadingAnchor, constant: -10),
            playlistImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            playlistImageView.widthAnchor.constraint(equalTo: playlistImageView.heightAnchor),
            
            playlistNameLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
            playlistNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            playlistNameLabel.leadingAnchor.constraint(equalTo: playlistImageView.trailingAnchor, constant: 10),
            playlistNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
        ])
    }
    
    func configure(with name: String, image: String?) {
        playlistNameLabel.text = name
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
