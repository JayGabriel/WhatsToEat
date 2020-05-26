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
    func didEnterSearch(keyword: String, location: String?) -> Void
}

class SearchView: UIView {
    private enum Constants {
        static let expandedHeight: CGFloat = 100
        static let compactHeight: CGFloat = 50
        static let backgroundColor: UIColor = UIColor(red: 207/255, green: 78/255, blue: 222/255, alpha: 1)
        
        static let shadowColor: CGColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        static let shadowOffset: CGSize = CGSize(width: 0.0, height: 5.0)
        static let shadowOpacity: Float = 0.5
        static let shadowRadius: CGFloat = 10.0
    }
    
    // MARK: - Properties
    
    var delegate: SearchViewDelegate?
    
    var keywordText: String = "Find something to eat" {
        didSet {
            keywordTextField.text = keywordText
            self.updateCompactTitle()
        }
    }
    
    var locationText: String = "" {
        didSet {
            locationTextField.text = locationText
            self.updateCompactTitle()
        }
    }
    
    var isEditing: Bool {
        return keywordTextField.isFirstResponder || locationTextField.isFirstResponder
    }
    
    private var previousSearchValue: String? = nil
    
    private let compactTextButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(expand), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        button.setTitle("Find something to eat...", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
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
        textField.placeholder = "What kind of food?"
        textField.font = UIFont.systemFont(ofSize: 22, weight: .heavy)
        textField.textAlignment = .center
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
        textField.placeholder = "Where to search?"
        textField.font = UIFont.systemFont(ofSize: 21, weight: .light)
        textField.textAlignment = .center
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
        
        addShadow(color: Constants.shadowColor,
                  offset: Constants.shadowOffset,
                  opacity: Constants.shadowOpacity,
                  radius: Constants.shadowRadius)
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
    
    private func updateCompactTitle() {
        compactTextButton.setTitle("\(keywordText) in \(locationText)", for: .normal)
    }
    
    @objc func expand() {
        isExpanded = true
        
        heightConstraint?.constant = Constants.expandedHeight
        self.textFieldStackView.alpha = 0
        self.textFieldStackView.isHidden = false
        
        DispatchQueue.main.async {
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
        }
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

        DispatchQueue.main.async {
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
}

extension SearchView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == "\n" {
            guard
                let keywordText = keywordTextField.text,
                !keywordText.isEmpty else {
                    return false
            }
            self.contract()
            self.updateCompactTitle()
            self.delegate?.didEnterSearch(keyword: keywordText, location: locationTextField.text)
        }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text != nil {
            previousSearchValue = textField.text
            textField.text?.removeAll()
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text == nil || textField.text!.isEmpty {
            textField.text = previousSearchValue
        }
    }
}
