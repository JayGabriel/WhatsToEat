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
        static let navigationBarColor: UIColor = .WhatsToEatPrimary
        
        static let resultsTableViewBottomOffset: CGFloat = -10.0

        static let toolbarViewHeight: CGFloat = 70.0
        static let toolbarViewLeftAnchor: CGFloat = 45.0
        static let toolbarViewRightAnchor: CGFloat = -45.0
        static let toolbarBottomAnchorOffset: CGFloat = -20.0
        
        static let emptyResultsContainerViewLeadingAnchor: CGFloat = 10
        static let emptyResultsContainerViewTrailingAnchor: CGFloat = -10
        static let emptyResultsContainerViewHeightMultiplier: CGFloat = 0.2
        
        static let activityIndicatorHeightAnchor: CGFloat = 50.0
    }

    // MARK: - Properties
        
    // MARK: UI Elements
    
    private lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.showsUserLocation = true
        mapView.showsCompass = true
        mapView.delegate = self
        mapView.tintColor = Constants.navigationBarColor
        return mapView
    }()
    
    private lazy var blurView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.isHidden = true
        blurView.translatesAutoresizingMaskIntoConstraints = false
        return blurView
    }()
    
    private lazy var searchView: SearchView = {
        let searchView = SearchView()
        searchView.translatesAutoresizingMaskIntoConstraints = false
        searchView.delegate = self
        return searchView
    }()
    
    private lazy var toolbarView: ToolbarView = {
        let toolbarView = ToolbarView()
        toolbarView.translatesAutoresizingMaskIntoConstraints = false
        toolbarView.delegate = self
        return toolbarView
    }()
    
    private lazy var resultsTableView: UITableView = {
        let tableview = UITableView()
        tableview.register(RestaurantListTableViewCell.self, forCellReuseIdentifier: RestaurantListTableViewCell.reuseIdentifier)
        tableview.translatesAutoresizingMaskIntoConstraints = false
        tableview.isHidden = true
        tableview.backgroundColor = .clear
        tableview.delegate = self
        tableview.dataSource = self
        tableview.separatorStyle = .none
        tableview.delaysContentTouches = false
        return tableview
    }()
    
    // MARK: Activity Indicator
    
    private let loadingTintView: UIView = {
        let activityIndicatorContainer = UIView()
        activityIndicatorContainer.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorContainer.backgroundColor = .black
        activityIndicatorContainer.alpha = 0
        return activityIndicatorContainer
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.color = .white
        activityIndicator.startAnimating()
        activityIndicator.isHidden = true
        return activityIndicator
    }()
    
    private lazy var emptyResultsContainerView: UIVisualEffectView = {
        let emptyResultsContainerEffect = UIBlurEffect(style: .light)
        let emptyResultsContainerView = UIVisualEffectView(effect: emptyResultsContainerEffect)
        emptyResultsContainerView.isHidden = true
        emptyResultsContainerView.translatesAutoresizingMaskIntoConstraints = false
        emptyResultsContainerView.layer.cornerRadius = 10
        emptyResultsContainerView.layer.masksToBounds = true
        return emptyResultsContainerView
    }()
    
    private let emptyResultsLabel: UILabel = {
        let emptyResultsLabel = UILabel()
        emptyResultsLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyResultsLabel.font = .emptyResultsLabel
        emptyResultsLabel.numberOfLines = 0
        emptyResultsLabel.textAlignment = .center
        emptyResultsLabel.backgroundColor = .clear
        emptyResultsLabel.lineBreakMode = .byTruncatingTail
        return emptyResultsLabel
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
        
        emptyResultsContainerView.contentView.addSubview(emptyResultsLabel)
                
        view.addSubview(mapView)
        view.addSubview(blurView)
        view.addSubview(resultsTableView)
        view.addSubview(searchView)
        view.addSubview(toolbarView)
        view.addSubview(loadingTintView)
        view.addSubview(activityIndicator)
        view.addSubview(emptyResultsContainerView)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mapView.leftAnchor.constraint(equalTo: view.leftAnchor),
            mapView.rightAnchor.constraint(equalTo: view.rightAnchor),
            mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            blurView.leftAnchor.constraint(equalTo: view.leftAnchor),
            blurView.rightAnchor.constraint(equalTo: view.rightAnchor),
            blurView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.leftAnchor.constraint(equalTo: view.leftAnchor),
            searchView.rightAnchor.constraint(equalTo: view.rightAnchor),

            resultsTableView.leftAnchor.constraint(equalTo: view.leftAnchor),
            resultsTableView.rightAnchor.constraint(equalTo: view.rightAnchor),
            resultsTableView.topAnchor.constraint(equalTo: searchView.bottomAnchor),
            resultsTableView.bottomAnchor.constraint(equalTo: toolbarView.topAnchor, constant: Constants.resultsTableViewBottomOffset),
            
            toolbarView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: Constants.toolbarViewLeftAnchor),
            toolbarView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: Constants.toolbarViewRightAnchor),
            toolbarView.bottomAnchor.constraint(equalTo: UIDevice().hasBottomSafeAreaInset ?  view.safeAreaLayoutGuide.bottomAnchor : view.bottomAnchor, constant: Constants.toolbarBottomAnchorOffset),
            toolbarView.heightAnchor.constraint(equalToConstant: Constants.toolbarViewHeight),
            
            loadingTintView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingTintView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingTintView.topAnchor.constraint(equalTo: resultsTableView.topAnchor),
            loadingTintView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            activityIndicator.heightAnchor.constraint(equalToConstant: Constants.activityIndicatorHeightAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: Constants.activityIndicatorHeightAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: loadingTintView.centerXAnchor),
            activityIndicator.centerYAnchor.constraint(equalTo: loadingTintView.centerYAnchor),
            
            emptyResultsContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: Constants.emptyResultsContainerViewLeadingAnchor),
            emptyResultsContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constants.emptyResultsContainerViewTrailingAnchor),
            emptyResultsContainerView.heightAnchor.constraint(equalTo: resultsTableView.heightAnchor, multiplier: Constants.emptyResultsContainerViewHeightMultiplier),
            emptyResultsContainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            emptyResultsLabel.leadingAnchor.constraint(equalTo: emptyResultsContainerView.leadingAnchor, constant: Constants.emptyResultsContainerViewLeadingAnchor),
            emptyResultsLabel.trailingAnchor.constraint(equalTo: emptyResultsContainerView.trailingAnchor, constant: Constants.emptyResultsContainerViewTrailingAnchor),
            emptyResultsLabel.topAnchor.constraint(equalTo: emptyResultsContainerView.topAnchor),
            emptyResultsLabel.bottomAnchor.constraint(equalTo: emptyResultsContainerView.bottomAnchor),
        ])
    }
    
    private func animateActivityIndicatorView(isLoading: Bool) {
        DispatchQueue.main.async {
            if isLoading {
                self.loadingTintView.isHidden = false
                self.activityIndicator.isHidden = false
                UIView.animate(
                    withDuration: 0.15,
                    animations: {
                        self.loadingTintView.alpha = 0.7
                        self.activityIndicator.alpha = 1
                        self.resultsTableView.reloadData()
                    }
                )
            } else {
                UIView.animate(
                    withDuration: 0.15,
                    animations: {
                        self.loadingTintView.alpha = 0
                        self.activityIndicator.alpha = 0
                    }, completion: { _ in
                        self.loadingTintView.isHidden = true
                        self.activityIndicator.isHidden = true
                    }
                )
            }
        }
    }
    
    private func setupEmptyResultsLabel(hidden: Bool? = nil) {
        DispatchQueue.main.async {
            if let hidden = hidden {
                self.emptyResultsContainerView.isHidden = hidden
                return
            }
            self.emptyResultsLabel.text = "No results found for \"\(self.searchView.keywordText)\""
            self.emptyResultsContainerView.isHidden = !self.viewModel.restaurantData.isEmpty
        }
    }
}

// MARK: - HomeViewModelDelegate
extension HomeViewController: HomeViewModelDelegate {
    func didStartSearch() {
        animateActivityIndicatorView(isLoading: true)
        setupEmptyResultsLabel(hidden: true)
    }
    
    func didEndSearch() {
        updateResultsTableViewData()
        createMapAnnotations()
        searchView.contract()
        animateActivityIndicatorView(isLoading: false)
        setupEmptyResultsLabel()
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
    
    func shouldDisplayRestaurantDetail(viewModel: RestaurantDetailViewModel) {
        let restaurantDetailViewController = RestaurantDetailViewController(viewModel: viewModel)
        present(restaurantDetailViewController, animated: true, completion: nil)
    }
    
    func errorOccurred(errorMessage: String) {
        DispatchQueue.main.async {
            let errorAlertController = UIAlertController.generateDismissableErrorAlertController(errorMessage: errorMessage)
            self.present(errorAlertController, animated: true, completion: nil)
        }
    }
}

// MARK: - SearchView Delegate

extension HomeViewController: SearchViewDelegate {
    func didBeginEditing() {
        setupEmptyResultsLabel(hidden: true)
    }
    func didEnterSearch(keyword: String, location: String?) {
        updateResultsTableViewData()
        viewModel.searchButtonTapped(keywordText: keyword, locationText: location)
    }
}

// MARK: - ToolbarView Delegate

extension HomeViewController: ToolbarViewDelegate {
    func didTapListButton() {
        toggleListView(shouldShow: true)
    }
    
    func didTapMapButton() {
        toggleListView(shouldShow: false)
    }
    
    func didTapRandomButton() {
        viewModel.randomButtonTapped()
    }
    
    func didTapRefreshButton() {
        viewModel.refreshButtonTapped()
    }
}

// MARK: - MapView Delegate

extension HomeViewController: MKMapViewDelegate {
    private func createMapAnnotations() {
        let annotations = viewModel.restaurantData.map { restaurant -> MKAnnotation in
            let annotation = MKRestaurantAnnotation(restaurant: restaurant)
            annotation.coordinate = CLLocationCoordinate2D(latitude: restaurant.latitude, longitude: restaurant.longitude)
            return annotation
        }
        
        DispatchQueue.main.async {
            self.mapView.removeAnnotations(self.mapView.annotations)
            self.mapView.showAnnotations(annotations, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        if let restaurantAnnotation = view.annotation as? MKRestaurantAnnotation {
            let viewModel = RestaurantDetailViewModel(restaurant: restaurantAnnotation.restaurant)
            let viewController = RestaurantDetailViewController(viewModel: viewModel)
            present(viewController, animated: true, completion: nil)
            mapView.deselectAnnotation(restaurantAnnotation, animated: true)
        }
    }
}

// MARK: - TableView Delegate and Data Source

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.restaurantData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RestaurantListTableViewCell.reuseIdentifier, for: indexPath) as? RestaurantListTableViewCell else {
            fatalError("Failed to dequeue a RestaurantListTableViewCell")
        }
        cell.configure(with: viewModel.restaurantTableCellViewModels[indexPath.section])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? RestaurantListTableViewCell else {
                fatalError("Failed to dequeue a RestaurantListTableViewCell")
            }
            cell.setHighlightedUI(highlighted: true)
        }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath) as? RestaurantListTableViewCell else {
            fatalError("Failed to dequeue a RestaurantListTableViewCell")
        }
        cell.setHighlightedUI(highlighted: false)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (tableView.frame.height / 5) - 20
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.backgroundColor = UIColor.clear
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(15)
    }
        
    private func updateResultsTableViewData() {
        DispatchQueue.main.async {
            self.resultsTableView.reloadData()
        }
    }
       
    private func toggleListView(shouldShow: Bool) {
        if shouldShow {
            resultsTableView.alpha = 0
            resultsTableView.isHidden = false
            blurView.alpha = 0
            blurView.isHidden = false
            UIView.animate(
                withDuration: 0.5,
                animations: {
                    self.resultsTableView.alpha = 1
                    self.blurView.alpha = 1
            },
                completion: { _ in
                    self.resultsTableView.isHidden = false
                    self.blurView.isHidden = false
            }
            )
        } else {
            UIView.animate(
                withDuration: 0.5,
                animations: {
                    self.resultsTableView.alpha = 0
                    self.blurView.alpha = 0
            },
                completion: { _ in
                    self.resultsTableView.isHidden = true
                    self.blurView.isHidden = true
            }
            )
        }
    }
}

