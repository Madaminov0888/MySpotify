//
//  TopArtistsCollectionViewController.swift
//  MySpotify
//
//  Created by Muhammadjon Madaminov on 15/10/24.
//

import UIKit

private let reuseIdentifier = "Cell"

class TopArtistsCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    private var artists: [TopArtistModel] = []
    
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
        self.collectionView!.register(TopArtistsCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView.delegate = self
        self.collectionView.showsHorizontalScrollIndicator = false
        self.setTasks()
    }
    
    private func updateHeight() {
        let contentHeight = collectionView.collectionViewLayout.collectionViewContentSize.width
        heightDidChange?(contentHeight)
    }
    
    
    func setTasks() {
        Task {
            do {
                let artists = try await apiManager.getTopArtists()
                await MainActor.run {
                    self.artists = artists
                    self.collectionView.reloadData()
                    self.updateHeight()
                }
            } catch {
                print(error)
            }
        }
    }
    
    
    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return artists.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? TopArtistsCollectionViewCell else{
            return UICollectionViewCell()
        }
        let artist = artists[indexPath.row]
        cell.configure(with: artist.name, image: artist.images.first?.url)
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */
}
