//
//  FeatPlaylistViewController.swift
//  MySpotify
//
//  Created by Muhammadjon Madaminov on 04/10/24.
//

import UIKit

private let reuseIdentifier = "featCell"

class FeatPlaylistViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    var playlists: [PlaylistModel] = []
    
    let apiManager = APIManager()
    var heightDidChange: ((CGFloat) -> Void)?
    
    
    init() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 150, height: 200)
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = .csBackgroundColor
        self.collectionView!.register(FeatViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.delegate = self
        self.collectionView.showsHorizontalScrollIndicator = false
        self.setTasks()
    }
    
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .headline)
        return label
    }()
    
    
    
    //MARK: -TASKS
    
    private func updateHeight() {
        let contentHeight = collectionView.collectionViewLayout.collectionViewContentSize.width
        heightDidChange?(contentHeight)
    }
    
    func setTasks() {
        Task {
            do {
                let featuredPlaylists = try await apiManager.getUsersFeaturedPlaylists().playlists.items
                await MainActor.run {
                    self.playlists = featuredPlaylists
                    self.collectionView.reloadData()
                    self.updateHeight()
                }
            } catch {
                print(error)
            }
        }
    }
    
    
    
    // MARK: -UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return playlists.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? FeatViewCell else {
            return UICollectionViewCell()
        }
        let content = playlists[indexPath.row]
        cell.configure(with: content.name, image: content.images.first?.url, description: content.description)
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */
    
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let content = playlists[indexPath.row]
        let playlistsVC = PlaylistPageViewController(playlist: content)
        self.navigationController?.pushViewController(playlistsVC, animated: true)
        return true
    }

}
