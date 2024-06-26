//
//  LibraryPlaylistsViewController.swift
//  Spotify
//
//  Created by Caner Karabulut on 22.05.2024.
//

import UIKit

class LibraryPlaylistsViewController: UIViewController {
    //MARK: - Properties
    var playlists: [Playlist] = []
    
    private let noPlaylistsView = ActionLabelView()
    
    public var selectionHandler: ((Playlist) -> Void)?
    
    private let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.register(SearchResultSubtitleTableViewCell.self, forCellReuseIdentifier: SearchResultSubtitleTableViewCell.identifier)
        tableView.isHidden = true
        return tableView
    }()
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        style()
        updateUI()
        fetchData()
        
        if selectionHandler != nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didTapClose))
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noPlaylistsView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        noPlaylistsView.center = view.center
        tableView.frame = view.bounds
    }
}
//MARK: - Selectors
extension LibraryPlaylistsViewController {
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
}
//MARK: - Service
extension LibraryPlaylistsViewController {
    private func fetchData() {
        APICaller.shared.getCurrentUserPlaylists { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let playlists):
                    self?.playlists = playlists
                    self?.updateUI()
                case .failure(let error):
                    print(error.localizedDescription)
                }

            }
        }
    }
}
//MARK: - Helpers
extension LibraryPlaylistsViewController {
    private func style() {
        view.backgroundColor = .systemBackground
        view.addSubview(noPlaylistsView)
        noPlaylistsView.configure(with: ActionLabelViewModel(text: "You don't have any playlists yet.", actionTitle: "Create"))
        noPlaylistsView.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    private func updateUI() {
        if playlists.isEmpty {
            noPlaylistsView.isHidden = false
            tableView.isHidden = true
        } else {
            tableView.reloadData()
            noPlaylistsView.isHidden = true
            tableView.isHidden = false
        }
    }
    public func showCreatePlaylistAlert() {
        let alert = UIAlertController(title: "New Playlists", message: "Enter playlist name.", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Playlist..."
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "Create", style: .default, handler: { _ in
            guard let field = alert.textFields?.first,
                  let text = field.text,
                  !text.trimmingCharacters(in: .whitespaces).isEmpty else {
                return
            }
            APICaller.shared.createPlaylist(with: text) { [weak self] success in
                if success {
                    HapticsManager.shared.vibrate(for: .success)
                    self?.fetchData()
                } else {
                    HapticsManager.shared.vibrate(for: .error)
                    print("Failed to create playlist.")
                }
            }
        }))
        present(alert, animated: true)
    }
}
//MARK: - ActionLabelViewDelegate
extension LibraryPlaylistsViewController: ActionLabelViewDelegate {
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        showCreatePlaylistAlert()
    }
}
//MARK: - UITableViewDelegate & UITableViewDataSource
extension LibraryPlaylistsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else { return UITableViewCell() }
        let playlist = playlists[indexPath.row]
        cell.configure(with: SearchResultSubtitleTableViewCellViewModel(title: playlist.name, subtitle: playlist.owner.display_name, imageURL: URL(string: playlist.images?.first?.url ?? "")))
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        let playlist = playlists[indexPath.row]
        guard selectionHandler == nil else {
            selectionHandler?(playlist)
            dismiss(animated: true, completion: nil)
            return
        }
        let vc = PlaylistViewController(playlist: playlist)
        vc.navigationItem.largeTitleDisplayMode = .never
        vc.isOwner = true
        navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
