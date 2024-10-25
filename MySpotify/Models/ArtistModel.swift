//
//  ArtistModel.swift
//  MySpotify
//
//  Created by Muhammadjon Madaminov on 15/10/24.
//

import Foundation


struct ArtistModel: Codable {
    let externalUrls: ExternalUrls
    let href: String
    let id: String
    let name: String
    let type: String
    let uri: String

    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case href
        case id
        case name
        case type
        case uri
    }
}
