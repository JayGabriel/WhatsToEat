//
//  HomeViewController.swift
//  WhatsToEat
//
//  Created by Jay on 5/6/20.
//  Copyright © 2020 JayGabriel. All rights reserved.
//

import UIKit
import MapKit

class HomeViewController: UIViewController {
    private enum Constants {
        static let navigationBarColor = UIColor(red: 207/255, green: 78/255, blue: 222/255, alpha: 1)
    }

    // MARK: - Properties
    
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    private lazy var settingsButton: UIBarButtonItem = {
       let barButton = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(settingsButtonTapped))
       barButton.tintColor = .white
       return barButton
    }()
    
    private lazy var refreshButton: UIBarButtonItem = {
        let barButton = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshButtonTapped))
        barButton.tintColor = .white
        return barButton
    }()
        
    private lazy var searchView: SearchView = {
        let searchView = SearchView()
        searchView.translatesAutoresizingMaskIntoConstraints = false
        searchView.delegate = self
        return searchView
    }()
    
    private lazy var resultsTableView: UITableView = {
        let tableview = UITableView()
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.isHidden = true
        tableview.backgroundColor = .white
        tableview.delegate = self
        return tableview
    }()
        
    private var viewModel: HomeViewModel
    
    // MARK: - Lifecycle
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
    }
    
    // MARK: - Layout
    
    private func setupView() {
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.titleTextAttributes =  [NSAttributedString.Key.foregroundColor : UIColor.white]
        navigationController?.navigationBar.barTintColor = Constants.navigationBarColor
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.leftBarButtonItem = settingsButton
        navigationItem.rightBarButtonItem = refreshButton
        
        view.addSubview(mapView)
        view.addSubview(searchView)
        view.addSubview(resultsTableView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchView.rightAnchor.constraint(equalTo: view.rightAnchor),

            resultsTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            resultsTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            resultsTableView.topAnchor.constraint(equalTo: searchView.bottomAnchor),
            resultsTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    // MARK: - Actions
    
    @objc private func settingsButtonTapped() {
        viewModel.settingsButtonTapped()
    }
    
    @objc private func refreshButtonTapped() {
        viewModel.refreshButtonTapped()
        animateTableView(shouldShow: false)
    }
    
    private func searchButtonTapped() {
        viewModel.searchButtonTapped()
        animateTableView(shouldShow: true)
    }
    
    // MARK: - Animation
    
    private func animateTableView(shouldShow: Bool) {
        if shouldShow {
            resultsTableView.alpha = 0
            resultsTableView.isHidden = false
            UIView.animate(
                withDuration: 0.5,
                animations: {
                    self.resultsTableView.alpha = 1
                },
                completion: { _ in
                     self.resultsTableView.isHidden = false
                }
            )
        } else {
            UIView.animate(
                withDuration: 0.5,
                animations: {
                    self.resultsTableView.alpha = 0
                },
                completion: { _ in
                     self.resultsTableView.isHidden = true
                }
            )
        }
    }
}

extension HomeViewController: CLLocationManagerDelegate {
    
}

extension HomeViewController: SearchViewDelegate {
    func didEnterSearch(keyword: String, location: String) {
        animateTableView(shouldShow: true)
        viewModel.searchButtonTapped()
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
