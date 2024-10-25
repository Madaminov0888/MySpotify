//
//  TopArtistsCollectionViewCell.swift
//  MySpotify
//
//  Created by Muhammadjon Madaminov on 15/10/24.
//

import UIKit

class TopArtistsCollectionViewCell: UICollectionViewCell {
    private let mediaManager = MediaDownloader()
    
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .semibold)
        label.textAlignment = .center
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    private let artistImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 75
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(artistNameLabel)
        contentView.addSubview(artistImageView)
        setupConstraints()
        contentView.backgroundColor = .csBackgroundColor // Placeholder background color
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            artistImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            artistImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            artistImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            artistImageView.bottomAnchor.constraint(equalTo: artistNameLabel.topAnchor),
            
            artistImageView.widthAnchor.constraint(equalToConstant: 150),
            artistImageView.heightAnchor.constraint(equalToConstant: 150),
            
            artistNameLabel.topAnchor.constraint(equalTo: artistImageView.bottomAnchor),
            artistNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            artistNameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            artistNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
        ])
    }
    
    func configure(with name: String, image: String?) {
        artistNameLabel.text = name
        Task {
            do {
                let image = try await mediaManager.downloadImage(url: image ?? "")
                await MainActor.run {
                    artistImageView.image = image
                }
            } catch {
                print(error)
            }
        }
    }
}
