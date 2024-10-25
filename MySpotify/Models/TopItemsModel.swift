//
//  TopItemsModel.swift
//  MySpotify
//
//  Created by Muhammadjon Madaminov on 15/10/24.
//

import Foundation


import Foundation

struct TopArtistResponseModel: Codable {
    let href: String
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
    let items: [TopArtistModel]
}



struct TopArtistModel: Codable {
    let externalUrls: ExternalUrls
    let followers: Followers
    let genres: [String]
    let href: String
    let id: String
    let images: [PlaylistImage]
    let name: String
    let popularity: Int
    let type: String
    let uri: String

    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case followers
        case genres
        case href
        case id
        case images
        case name
        case popularity
        case type
        case uri
    }
}
