//
//  AboutViewController.swift
//  WhatsToEat
//
//  Created by Jay on 8/18/20.
//  Copyright © 2020 JayGabriel. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    private enum Constants {
        static let yelpURL = "https://www.yelp.com"
        static let icons8URL = "https://icons8.com"
        static let githubURL = "https://github.com/JayGabriel/WhatsToEat"
        
        static let backgroundColor: UIColor = .white
        
        static let contentStackViewLeading: CGFloat = 10.0
        static let contentStackViewTrailing: CGFloat = -10.0
        static let paddingViewHeight: CGFloat = 20.0
        static let buttonHeight: CGFloat = 60.0
        
        static let subviewContainerLeading: CGFloat = 5
        static let subviewContainerTrailing: CGFloat = -5
        static let subviewContainerTop: CGFloat = 5
        static let subviewContainerBottom: CGFloat = -5
    }
    
    // MARK: - Properties
    
    // MARK: UI Elements
    
    private let contentStackView: UIStackView = {
        let contentStackView = UIStackView()
        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.axis = .vertical
        contentStackView.alignment = .fill
        contentStackView.distribution = .fill
        contentStackView.spacing = 10
        return contentStackView
    }()
    
    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "WhatsToEat"
        titleLabel.font = UIFont.systemFont(ofSize: 30, weight: .bold)
        titleLabel.textColor = .black
        titleLabel.textAlignment = .center
        return titleLabel
    }()
        
    private let authorLabel: UILabel = {
        let authorLabel = UILabel()
        authorLabel.translatesAutoresizingMaskIntoConstraints = false
        authorLabel.text = "Copyright © 2020 Jay Gabriel"
        authorLabel.font = UIFont.systemFont(ofSize: 20, weight: .light)
        authorLabel.textColor = .black
        authorLabel.textAlignment = .center
        return authorLabel
    }()
    
    private let paddingView: UIView = {
        let paddingView = UIView()
        paddingView.translatesAutoresizingMaskIntoConstraints = false
        return paddingView
    }()
    
    private lazy var yelpButton: AnimatedButton = {
        let yelpLabel = AnimatedButton()
        yelpLabel.translatesAutoresizingMaskIntoConstraints = false
        yelpLabel.addTarget(self, action: #selector(yelpButtonTapped), for: .touchUpInside)
        yelpLabel.setTitle(" Business data provided by Yelp ", for: .normal)
        yelpLabel.setImage(.yelpIcon, for: .normal)
        yelpLabel.setTitleColor(.white, for: .normal)
        yelpLabel.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        yelpLabel.titleLabel?.textAlignment = .center
        yelpLabel.backgroundColor = .YelpBrand
        yelpLabel.layer.cornerRadius = 10
        return yelpLabel
    }()
    
    private lazy var icons8Button: AnimatedButton = {
        let icons8Label = AnimatedButton()
        icons8Label.translatesAutoresizingMaskIntoConstraints = false
        icons8Label.addTarget(self, action: #selector(icons8ButtonTapped), for: .touchUpInside)
        icons8Label.setTitle(" Icons provided by Icons8 ", for: .normal)
        icons8Label.setImage(.icons8Icon, for: .normal)
        icons8Label.setTitleColor(.white, for: .normal)
        icons8Label.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        icons8Label.titleLabel?.textAlignment = .center
        icons8Label.backgroundColor = .Icons8Brand
        icons8Label.layer.cornerRadius = 10
        return icons8Label
    }()
    
    private lazy var githubButton: AnimatedButton = {
        let githubButton = AnimatedButton()
        githubButton.translatesAutoresizingMaskIntoConstraints = false
        githubButton.addTarget(self, action: #selector(githubButtonTapped), for: .touchUpInside)
        githubButton.setTitle(" View source code on GitHub ", for: .normal)
        githubButton.setImage(.githubIcon, for: .normal)
        githubButton.setTitleColor(.white, for: .normal)
        githubButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        githubButton.titleLabel?.textAlignment = .center
        githubButton.backgroundColor = .GitHubBrand
        githubButton.layer.cornerRadius = 10
        return githubButton
    }()
        
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        setupView()
        setupConstraints()
    }
    
    // MARK: - Layout
    
    private func setupView() {
        view.backgroundColor = Constants.backgroundColor
        
        navigationController?.navigationBar.tintColor = .white
        
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(authorLabel)
        contentStackView.addArrangedSubview(paddingView)
        contentStackView.addArrangedSubview(generateContainer(yelpButton))
        contentStackView.addArrangedSubview(generateContainer(icons8Button))
        contentStackView.addArrangedSubview(generateContainer(githubButton))
        
        view.addSubview(contentStackView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            contentStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.contentStackViewLeading),
            contentStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.contentStackViewTrailing),
            contentStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            paddingView.heightAnchor.constraint(equalToConstant: Constants.paddingViewHeight),
            yelpButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            icons8Button.heightAnchor.constraint(equalToConstant: Constants.buttonHeight),
            githubButton.heightAnchor.constraint(equalToConstant: Constants.buttonHeight)
        ])
    }
    
    private func generateContainer(_ subView: UIView) -> UIView {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(subView)
        NSLayoutConstraint.activate([
            subView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: Constants.subviewContainerLeading),
            subView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: Constants.subviewContainerTrailing),
            subView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: Constants.subviewContainerTop),
            subView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: Constants.subviewContainerBottom),
        ])
        return containerView
    }
    
    // MARK: - Actions
    
    @objc private func yelpButtonTapped() {
        if let mediaURL = URL(string: Constants.yelpURL), UIApplication.shared.canOpenURL(mediaURL) {
            UIApplication.shared.open(mediaURL)
        }
    }
    
    @objc private func icons8ButtonTapped() {
        if let mediaURL = URL(string: Constants.icons8URL), UIApplication.shared.canOpenURL(mediaURL) {
            UIApplication.shared.open(mediaURL)
        }
    }
    
    @objc private func githubButtonTapped() {
        if let mediaURL = URL(string: Constants.githubURL), UIApplication.shared.canOpenURL(mediaURL) {
            UIApplication.shared.open(mediaURL)
        }
    }
}
