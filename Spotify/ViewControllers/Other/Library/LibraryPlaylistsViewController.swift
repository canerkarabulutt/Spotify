//
//  LibraryPlaylistsViewController.swift
//  Spotify
//
//  Created by Caner Karabulut on 22.05.2024.
//

import UIKit

class LibraryPlaylistsViewController: UIViewController {
    //MARK: - Properties
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
    }
}
//MARK: - Helpers
extension LibraryPlaylistsViewController {
    private func style() {
        view.backgroundColor = .systemPink
    }
}
