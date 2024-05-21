//
//  AlbumTrackCollectionViewCell.swift
//  Spotify
//
//  Created by Caner Karabulut on 20.05.2024.
//

import UIKit

class AlbumTrackCollectionViewCell: UICollectionViewCell {
    static let identifier = "AlbumTrackCollectionViewCell"
    //MARK: - Properties
    private let trackNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    private let artistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .thin)
        label.numberOfLines = 0
        return label
    }()
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        style()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        trackNameLabel.sizeToFit()
        artistNameLabel.sizeToFit()
        trackNameLabel.frame = CGRect(x: 10, y: 0, width: contentView.width-15, height: contentView.height/2)
        artistNameLabel.frame = CGRect(x: 10, y: contentView.height/2, width: contentView.width-15, height: contentView.height/2)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        trackNameLabel.text = nil
        artistNameLabel.text = nil
    }
}
//MARK: - Helpers
extension AlbumTrackCollectionViewCell {
    private func style() {
        backgroundColor = .secondarySystemBackground
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(trackNameLabel)
        contentView.addSubview(artistNameLabel)
        contentView.clipsToBounds = true
    }
    func configure(with viewModel: AlbumCellViewModel) {
        trackNameLabel.text = viewModel.name
        artistNameLabel.text = viewModel.artistName
    }
}
