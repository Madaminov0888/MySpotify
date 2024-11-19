//
//  TrackResponseModel.swift
//  MySpotify
//
//  Created by Muhammadjon Madaminov on 25/10/24.
//

import Foundation

import Foundation

// Root model representing the entire JSON response
struct PlaylistTracksResponse: Codable {
    let href: String
    let items: [PlaylistTrackItem]
}

// Model representing an item in the playlist's tracks
struct PlaylistTrackItem: Codable {
    let addedAt: String
    let addedBy: User
    let isLocal: Bool
    let primaryColor: String?
    let track: Track
    let videoThumbnail: VideoThumbnail?

    enum CodingKeys: String, CodingKey {
        case addedAt = "added_at"
        case addedBy = "added_by"
        case isLocal = "is_local"
        case primaryColor = "primary_color"
        case track
        case videoThumbnail = "video_thumbnail"
    }
}

// Model representing the user who added the track
struct User: Codable {
    let externalUrls: ExternalURL
    let href: String
    let id: String
    let type: String
    let uri: String

    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case href, id, type, uri
    }
}

// Model representing the track details
struct Track: Codable {
    let previewUrl: String?
    let isPlayable: Bool?     // Made optional to handle missing keys
    let explicit: Bool
    let type: String
    let album: Album?
    let artists: [Artist]
    let discNumber: Int
    let trackNumber: Int
    let durationMs: Int
    let externalIds: ExternalID
    let externalUrls: ExternalURL
    let href: String
    let id: String
    let name: String
    let popularity: Int
    let uri: String
    let isLocal: Bool

    enum CodingKeys: String, CodingKey {
        case previewUrl = "preview_url"
        case isPlayable = "is_playable"
        case explicit, type, album, artists
        case discNumber = "disc_number"
        case trackNumber = "track_number"
        case durationMs = "duration_ms"
        case externalIds = "external_ids"
        case externalUrls = "external_urls"
        case href, id, name, popularity, uri
        case isLocal = "is_local"
    }
}

// Model for the album details
struct Album: Codable {
    let isPlayable: Bool?
    let type: String
    let albumType: String
    let href: String
    let id: String
    let images: [AlbumImage]
    let name: String
    let releaseDate: String?
    let releaseDatePrecision: String?
    let uri: String
    let artists: [Artist]
    let externalUrls: ExternalURL
    let totalTracks: Int

    enum CodingKeys: String, CodingKey {
        case isPlayable = "is_playable"
        case type
        case albumType = "album_type"
        case href, id, images, name
        case releaseDate = "release_date"
        case releaseDatePrecision = "release_date_precision"
        case uri, artists
        case externalUrls = "external_urls"
        case totalTracks = "total_tracks"
    }
}

// Model for an artist
struct Artist: Codable {
    let externalUrls: ExternalURL
    let href: String
    let id: String
    let name: String?
    let type: String
    let uri: String

    enum CodingKeys: String, CodingKey {
        case externalUrls = "external_urls"
        case href, id, name, type, uri
    }
}

// Model for an album image
struct AlbumImage: Codable {
    let height: Int
    let url: String
    let width: Int
}

// Model for external URLs
struct ExternalURL: Codable {
    let spotify: String
}

// Model for external IDs
struct ExternalID: Codable {
    let isrc: String?
}

// Model for video thumbnail, can be optional
struct VideoThumbnail: Codable {
    let url: String?
}
