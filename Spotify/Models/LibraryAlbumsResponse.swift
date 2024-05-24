//
//  LibraryAlbumsResponse.swift
//  Spotify
//
//  Created by Caner Karabulut on 23.05.2024.
//

import Foundation

struct LibraryAlbumsResponse: Codable {
    let items: [SavedAlbum]
}

struct SavedAlbum: Codable {
    let added_at: String
    let album: Album
}
