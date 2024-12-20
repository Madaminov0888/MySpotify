//
//  HeaderCollectionReusableView.swift
//  MySpotify
//
//  Created by Muhammadjon Madaminov on 25/10/24.
//

import UIKit
import UIKit

class HeaderCollectionReusableView: UICollectionReusableView {
    static let reuseIdentifier = "CustomHeaderView"

    private var playlist: PlaylistModel?
    private let mediaManager = MediaDownloader()
    private let apiManager = APIManager()

    private var playlistDuration: String = ""

    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        circleNameLabel.layer.cornerRadius = circleNameLabel.frame.height / 2
    }

    private func setUpUI() {
        self.addSubview(vstack)
        vstack.translatesAutoresizingMaskIntoConstraints = false
        setStacks()

        NSLayoutConstraint.activate([
            vstack.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 20),
            vstack.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20),
        ])
    }

    func configure(with playlist: PlaylistModel?) {
        guard let playlist else { return }
        self.playlist = playlist
        nameLabel.text = playlist.name
        ownerLabel.text = playlist.owner.displayName.capitalized

        if let ownerImageUrl = playlist.owner.images?.first?.url {
            downloadImage(image: ownerImageUrl)
        } else {
            circleNameLabel.text = playlist.owner.displayName.first?.uppercased()
        }
        getPlaylistTotalTime()
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
        vstack.addArrangedSubview(hstack)

        if let _ = playlist?.owner.images?.first?.url {
            hstack.addArrangedSubview(ownerDisplayImage)
            NSLayoutConstraint.activate([
                ownerDisplayImage.widthAnchor.constraint(equalToConstant: 20),
                ownerDisplayImage.heightAnchor.constraint(equalToConstant: 20),
            ])
            ownerDisplayImage.layer.cornerRadius = 10
        } else {
            hstack.addArrangedSubview(circleNameLabel)
            NSLayoutConstraint.activate([
                circleNameLabel.widthAnchor.constraint(equalToConstant: 20),
                circleNameLabel.heightAnchor.constraint(equalToConstant: 20),
            ])
            circleNameLabel.layer.cornerRadius = 10
        }
        hstack.addArrangedSubview(ownerLabel)
        vstack.addArrangedSubview(playlistTotalTimeLabel)
    }

    private let vstack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
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
        label.textAlignment = .center
        label.textColor = .black
        label.backgroundColor = .brown
        label.font = .systemFont(ofSize: 10, weight: .semibold)
        label.clipsToBounds = true
        return label
    }()

    private let hstack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 25, weight: .bold)
        return label
    }()

    private let ownerLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 13, weight: .bold)
        return label
    }()

    private let playlistTotalTimeLabel: UILabel = {
        let symbolImage = UIImage(systemName: "globe")
        let attachment = NSTextAttachment()
        attachment.image = symbolImage?.withTintColor(.lightGray, renderingMode: .alwaysOriginal)
        attachment.bounds = CGRect(x: 0, y: -2, width: 14, height: 14)
        
        let imageAttributedString = NSAttributedString(attachment: attachment)
        let combinedAttributedString = NSMutableAttributedString(attributedString: imageAttributedString)
        
        let label = UILabel()
        label.textColor = .lightGray
        label.font = .systemFont(ofSize: 12, weight: .semibold)
        label.attributedText = combinedAttributedString
        return label
    }()

    private func getPlaylistTotalTime() {
        guard let playlist = playlist else { return }
        Task {
            do {
                let tracks = try await apiManager.getPlaylistTracks(with: playlist.id, total: playlist.tracks.total)
                let totalTime = tracks.reduce(0) { $0 + $1.durationMs }
                await MainActor.run {
                    let attrStr = NSMutableAttributedString(attributedString: playlistTotalTimeLabel.attributedText ?? NSAttributedString())
                    attrStr.append(NSAttributedString(string: formatDuration(milliseconds: totalTime)))
                    playlistTotalTimeLabel.attributedText = attrStr
                    layoutIfNeeded()
                }
            } catch {
                print(error)
            }
        }
    }

    func formatDuration(milliseconds: Int) -> String {
        let totalMinutes = milliseconds / 60000
        let hours = totalMinutes / 60
        let minutes = totalMinutes % 60

        if hours > 0 && minutes > 0 {
            return " ・ \(hours)h \(minutes)m"
        } else if hours > 0 {
            return " ・ \(hours)h"
        } else {
            return " ・ \(minutes)m"
        }
    }
}
