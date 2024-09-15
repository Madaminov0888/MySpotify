//
//  UserProfile.swift
//  MySpotify
//
//  Created by Muhammadjon Madaminov on 05/09/24.
//

import Foundation


import Foundation

struct UserProfile: Codable {
    let country: String
    let displayName: String
    let email: String?  
    let explicitContent: ExplicitContent
    let externalUrls: ExternalUrls
    let followers: Followers
    let href: String
    let id: String
    let images: [Image]
    let product: String
    let type: String
    let uri: String

    enum CodingKeys: String, CodingKey {
        case country
        case displayName = "display_name"
        case email
        case explicitContent = "explicit_content"
        case externalUrls = "external_urls"
        case followers
        case href
        case id
        case images
        case product
        case type
        case uri
    }
}

struct ExplicitContent: Codable {
    let filterEnabled: Bool
    let filterLocked: Bool

    enum CodingKeys: String, CodingKey {
        case filterEnabled = "filter_enabled"
        case filterLocked = "filter_locked"
    }
}

struct ExternalUrls: Codable {
    let spotify: String
}

struct Followers: Codable {
    let href: String?
    let total: Int
}

struct Image: Codable {
    let url: String
    let height: Int?
    let width: Int?
}
