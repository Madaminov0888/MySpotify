//
//  MusicsViewController.swift
//  MySpotify
//
//  Created by Muhammadjon Madaminov on 25/10/24.
//
//
//  MusicsViewController.swift
//  MySpotify
//
//  Created by Muhammadjon Madaminov on 25/10/24.
//
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
    var tracks: [Track] = []
    var scrollUpdater: (_ scrollView: UIScrollView) -> () = { _ in }
    
    
    init(playlist: PlaylistModel, layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()) {
        self.playlist = playlist
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
//        layout.sectionHeadersPinToVisibleBounds = true
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 70)
        super.init(collectionViewLayout: layout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set delegate
        vm.delegate = self
        self.collectionView.delegate = self
        
        // Fetch tracks if playlist exists
        if let playlist = playlist {
            vm.fetchTracks(with: playlist)
        }
        
        // Register cell
        self.collectionView!.register(MusicsCellView.self, forCellWithReuseIdentifier: MusicsCellView.identifier)
        
        // Register header view
        self.collectionView.register(
            HeaderCollectionReusableView.self,
            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: HeaderCollectionReusableView.reuseIdentifier
        )
        
        // Set background colors
        self.collectionView.backgroundColor = .clear
        self.view.backgroundColor = .clear
        
        // Remove default content inset
        self.collectionView.contentInset = .zero
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = .zero
        }
    }
    
    // MARK: UICollectionViewDataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tracks.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MusicsCellView.identifier, for: indexPath) as? MusicsCellView else {
            return UICollectionViewCell()
        }
        
        cell.configure(with: tracks[indexPath.row])
        return cell
    }
    
    
    
    
    // MARK: Header View Configuration
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            print("Header is being created")
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
    
    
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        scrollUpdater(scrollView)
    }
    
    
    // MARK: Header Size Configuration
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 150)
    }

    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero // Ensure no padding
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0 // No spacing between items
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0 // No spacing between rows
    }
}

// MARK: - PlaylistPageViewModelProtocol

extension MusicsViewController: PlaylistPageViewModelProtocol {
    func didFinishLoadingTracks(_ tracks: [Track]) {
        self.tracks = tracks
        self.collectionView.reloadData()
    }
    
    func error(with error: any Error) {
        print(error.localizedDescription)
    }
}
