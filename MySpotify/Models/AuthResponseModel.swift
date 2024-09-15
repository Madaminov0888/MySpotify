//
//  AuthResponseModel.swift
//  MySpotify
//
//  Created by Muhammadjon Madaminov on 21/08/24.
//

import Foundation


struct AuthResponseModel: Codable {
    let accessToken: String
    let expiresIn: Int
    let refreshToken: String?
    let scope: String
    let tokenType: String
    
    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case expiresIn = "expires_in"
        case refreshToken = "refresh_token"
        case scope = "scope"
        case tokenType = "token_type"
    }
}
