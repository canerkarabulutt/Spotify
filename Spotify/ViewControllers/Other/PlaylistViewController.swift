//
//  PlaylistViewController.swift
//  Spotify
//
//  Created by Caner Karabulut on 26.04.2024.
//

import UIKit

class PlaylistViewController: UIViewController {
    //MARK: - Properties
    private let playlist: Playlist
    //MARK: - Lifecycle
    init(playlist: Playlist) {
        self.playlist = playlist
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
extension PlaylistViewController {
    private func fetchData() {
        APICaller.shared.getPlaylistDetails(for: playlist) { result in
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
//MARK: - Helpers
extension PlaylistViewController {
    private func style() {
        title = playlist.name
        view.backgroundColor = .systemBackground
    }
}
