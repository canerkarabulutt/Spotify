//
//  SearchResultSubtitleTableViewCell.swift
//  Spotify
//
//  Created by Caner Karabulut on 21.05.2024.
//

import Foundation
import SDWebImage

class SearchResultSubtitleTableViewCell: UITableViewCell {
    static let identifier = "SearchResultSubtitleTableViewCell"
    //MARK: - Properties
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        return label
    }()
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 1
        return label
    }()
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        let imageSize: CGFloat = contentView.height-10
        iconImageView.frame = CGRect(x: 10, y: 0, width: imageSize, height: imageSize)
        iconImageView.layer.cornerRadius = imageSize/2
        iconImageView.layer.masksToBounds = true
        
        let labelHeight = contentView.height/2
        
        label.frame = CGRect(x: iconImageView.right+10, y: 0, width: contentView.width-iconImageView.right-15, height: labelHeight)
        subtitleLabel.frame = CGRect(x: iconImageView.right+10, y: label.bottom, width: contentView.width-iconImageView.right-15, height: labelHeight)

    }
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        label.text = nil
        subtitleLabel.text = nil
    }
}
//MARK: - Helpers
extension SearchResultSubtitleTableViewCell {
    private func setup() {
        contentView.addSubview(iconImageView)
        contentView.addSubview(label)
        contentView.addSubview(subtitleLabel)
        contentView.clipsToBounds = true
        accessoryType = .disclosureIndicator
    }
    func configure(with viewModel: SearchResultSubtitleTableViewCellViewModel) {
        iconImageView.sd_setImage(with: viewModel.imageURL, placeholderImage: UIImage(systemName: "photo"), completed: nil)
        label.text = viewModel.title
        subtitleLabel.text = viewModel.subtitle
    }
}
