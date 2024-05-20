//
//  AlbumViewController.swift
//  Spotify
//
//  Created by Caner Karabulut on 20.05.2024.
//

import UIKit

class AlbumViewController: UIViewController {
    //MARK: - Properties
    private let album: Album
    //MARK: - Lifecycle
    init(album: Album) {
        self.album = album
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        fetchData()
    }
}
//MARK: - Service
extension AlbumViewController {
    private func fetchData() {
        APICaller.shared.getAlbumDetails(for: album) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let model):
                    break
                case .failure(let error):
                    break
                }
            }
        }
    }
}
//MARK: - Lifecycle
extension AlbumViewController {
    private func style() {
        title = album.name
        view.backgroundColor = .systemBackground
    }
}
