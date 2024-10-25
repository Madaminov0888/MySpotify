//
//  PlaylistsCollectionCollectionViewController.swift
//  MySpotify
//
//  Created by Muhammadjon Madaminov on 15/09/24.
//
//  PlaylistsCollectionViewController.swift
//  MySpotify


import UIKit
import SwiftUI

private let reuseIdentifier = "PlaylistCell"

class PlaylistsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var playlists: [PlaylistModel] = []
    var albums: [AlbumModel] = []
    private let apiManager = APIManager()
    
    var contentList: [any UserFeatProtocol] = []
    var heightDidChange: ((CGFloat) -> Void)?
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 60) // Adjust item size as needed
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 10
        
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = .csBackgroundColor
        self.collectionView!.register(PlaylistCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.delegate = self
        self.tasks()
    }
    
    private func updateHeight() {
        let contentHeight = collectionView.collectionViewLayout.collectionViewContentSize.height
        heightDidChange?(contentHeight)
    }

    private func tasks() {
        Task {
            do {
                let featuredAlbumResponseModel = try await self.apiManager.getUserLibrary()
                let featuredPlaylistResponseModel = try await self.apiManager.getUserPlaylists()
                await MainActor.run {
                    self.playlists = featuredPlaylistResponseModel
                    self.albums = featuredAlbumResponseModel
                    self.populateContentList()
                    self.collectionView.reloadData()
                    self.updateHeight()
                }
            } catch {
                print(error)
            }
        }
    }
    
    private func populateContentList() {
        contentList = playlists
        if !contentList.isEmpty || !albums.isEmpty {
            contentList.append(LikedSongs(images: [PlaylistImage(url: "https://image-cdn-ak.spotifycdn.com/image/ab67706c0000da849d25907759522a25b86a3033", height: 200, width: 200)],id: "LikedSongs", name: "Liked Songs"))
        }
        contentList.append(contentsOf: albums)
    }
    

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.width / 2 - 5
        return CGSize(width: width, height: 60)
    }
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PlaylistCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        // Configure the cell
        let content = contentList[indexPath.row]
        cell.configure(with: content.name, image: content.images.first?.url)
        
        return cell
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let content = contentList[indexPath.row]
        
        if let playlist = content as? PlaylistModel {
            let vc = PlaylistPageViewController(playlist: playlist)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
