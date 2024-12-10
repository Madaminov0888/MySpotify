//
//  AlbumsModel.swift
//  MySpotify
//
//  Created by Muhammadjon Madaminov on 26/09/24.
//

import Foundation

struct SavedAlbumsResponseModel: Codable {
    let href: String
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
    let items: [SavedAlbumModel]
}

struct SavedAlbumModel: Codable {
    let addedAt: String  // Timestamp when the album was saved
    let album: AlbumModel

    enum CodingKeys: String, CodingKey {
        case addedAt = "added_at"
        case album
    }
}



struct AlbumModel: Codable, UserFeatProtocol {
    let albumType: String
    let artists: [ArtistModel]
    let availableMarkets: [String]
    let externalUrls: ExternalUrls
    let href: String
    let id: String
    let images: [PlaylistImage]
    let name: String
    let releaseDate: String
    let totalTracks: Int
    let type: String
    let uri: String

    enum CodingKeys: String, CodingKey {
        case albumType = "album_type"
        case artists
        case availableMarkets = "available_markets"
        case externalUrls = "external_urls"
        case href
        case id
        case images
        case name
        case releaseDate = "release_date"
        case totalTracks = "total_tracks"
        case type
        case uri
    }
}


struct AlbumTracksModel: Codable {
    let href: String
    let items: [TrackModel]
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
}
