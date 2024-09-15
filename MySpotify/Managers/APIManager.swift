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
