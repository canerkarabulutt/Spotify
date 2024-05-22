//
//  LibraryAlbumsViewController.swift
//  Spotify
//
//  Created by Caner Karabulut on 22.05.2024.
//

import UIKit

class LibraryAlbumsViewController: UIViewController {
    //MARK: - Properties
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
    }
}
//MARK: - Helpers
extension LibraryAlbumsViewController {
    private func style() {
        view.backgroundColor = .systemGreen
    }
}
