//
//  MusicsViewController.swift
//  MySpotify
//
//  Created by Muhammadjon Madaminov on 25/10/24.
//

import UIKit


class MusicsViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let playlist: PlaylistModel?
    let vm = PlaylistPageViewModel()
    
    
    init(playlist: PlaylistModel, layout: UICollectionViewLayout = UICollectionViewFlowLayout()) {
        self.playlist = playlist
        super.init(collectionViewLayout: layout)
        self.view.layoutIfNeeded()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Register cell
        self.collectionView!.register(MusicsCellView.self, forCellWithReuseIdentifier: MusicsCellView.identifier)
        
        self.collectionView.backgroundColor = .clear
        self.view.backgroundColor = .clear 
        
        // Register header view correctly
        self.collectionView.register(
            HeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderCollectionReusableView.reuseIdentifier
        )
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return vm.tracks.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MusicsCellView.identifier, for: indexPath) as? MusicsCellView else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: vm.tracks[indexPath.row])
        
        return cell
    }
    
    // MARK: Header View Configuration
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerView = collectionView.dequeueReusableSupplementaryView(
                ofKind: kind,
                withReuseIdentifier: HeaderCollectionReusableView.reuseIdentifier,
                for: indexPath
            ) as! HeaderCollectionReusableView
            
            headerView.configure(with: playlist)
            return headerView
        }
        return UICollectionReusableView()
    }
    
    // MARK: Header Size Configuration
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 150)
    }
    
    
    
    // MARK: UICollectionViewDelegate
    
    /*
     // Uncomment this method to specify if the specified item should be highlighted during tracking
     override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     
     // Uncomment this method to specify if the specified item should be selected
     override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
     return true
     }
     
     // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
     override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
     return false
     }
     
     override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
     
     }
     */
    
}



extension MusicsViewController: PlaylistPageViewModelProtocol {
    func didFinishLoadingTracks(_ tracks: [Track]) {
        self.collectionView.reloadData()
    }
    
    func error(with error: any Error) {
        print(error.localizedDescription)
    }
}
