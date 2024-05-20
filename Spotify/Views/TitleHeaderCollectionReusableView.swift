//
//  TitleHeaderCollectionReusableView.swift
//  Spotify
//
//  Created by Caner Karabulut on 20.05.2024.
//

import UIKit

class TitleHeaderCollectionReusableView: UICollectionReusableView {
    static let identifier = "TitleHeaderCollectionReusableView"
    //MARK: - Properties
    private let label: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 1
        label.font = .systemFont(ofSize: 20, weight: .light)
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
        label.frame = CGRect(x: 15, y: 0, width: width-30, height: height)
    }
}
//MARK: - Helpers
extension TitleHeaderCollectionReusableView {
    private func style() {
        backgroundColor = .systemBackground
        addSubview(label)
    }
    func configure(with title: String) {
        label.text = title
    }
}
