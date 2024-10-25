//
//  TrackModel.swift
//  MySpotify
//
//  Created by Muhammadjon Madaminov on 15/10/24.
//

import Foundation


struct TrackModel: Codable {
    let artists: [ArtistModel]
    let availableMarkets: [String]
    let discNumber: Int
    let durationMs: Int
    let explicit: Bool
    let externalUrls: ExternalUrls
    let href: String
    let id: String
    let isPlayable: Bool?
    let name: String
    let previewUrl: String?
    let trackNumber: Int
    let type: String
    let uri: String

    enum CodingKeys: String, CodingKey {
        case artists
        case availableMarkets = "available_markets"
        case discNumber = "disc_number"
        case durationMs = "duration_ms"
        case explicit
        case externalUrls = "external_urls"
        case href
        case id
        case isPlayable = "is_playable"
        case name
        case previewUrl = "preview_url"
        case trackNumber = "track_number"
        case type
        case uri
    }
}
