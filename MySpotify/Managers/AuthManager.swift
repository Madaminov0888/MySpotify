//
//  AuthManager.swift
//  MySpotify
//
//  Created by Muhammadjon Madaminov on 16/07/24.
//

import Foundation


final class AuthManager {
    static let shared = AuthManager()
    
    
    struct Constants {
        static let clientID = "9e67a49a6ac243bab80e0b152e48d956"
        static let clientSecret = "604b80a58ab2478d9eaad17ad5443d78"
    }
    
    
    private init() {}
    
    var isSignedIn: Bool {
        return false
    }
    
    private var accessToken: String? {
        return nil
    }
    
    private var refreshToken: String? {
        return nil
    }
    
    
    private var tokenExpirationDate: Date? {
        return nil
    }
    
    private var shouldRefreshToken: Bool {
        return false
    }
}
