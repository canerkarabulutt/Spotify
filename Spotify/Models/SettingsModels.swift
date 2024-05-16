//
//  SettingsModels.swift
//  Spotify
//
//  Created by Caner Karabulut on 29.04.2024.
//

import Foundation

struct Section {
    let title: String
    let options: [Option]
}

struct Option {
    let title: String
    let handler: () -> Void
}
