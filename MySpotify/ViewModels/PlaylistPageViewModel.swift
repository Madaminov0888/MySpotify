//
//  PlaylistPageViewModel.swift
//  MySpotify
//
//  Created by Muhammadjon Madaminov on 19/11/24.
//

import Foundation


protocol PlaylistPageViewModelProtocol: AnyObject {
    func didFinishLoadingTracks(_ tracks: [Track])
    func error(with error: Error)
}



class PlaylistPageViewModel {
    weak var delegate: PlaylistPageViewModelProtocol?
    let apiManager = APIManager()
    var tracks = [Track]()
    
    func fetchTracks(with playlist: PlaylistModel) {
        Task {
            do {
                let tracks = try await self.apiManager.getPlaylistTracks(with: playlist.id, total: playlist.tracks.total)
                await MainActor.run {
                    self.tracks = tracks
                    delegate?.didFinishLoadingTracks(tracks)
                }
            } catch {
                delegate?.error(with: error)
            }
        }
    }
}
