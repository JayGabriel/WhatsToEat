//
//  ToolbarView.swift
//  WhatsToEat
//
//  Created by Jay on 6/3/20.
//  Copyright © 2020 JayGabriel. All rights reserved.
//

import UIKit

protocol ToolbarViewDelegate {
    func didTapRefreshButton() -> Void
    func didTapRandomButton() -> Void
    func didTapListButton() -> Void
    func didTapMapButton() -> Void
}

class ToolbarView: UIView {
    private enum Constants {
        static let raisedOffset: CGFloat = UIDevice().hasBottomSafeAreaInset ? 30.0 : 0.0
        static let buttonColor = UIColor(red: 207/255, green: 78/255, blue: 222/255, alpha: 1)
        static let shadowColor: CGColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        static let shadowOffset: CGSize = CGSize(width: 0.0, height: 5.0)
        static let shadowOpacity: Float = 0.75
        static let shadowRadius: CGFloat = 10.0
    }
    
    // MARK: - Properties
    
    var delegate: ToolbarViewDelegate?
    
    private(set) var isEditing: Bool = false
    
    private var showsMapIcon: Bool = false
    
    private lazy var toggleViewButton: UIButton = {
        let toggleViewButton = UIButton(type: .system)
        toggleViewButton.translatesAutoresizingMaskIntoConstraints = false
        toggleViewButton.setImage(Images.listIcon, for: .normal)
        toggleViewButton.backgroundColor = Constants.buttonColor
        toggleViewButton.tintColor = .white
        toggleViewButton.addTarget(self, action: #selector(didTapToggleViewButton), for: .touchUpInside)
        return toggleViewButton
    }()
    
    private lazy var randomButton: UIButton = {
        let searchButton = UIButton(type: .system)
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        searchButton.setImage(Images.randomIcon, for: .normal)
        searchButton.tintColor = .white
        searchButton.backgroundColor = Constants.buttonColor
        searchButton.addTarget(self, action: #selector(didTapRandomButton), for: .touchUpInside)
        return searchButton
    }()
    
    private lazy var refreshButton: UIButton = {
        let refreshButton = UIButton(type: .system)
        refreshButton.translatesAutoresizingMaskIntoConstraints = false
        refreshButton.setImage(Images.refreshIcon, for: .normal)
        refreshButton.backgroundColor = Constants.buttonColor
        refreshButton.tintColor = .white
        refreshButton.addTarget(self, action: #selector(didTapRefreshButton), for: .touchUpInside)
        return refreshButton
    }()
    
    private let buttonsStackView: UIStackView = {
        let buttonsStackView = UIStackView()
        buttonsStackView.translatesAutoresizingMaskIntoConstraints = false
        buttonsStackView.axis = .horizontal
        buttonsStackView.alignment = .fill
        buttonsStackView.distribution = .fillEqually
        return buttonsStackView
    }()    
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
        setupNotifications()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
    
    private func setupView() {
        buttonsStackView.addArrangedSubview(generateContainer(toggleViewButton))
        buttonsStackView.addArrangedSubview(generateContainer(randomButton))
        buttonsStackView.addArrangedSubview(generateContainer(refreshButton))
        addSubview(buttonsStackView)

        toggleViewButton.addShadow(color: Constants.shadowColor,
                               offset: Constants.shadowOffset,
                               opacity: Constants.shadowOpacity,
                               radius: Constants.shadowRadius)
        
        randomButton.addShadow(color: Constants.shadowColor,
                               offset: Constants.shadowOffset,
                               opacity: Constants.shadowOpacity,
                               radius: Constants.shadowRadius)
        
        refreshButton.addShadow(color: Constants.shadowColor,
                               offset: Constants.shadowOffset,
                               opacity: Constants.shadowOpacity,
                               radius: Constants.shadowRadius)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            buttonsStackView.leftAnchor.constraint(equalTo: leftAnchor),
            buttonsStackView.rightAnchor.constraint(equalTo: rightAnchor),
            buttonsStackView.topAnchor.constraint(equalTo: topAnchor),
            buttonsStackView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    private func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func generateContainer(_ subview: UIView) -> UIView {
        let circleView = UIView()
        circleView.translatesAutoresizingMaskIntoConstraints = false
        circleView.addSubview(subview)
        NSLayoutConstraint.activate([
            subview.heightAnchor.constraint(equalTo: circleView.heightAnchor),
            subview.widthAnchor.constraint(equalTo: circleView.heightAnchor),
            subview.centerXAnchor.constraint(equalTo: circleView.centerXAnchor),
            subview.centerYAnchor.constraint(equalTo: circleView.centerYAnchor)
        ])
        return circleView
    }
    
    override func layoutSubviews() {
        randomButton.layer.cornerRadius = randomButton.bounds.height / 2
        toggleViewButton.layer.cornerRadius = toggleViewButton.frame.height / 2
        refreshButton.layer.cornerRadius = refreshButton.frame.height / 2
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            let keyboardHeight = keyboardRectangle.height
            animateToolbar(to: keyboardHeight)
        }
        isEditing = true
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        animateToolbar(to: 0.0)
        isEditing = false
    }
    
    private func animateToolbar(to height: CGFloat) {
        UIView.animate(
            withDuration: 0.2,
            delay: 0.0,
            options: [.curveEaseInOut],
            animations: {
                if height == 0.0 {
                    self.transform = .identity
                } else {
                    self.transform = CGAffineTransform(translationX: 0, y: -height + Constants.raisedOffset)
                }
            }
        )
    }
    
    // MARK: - Actions
    
    @objc private func didTapRandomButton() {
        delegate?.didTapRandomButton()
    }
        
    @objc private func didTapRefreshButton() {
        delegate?.didTapRefreshButton()
    }
    
    @objc private func didTapToggleViewButton() {
        if showsMapIcon {
            toggleViewButton.setImage(Images.listIcon, for: .normal)
            delegate?.didTapMapButton()
            showsMapIcon = false
        } else {
            toggleViewButton.setImage(Images.mapIcon, for: .normal)
            delegate?.didTapListButton()
            showsMapIcon = true
        }
    }
}
