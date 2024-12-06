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
    
    private let trackNameLabel = UILabel()
    private let trackImage = UIImageView()
    private let trackAuthorLabel = UILabel()
    private let toolbar = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        trackImage.image = UIImage(systemName: "music.note")
        trackImage.tintColor = .white
        trackImage.contentMode = .scaleAspectFit
        trackImage.backgroundColor = .csLightGray
    }
    
    
    
    func configure(with track: Track) {
        self.trackNameLabel.text = track.name
        self.trackAuthorLabel.text = track.artists.first?.name
        
        Task {
            do {
                if let imageURL = track.album?.images.first?.url {
                    let image = try await mediaManager.downloadImage(url: imageURL)
                    await MainActor.run { [weak self] in
//                        self?.trackImage.image = image
                        if self?.trackNameLabel.text == track.name {
                            self?.trackImage.image = image
                        }
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
            
            trackImage.widthAnchor.constraint(equalToConstant: 50),
            trackImage.heightAnchor.constraint(equalToConstant: 50),
            
            trackNameLabel.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            trackNameLabel.bottomAnchor.constraint(equalTo: self.trackAuthorLabel.topAnchor),
            trackNameLabel.leadingAnchor.constraint(equalTo: self.trackImage.trailingAnchor, constant: 10),
            trackNameLabel.trailingAnchor.constraint(lessThanOrEqualTo: toolbar.leadingAnchor, constant: -10),
            
            trackAuthorLabel.topAnchor.constraint(equalTo: self.trackNameLabel.bottomAnchor),
            trackAuthorLabel.leadingAnchor.constraint(equalTo: self.trackImage.trailingAnchor, constant: 10),
            trackAuthorLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            trackAuthorLabel.trailingAnchor.constraint(lessThanOrEqualTo: toolbar.leadingAnchor, constant: -10),
            
            toolbar.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            toolbar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            toolbar.widthAnchor.constraint(equalToConstant: 30),
            toolbar.heightAnchor.constraint(equalToConstant: 30),
        ])
    }
    
    private func setTrackNameLabel() {
        trackNameLabel.text = ""
        trackNameLabel.font = .systemFont(ofSize: 20, weight: .medium)
        trackNameLabel.textColor = .white
        trackNameLabel.textAlignment = .left
        trackNameLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setTrackAuthorLabel() {
        trackAuthorLabel.text = ""
        trackAuthorLabel.font = .systemFont(ofSize: 15, weight: .medium)
        trackAuthorLabel.textColor = .lightText
        trackAuthorLabel.textAlignment = .left
        trackAuthorLabel.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setTrackImageView() {
        trackImage.image = UIImage(named: "placeholder")
        trackImage.contentMode = .scaleAspectFill
        trackImage.clipsToBounds = true
        trackImage.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func setToolsButton() {
        toolbar.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        toolbar.tintColor = .white
        toolbar.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
