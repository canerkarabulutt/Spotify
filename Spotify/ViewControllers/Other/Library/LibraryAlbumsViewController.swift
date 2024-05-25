//
//  LibraryAlbumsViewController.swift
//  Spotify
//
//  Created by Caner Karabulut on 22.05.2024.
//

import UIKit

class LibraryAlbumsViewController: UIViewController {
    //MARK: - Properties
    var albums: [Album] = []
    
    private let noAlbumssView = ActionLabelView()
    
    private var observer: NSObjectProtocol?
    
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
        observer = NotificationCenter.default.addObserver(forName: .albumSavedNotification, object: nil, queue: .main, using: { [weak self] _ in
            self?.fetchData()
        })
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        noAlbumssView.frame = CGRect(x: (view.width-150)/2, y: (view.height-150)/2, width: 150, height: 150)
        tableView.frame = CGRect(x: 0, y: 0, width: view.width, height: view.height)
    }
}
//MARK: - Selectors
extension LibraryAlbumsViewController {
    @objc private func didTapClose() {
        dismiss(animated: true, completion: nil)
    }
}
//MARK: - Service
extension LibraryAlbumsViewController {
    private func fetchData() {
        albums.removeAll()
        APICaller.shared.getCurrentUserAlbums { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let albums):
                    self?.albums = albums
                    self?.updateUI()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
//MARK: - Helpers
extension LibraryAlbumsViewController {
    private func style() {
        view.backgroundColor = .systemBackground
        view.addSubview(noAlbumssView)
        noAlbumssView.configure(with: ActionLabelViewModel(text: "You have not saved any albums yet.", actionTitle: "Browse"))
        noAlbumssView.delegate = self
        
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
    }
    private func updateUI() {
        if albums.isEmpty {
            noAlbumssView.isHidden = false
            tableView.isHidden = true
        } else {
            tableView.reloadData()
            noAlbumssView.isHidden = true
            tableView.isHidden = false
        }
    }
}
//MARK: - ActionLabelViewDelegate
extension LibraryAlbumsViewController: ActionLabelViewDelegate {
    func actionLabelViewDidTapButton(_ actionView: ActionLabelView) {
        tabBarController?.selectedIndex = 0
    }
}
//MARK: - UITableViewDelegate & UITableViewDataSource
extension LibraryAlbumsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultSubtitleTableViewCell.identifier, for: indexPath) as? SearchResultSubtitleTableViewCell else { return UITableViewCell() }
        let albums = albums[indexPath.row]
        cell.configure(with: SearchResultSubtitleTableViewCellViewModel(title: albums.name, subtitle: albums.artists.first?.name ?? "", imageURL: URL(string: albums.images.first?.url ?? "")))
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        HapticsManager.shared.vibrateForSelection()
        let album = albums[indexPath.row]
        let vc = AlbumViewController(album: album)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
}
