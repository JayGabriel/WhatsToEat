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
    
    // MARK: UI Elements
    
    private lazy var mapView: MKMapView = {
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
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.isHidden = true
        tableview.backgroundColor = .white
        tableview.delegate = self
        tableview.dataSource = self
        return tableview
    }()
        
    // MARK: View Model
            
    private var viewModel: HomeViewModel
    
    // MARK: - Lifecycle
    
    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        viewModel.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        setupConstraints()
        viewModel.viewDidLoad()
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
        view.addSubview(resultsTableView)
        view.addSubview(searchView)
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
        animateTableView(shouldShow: resultsTableView.isHidden)
    }
    
    // MARK: - Table View
    
    private func updateResultsTableViewData() {
        DispatchQueue.main.async {
            self.resultsTableView.reloadData()
        }
    }
    
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

extension HomeViewController: HomeViewModelDelegate {
    func didReceiveRestaurantsData() {
        updateResultsTableViewData()
    }
    
    func didUpdateRegion(region: MKCoordinateRegion) {
        DispatchQueue.main.async {
            self.mapView.setRegion(region, animated: true)
        }
    }
    
    func didChangeCurrentKeywordsString() {
        searchView.keywordText = viewModel.currentSearchKeywordsString ?? ""
    }
    
    func didChangeCurrentLocationString() {
        searchView.locationText = viewModel.currentSearchLocationString ?? ""
    }
}

extension HomeViewController: SearchViewDelegate {
    func didEnterSearch(keyword: String, location: String?) {
        updateResultsTableViewData()
        viewModel.searchButtonTapped(keywordText: keyword, locationText: location)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = viewModel.data[indexPath.row]
        return cell
    }
}

