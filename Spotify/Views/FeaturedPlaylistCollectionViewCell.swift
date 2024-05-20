//
//  FeaturedPlaylistCollectionViewCell.swift
//  Spotify
//
//  Created by Caner Karabulut on 17.05.2024.
//

import UIKit

class FeaturedPlaylistCollectionViewCell: UICollectionViewCell {
    static let identifier = "FeaturedPlaylistCollectionViewCell"
    //MARK: - Properties
    private let playlistCoverImage: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 4
        imageView.image = UIImage(systemName: "photo")
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private let playlistNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()
    private let creatorNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15, weight: .thin)
        label.textAlignment = .center
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
        playlistCoverImage.sizeToFit()
        playlistNameLabel.sizeToFit()
        creatorNameLabel.sizeToFit()
        
        let imageSize = contentView.height-66
        playlistCoverImage.frame = CGRect(x: (contentView.width-imageSize)/2, y: 5, width: imageSize, height: imageSize)
        playlistNameLabel.frame = CGRect(x: 3, y: contentView.height-60, width: contentView.width-6, height: 40)
        creatorNameLabel.frame = CGRect(x: 3, y: contentView.height-32, width: contentView.width-6, height: 40)
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        playlistCoverImage.image = nil
        playlistNameLabel.text = nil
        creatorNameLabel.text = nil
    }
}
//MARK: - Helpers
extension FeaturedPlaylistCollectionViewCell {
    private func style() {
        contentView.backgroundColor = .secondarySystemBackground
        contentView.addSubview(playlistCoverImage)
        contentView.addSubview(playlistNameLabel)
        contentView.addSubview(creatorNameLabel)
        contentView.clipsToBounds = true
    }
    func configure(with viewModel: FeaturedPlaylistCellViewModel) {
        playlistCoverImage.sd_setImage(with: viewModel.artworkURL, completed: nil)
        playlistNameLabel.text = viewModel.name
        creatorNameLabel.text = viewModel.creatorName
    }
}
