//
//  PhotoDetailViewController.swift
//  WhatsToEat
//
//  Created by Jay on 6/26/20.
//  Copyright © 2020 JayGabriel. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController {
    
    // MARK: - Properties
    
    private let photoImageView: UIImageView = {
        let photoImageView = UIImageView()
        photoImageView.translatesAutoresizingMaskIntoConstraints = false
        photoImageView.clipsToBounds = true
        photoImageView.contentMode = .scaleAspectFit
        return photoImageView
    }()
    
    private lazy var dismissGesture: UITapGestureRecognizer = {
        let dismissGesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        return dismissGesture
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        view.alpha = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
        animateTransition(willAppear: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        animateTransition(willAppear: false)
    }
    
    func setImage(_ image: UIImage?) {
        self.photoImageView.image = image
    }
    
    // MARK: - Layout
    
    private func setupView() {
        view.backgroundColor = .black
        view.addGestureRecognizer(dismissGesture)
        view.addSubview(photoImageView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            photoImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            photoImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            photoImageView.topAnchor.constraint(equalTo: view.topAnchor),
            photoImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    @objc func dismissView() {
        animateTransition(willAppear: false)
    }
    
    private func animateTransition(willAppear: Bool) {
        DispatchQueue.main.async {
            if willAppear {
                UIView.animate(
                    withDuration: 0.1,
                    animations: {
                        self.view.alpha = 1
                    },
                    completion: { _ in
                    }
                )
            } else {
                UIView.animate(
                    withDuration: 0.1,
                    animations: {
                        self.view.alpha = 0
                    },
                    completion: { _ in
                        self.dismiss(animated: false, completion: nil)
                    }
                )
            }
        }
    }
}
