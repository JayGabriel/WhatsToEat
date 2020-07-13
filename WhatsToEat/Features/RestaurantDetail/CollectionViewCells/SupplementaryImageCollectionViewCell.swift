//
//  SupplementaryImageCollectionViewCell.swift
//  WhatsToEat
//
//  Created by Jay on 6/26/20.
//  Copyright © 2020 JayGabriel. All rights reserved.
//

import UIKit

class SupplementaryImageCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String.init(describing: SupplementaryImageCollectionViewCell.self)
    
    // MARK: - Properties
    
    override var isHighlighted: Bool {
        didSet {
            animateHighlighted()
        }
    }
    
    private lazy var photoImageView: UIImageView = {
        let photoImageView = UIImageView()
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.clipsToBounds = true
        photoImageView.contentMode = .scaleAspectFill
        return photoImageView
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    func configure(with viewModel: SupplementaryImageCollectionViewCellViewModel) {
        photoImageView.image = UIImage(data: viewModel.imageData)
    }
    
    private func setupView() {
        contentView.addSubview(photoImageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            photoImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func animateHighlighted() {
        self.animateAlpha(highlighted: isHighlighted)
    }
}
