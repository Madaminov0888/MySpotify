//
//  MusicsCellView.swift
//  MySpotify
//
//  Created by Muhammadjon Madaminov on 19/11/24.
//

import UIKit

class MusicsCellView: UICollectionViewCell {
    
    static let identifier = "MusicsCellView"
    private let mediaManager = MediaDownloader()
    
    private var trackNameLabel = UILabel()
    private var trackImage = UIImageView()
    private var trackAuthorLabel = UILabel()
    private var toolbar = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func configure(with track: Track) {
        self.trackNameLabel.text = track.name
        self.trackAuthorLabel.text = track.artists.first?.name
        
        Task {
            do {
                if let imageURL = track.album?.images.first?.url {
                    let image = try await mediaManager.downloadImage(url: imageURL)
                    await MainActor.run {
                        self.trackImage.image = image
                    }
                }
            } catch {
                print(error)
            }
        }
    }
}





extension MusicsCellView { //MARK: Views
    private func setUpConstraints() {
        setTrackNameLabel()
        setTrackImageView()
        setTrackAuthorLabel()
        setToolsButton()
        
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(trackImage)
        contentView.addSubview(trackAuthorLabel)
        contentView.addSubview(toolbar)
        
        NSLayoutConstraint.activate([
            trackImage.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            trackImage.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            trackImage.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            
            trackNameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            trackNameLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            trackNameLabel.leadingAnchor.constraint(equalTo: self.trackImage.trailingAnchor, constant: 10),
            
            trackAuthorLabel.topAnchor.constraint(equalTo: self.trackNameLabel.bottomAnchor, constant: 10),
            trackAuthorLabel.leadingAnchor.constraint(equalTo: self.trackImage.trailingAnchor, constant: 10),
            trackAuthorLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            
            toolbar.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            toolbar.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            toolbar.leadingAnchor.constraint(equalTo: self.trackNameLabel.trailingAnchor, constant: 10),
            toolbar.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -10),
        ])
    }
    
    private func setTrackNameLabel() {
        let nameLabel = UILabel()
        nameLabel.text = ""
        nameLabel.font = .systemFont(ofSize: 20, weight: .medium)
        nameLabel.textColor = .white
        nameLabel.textAlignment = .left
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.trackNameLabel = nameLabel
    }
    
    private func setTrackAuthorLabel() {
        let authorLabel = UILabel()
        authorLabel.text = ""
        authorLabel.font = .systemFont(ofSize: 15, weight: .medium)
        authorLabel.textColor = .csLightGray
        authorLabel.textAlignment = .left
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        self.trackAuthorLabel = authorLabel
    }
    
    private func setTrackImageView() {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "placeholder")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        self.trackImage = imageView
    }
    
    private func setToolsButton() {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        self.toolbar = button
    }
}
