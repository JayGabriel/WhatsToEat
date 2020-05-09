//
//  SearchView.swift
//  WhatsToEat
//
//  Created by Jay on 5/7/20.
//  Copyright © 2020 JayGabriel. All rights reserved.
//

import Foundation
import UIKit

protocol SearchViewDelegate {
    func didEnterSearch(keyword: String, location: String) -> Void
}

class SearchView: UIView {
    private enum Constants {
        static let expandedHeight: CGFloat = 100
        static let compactHeight: CGFloat = 50
        static let backgroundColor = UIColor(red: 207/255, green: 78/255, blue: 222/255, alpha: 1)
    }
    
    // MARK: - Properties
    
    var delegate: SearchViewDelegate?
    
    public private(set) var keywordText = ""
    public private(set) var locationText = ""
    
    private let compactTextButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(expand), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Find something to eat...", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        return button
    }()
    
    private let textFieldStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.backgroundColor = Constants.backgroundColor
        stackView.isHidden = true
        return stackView
    }()
    
    private lazy var keywordTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .alphabet
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Type (e.g. \"Ramen\" or \"Burgers\")"
        textField.textColor = .white
        textField.backgroundColor = Constants.backgroundColor
        textField.delegate = self
        return textField
    }()
    
    private lazy var locationTextField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.keyboardType = .alphabet
        textField.autocorrectionType = .no
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "Location"
        textField.textColor = .white
        textField.backgroundColor = Constants.backgroundColor
        textField.delegate = self
        return textField
    }()
    
    private var isExpanded = false
    
    private var heightConstraint: NSLayoutConstraint?
    
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
    
    private func setupView() {
        backgroundColor = Constants.backgroundColor
        
        addSubview(compactTextButton)
        addSubview(textFieldStackView)
        textFieldStackView.addArrangedSubview(keywordTextField)
        textFieldStackView.addArrangedSubview(locationTextField)
    }
        
    private func setupConstraints() {
        heightConstraint = heightAnchor.constraint(equalToConstant: Constants.compactHeight)
        heightConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            compactTextButton.leftAnchor.constraint(equalTo: leftAnchor, constant: 0),
            compactTextButton.rightAnchor.constraint(equalTo: rightAnchor, constant: 0),
            compactTextButton.topAnchor.constraint(equalTo: topAnchor),
            compactTextButton.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            textFieldStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20),
            textFieldStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20),
            textFieldStackView.topAnchor.constraint(equalTo: topAnchor),
            textFieldStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    @objc func expand() {
        isExpanded = true
        
        heightConstraint?.constant = Constants.expandedHeight
        self.textFieldStackView.alpha = 0
        self.textFieldStackView.isHidden = false
        
        UIView.animate(
            withDuration: 0.2,
            delay: 0.0,
            options: .curveEaseInOut,
            animations: {
                self.superview?.layoutIfNeeded()
                self.compactTextButton.alpha = 0
                self.textFieldStackView.alpha = 1
            },
            completion: { _ in
                self.compactTextButton.isHidden = true
                self.keywordTextField.becomeFirstResponder()
            }
        )
        compactTextButton.isHidden = true
        textFieldStackView.isHidden = false
    }
    
    func contract() {
        isExpanded = false

        keywordTextField.resignFirstResponder()
        locationTextField.resignFirstResponder()
        
        heightConstraint?.constant = Constants.compactHeight
        compactTextButton.isHidden = false
        compactTextButton.alpha = 0

        UIView.animate(
            withDuration: 0.2,
            delay: 0.0,
            options: .curveEaseInOut,
            animations: {
                self.superview?.layoutIfNeeded()
                self.compactTextButton.alpha = 1
                self.textFieldStackView.alpha = 0
            },
            completion: { _ in
                self.textFieldStackView.isHidden = true
            }
        )
    }
}

extension SearchView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            guard
                let keywordText = keywordTextField.text,
                let locationText = locationTextField.text,
                !keywordText.isEmpty,
                !locationText.isEmpty else { return false }
            self.contract()
            
            compactTextButton.setTitle("\(keywordText) in \(locationText)", for: .normal)
            self.delegate?.didEnterSearch(keyword: keywordText, location: locationText)
        }
        
        return true
    }
}
