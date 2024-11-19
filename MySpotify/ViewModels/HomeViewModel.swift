//
//  HomeViewModel.swift
//  MySpotify
//
//  Created by Muhammadjon Madaminov on 03/11/24.
//

import Foundation



protocol HomeViewModelDelegate: AnyObject {
    func didFinishLoadingPlaylists(_ playlists: [PlaylistModel])
    func didFail(error: Error)
}



class HomeViewModel {
    
    weak var delegate: HomeViewModelDelegate?
    var featPlaylists = [PlaylistModel]()
    private let apiManager = APIManager()
    
    func getFeatPlaylists() {
        Task {
            do {
                let featuredPlaylists = try await apiManager.getUsersFeaturedPlaylists().playlists.items
                await MainActor.run {
                    self.featPlaylists = featuredPlaylists
                    delegate?.didFinishLoadingPlaylists(featuredPlaylists)
                }
            } catch {
                await MainActor.run {
                    delegate?.didFail(error: error)
                }
            }
        }
    }
    
}
