//
//  RestaurantListTableViewCell.swift
//  WhatsToEat
//
//  Created by Jay on 5/25/20.
//  Copyright © 2020 JayGabriel. All rights reserved.
//

import UIKit

class RestaurantListTableViewCell: UITableViewCell {
    static let reuseIdentifier = String.init(describing: RestaurantListTableViewCell.self)
    
    // MARK: - Properties
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.adjustsFontSizeToFitWidth = true
        label.font = UIFont.systemFont(ofSize: 32, weight: .heavy)
        label.textColor = .white
        return label
    }()
    
    private let kindLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        return label
    }()
    
    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let previewImage: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        return imageView
    }()
    
    private let shaderView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        view.clipsToBounds = true
        view.alpha = 0.38
        view.layer.cornerRadius = 10
        return view
    }()
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        nameLabel.text?.removeAll()
        kindLabel.text?.removeAll()
        previewImage.image = nil
    }
    
    func configure(with viewModel: RestaurantListTableViewCellViewModel) {
        nameLabel.text = viewModel.name
        kindLabel.text = viewModel.kind
        previewImage.imageFromUrl(urlString: viewModel.imageData)
    }
    
    // MARK: - Layout
    
    private func setupView() {
        backgroundColor = .clear
        contentView.addSubview(previewImage)
        contentView.addSubview(shaderView)
        labelStackView.addArrangedSubview(nameLabel)
        labelStackView.addArrangedSubview(kindLabel)
        contentView.addSubview(labelStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            previewImage.leftAnchor.constraint(equalTo: leftAnchor, constant: 10),
            previewImage.rightAnchor.constraint(equalTo: rightAnchor, constant: -10),
            previewImage.topAnchor.constraint(equalTo: topAnchor),
            previewImage.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            labelStackView.centerYAnchor.constraint(equalTo: centerYAnchor),
            labelStackView.leftAnchor.constraint(equalTo: previewImage.leftAnchor, constant: 10),
            labelStackView.rightAnchor.constraint(equalTo: previewImage.rightAnchor, constant: -10),
            
            shaderView.leftAnchor.constraint(equalTo: previewImage.leftAnchor),
            shaderView.rightAnchor.constraint(equalTo: previewImage.rightAnchor),
            shaderView.topAnchor.constraint(equalTo: previewImage.topAnchor),
            shaderView.bottomAnchor.constraint(equalTo: previewImage.bottomAnchor),
        ])
    }
    
    func setHighlightedUI(highlighted: Bool) {
        self.animateAlpha(highlighted: highlighted)
    }
}
