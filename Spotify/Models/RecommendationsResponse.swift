//
//  RecommendationsResponse.swift
//  Spotify
//
//  Created by Caner Karabulut on 17.05.2024.
//

import Foundation

struct RecommendationsResponse: Codable {
    let tracks: [AudioTrack]
}
