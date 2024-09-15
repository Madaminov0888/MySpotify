//
//  AuthManager.swift
//  MySpotify
//
//  Created by Muhammadjon Madaminov on 16/07/24.
//

import Foundation


final class AuthManager {
    static let shared = AuthManager()
    
    let scheme = "https"
    let host = "accounts.spotify.com"
    let authPath = "/authorize"
    let apiTokenUrl = "https://accounts.spotify.com/api/token"
    
    
    
    struct Constants {
        static let clientID = "9e67a49a6ac243bab80e0b152e48d956"
        static let clientSecret = "604b80a58ab2478d9eaad17ad5443d78"
        static let scope = "user-read-private%20user-read-playback-state%20user-modify-playback-state%20user-read-currently-playing%20app-remote-control%20streaming%20playlist-read-private%20playlist-read-collaborative%20playlist-modify-private%20playlist-modify-public%20user-read-playback-position%20user-top-read%20user-read-recently-played%20user-library-modify%20user-library-read%20"
    }
    
    
    private init() {}
    
    
    public var singInURL: URL? {
        var urlComponent = URLComponents()
        urlComponent.scheme = scheme
        urlComponent.host = host
        urlComponent.path = authPath
        urlComponent.queryItems = [
            URLQueryItem(name: "response_type", value: "code"),
            .init(name: "client_id", value: Constants.clientID),
            .init(name: "scope", value: Constants.scope),
            .init(name: "redirect_uri", value: "http://example.com/")
        ]
        return urlComponent.url
    }
    
    
    var isSignedIn: Bool {
        return accessToken != nil
    }
    
    private var accessToken: String? {
        return UserDefaults.standard.string(forKey: "access_token")
    }
    
    private var refreshToken: String? {
        return UserDefaults.standard.string(forKey: "refresh_token")
    }
    
    
    private var tokenExpirationDate: Date? {
        return UserDefaults.standard.object(forKey: "expirationDate") as? Date
    }
    
    private var shouldRefreshToken: Bool {
        guard let expirationDate = tokenExpirationDate else { return false }
        return Date().addingTimeInterval(300) >= expirationDate
    }
    
    
    private func responseHandler(response: URLResponse, data: Data) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
            print("Error: HTTP request failed with status code: \((response as? HTTPURLResponse)?.statusCode ?? 0)")
            throw URLError(.badServerResponse)
        }
        print(" SUCCESS Raw response data: \(String(data: data, encoding: .utf8) ?? "Invalid data")")
        return data
    }
    
    
    public func exchangeCodeToken(code: String) async -> Bool {
        do {
            guard let url = URL(string: apiTokenUrl) else {
                throw URLError(.badURL)
            }
            
            var components = URLComponents()
            components.queryItems = [
                .init(name: "grant_type", value: "authorization_code"),
                .init(name: "code", value: code),
                .init(name: "redirect_uri", value: "http://example.com/"),
                .init(name: "show_dialog", value: "TRUE")
            ]
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpBody = components.query?.data(using: .utf8)
            
            let basicToken = Constants.clientID + ":" + Constants.clientSecret
            
            guard let base64String = basicToken.data(using: .utf8)?.base64EncodedString() else {
                print("failure getting base64String")
                return false
            }
            
            request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            let responseData = try responseHandler(response: response, data: data)
            
            let authResponse = try JSONDecoder().decode(AuthResponseModel.self, from: responseData)
            await MainActor.run {
                self.cacheToken(result:authResponse)
            }
            return true
        } catch {
            print(error)
            return false
        }
    }
    
    
    
    public func refreshTokenIfNeeded() async -> Bool {
        guard let refreshToken = self.refreshToken else {
            return false
        }
        
        do {
            guard shouldRefreshToken else {
                throw URLError(.unknown)
            }   
            
            guard let url = URL(string: apiTokenUrl) else {
                throw URLError(.badURL)
            }
            
            var components = URLComponents()
            components.queryItems = [
                .init(name: "grant_type", value: "refresh_token"),
                .init(name: "refresh_token", value: refreshToken),
            ]
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.httpBody = components.query?.data(using: .utf8)
            
            let basicToken = Constants.clientID + ":" + Constants.clientSecret
            
            guard let base64String = basicToken.data(using: .utf8)?.base64EncodedString() else {
                print("failure getting base64String")
                return false
            }
            
            request.setValue("Basic \(base64String)", forHTTPHeaderField: "Authorization")
            
            let (data, response) = try await URLSession.shared.data(for: request)
            let responseData = try responseHandler(response: response, data: data)
            
            let authResponse = try JSONDecoder().decode(AuthResponseModel.self, from: responseData)
            await MainActor.run {
                self.cacheToken(result:authResponse)
            }
            return true
        } catch {
            print(error)
            return false
        }
        
    }
    
    public func cacheToken(result: AuthResponseModel) {
        UserDefaults.standard.setValue(result.accessToken, forKey: "access_token")
        if let refreshToken = result.refreshToken {
            UserDefaults.standard.setValue(refreshToken, forKey: "refresh_token")
        }
        UserDefaults.standard.setValue(Date().addingTimeInterval(TimeInterval(result.expiresIn)), forKey: "expirationDate")
    }
}






//        return URL(string: "https://accounts.spotify.com/authorize?response_type=code&client_id=\(Constants.clientID)&scope=user-read-private&redirect_uri=https://example.com")
