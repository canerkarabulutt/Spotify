//
//  Playlist.swift
//  Spotify
//
//  Created by Caner Karabulut on 26.04.2024.
//

import Foundation

struct Playlist: Codable {
    let description: String
    let external_urls: [String : String]
    let id: String
    let name: String
    let owner: User
    let images: [APIImage]
}

