//
//  SavedTracksModel.swift
//  MySpotify
//
//  Created by Muhammadjon Madaminov on 26/09/24.
//

import Foundation


struct SavedShowsResponseModel: Codable {
    let href: String
    let limit: Int
    let next: String?
    let offset: Int
    let previous: String?
    let total: Int
    let items: [SavedShowItem]
}

struct SavedShowItem: Codable {
    let addedAt: String
    let track: TrackModel
    
    enum CodingKeys: String, CodingKey {
        case addedAt = "added_at"
        case track
    }
}
