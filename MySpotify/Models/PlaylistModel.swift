//
//  PlaylistModel.swift
//  MySpotify
//
//  Created by Muhammadjon Madaminov on 13/09/24.
//

import Foundation




protocol UserFeatProtocol: Codable, Identifiable {
    var id: String { get }
    var name: String { get }
    var images: [PlaylistImage] { get }
}


struct PlaylistResponseModel: Codable {
    let href: String
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
    let items: [PlaylistModel]
}


struct FeaturedPlaylistResponseModel: Codable {
    let message: String
    let playlists: FeaturedPlaylistsModel
}



struct FeaturedPlaylistsModel: Codable {
    let href: String
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
    let items: [PlaylistModel]
}




struct PlaylistModel: Codable, UserFeatProtocol {
    let collaborative: Bool
    let description: String
    let externalUrls: ExternalUrls
    let href: String
    let id: String
    let images: [PlaylistImage]
    let name: String
    let owner: UserProfile
    let isPublic: Bool
    let snapshotId: String
    let tracks: PlaylistTracks
    let type: String
    let uri: String
    
    enum CodingKeys: String, CodingKey {
        case collaborative
        case description
        case externalUrls = "external_urls"
        case href
        case id
        case images
        case name
        case owner
        case isPublic = "public"
        case snapshotId = "snapshot_id"
        case tracks
        case type
        case uri
    }
}



struct PlaylistImage: Codable {
    let url: String
    let height: Int?
    let width: Int?
}


struct PlaylistTracks: Codable {
    let href: String
    let total: Int
}



struct LikedSongs: Codable, UserFeatProtocol {
    var images: [PlaylistImage]
    
    let id: String
    let name: String
}
