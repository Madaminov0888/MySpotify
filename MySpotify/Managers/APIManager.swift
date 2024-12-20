//
//  APIManager.swift
//  MySpotify
//
//  Created by Muhammadjon Madaminov on 16/07/24.
//

import Foundation


final class APIManager {
    
    public func getUserProfile() async throws -> UserProfile {
        let request = try await setRequest(with: URL(string: Constants.baseURL + "/me"), type: .GET)
        let (data, response) = try await URLSession.shared.data(for: request)
        let checkedData = try responseHandler(response: response, data: data)
        let userData = try JSONDecoder().decode(UserProfile.self, from: checkedData)
        return userData
    }
    
    public func getUserPlaylists() async throws -> [PlaylistModel] {
        let request = try await setRequest(with: URL(string: Constants.baseURL + "/me/playlists"), type: .GET)
        let (data, response) = try await URLSession.shared.data(for: request)
        let checkedData = try responseHandler(response: response, data: data)
        let playlistsResponse = try JSONDecoder().decode(PlaylistResponseModel.self, from: checkedData)
        return playlistsResponse.items
    }
    
    
    public func getUsersFeaturedPlaylists() async throws -> FeaturedPlaylistResponseModel {
        let request = try await setRequest(with: URL(string: Constants.baseURL + "/browse/featured-playlists"), type: .GET)
        let (data, response) = try await URLSession.shared.data(for: request)
        let checkedData = try responseHandler(response: response, data: data)
        let featuredPlaylistsResponse = try JSONDecoder().decode(FeaturedPlaylistResponseModel.self, from: checkedData)
        return featuredPlaylistsResponse
    }
    
    
    public func getUserLibrary() async throws -> [AlbumModel] {
        let request = try await setRequest(with: URL(string: Constants.baseURL + "/me/albums"), type: .GET)
        let (data, response) = try await URLSession.shared.data(for: request)
        let checkedData = try responseHandler(response: response, data: data)
        let libraryResponse = try JSONDecoder().decode(SavedAlbumsResponseModel.self, from: checkedData)
        return libraryResponse.items.map({ $0.album })
    }
    
    
    public func getTopArtists() async throws -> [TopArtistModel] {
        let request = try await setRequest(with: URL(string: Constants.baseURL + "/me/top/artists"), type: .GET)
        let (data, response) = try await URLSession.shared.data(for: request)
        let checkedData = try responseHandler(response: response, data: data)
        let libraryResponse = try JSONDecoder().decode(TopArtistResponseModel.self, from: checkedData)
        return libraryResponse.items
    }
    
    
    public func getPlaylistTracks(with playlistID: String, total: Int) async throws -> [Track] {
        var tracksTotal: [Track] = []
        for i in 0...total/100 {
            let request = try await setRequest(with: URL(string: Constants.baseURL + "/playlists/\(playlistID)/tracks?limit=100&offset=\(i*100)"), type: .GET)
            let (data, response) = try await URLSession.shared.data(for: request)
            let checkedData = try responseHandler(response: response, data: data)
            let tracksResponse = try JSONDecoder().decode(PlaylistTracksResponse.self, from: checkedData)
            tracksTotal.append(contentsOf: tracksResponse.items.compactMap({ $0.track }))
        }
        return tracksTotal
    }
    
    
    //MARK: -Private
    
    
    struct Constants {
        static let baseURL = "https://api.spotify.com/v1"
    }
    
    
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    
    private func setRequest(with url: URL?, type: HTTPMethod) async throws -> URLRequest {
        guard let url = url else { throw URLError(.badURL) }
        let _ = await AuthManager.shared.refreshTokenIfNeeded()
        let token = UserDefaults.standard.value(forKey: "access_token")
        guard let token = token else {
            print("token not found")
            throw URLError(.dataNotAllowed)
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = type.rawValue
        request.timeoutInterval = 30
        
        return request
    }
    
    private func responseHandler(response: URLResponse, data: Data) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
            print("Error: HTTP request failed with status code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
            print(" Error Raw response data: \(String(data: data, encoding: .utf8) ?? "Invalid data")")
            throw URLError(.badServerResponse)
        }
//        print(" SUCCESS Raw response data: \(String(data: data, encoding: .utf8) ?? "Invalid data")")
        return data
    }
    
}
