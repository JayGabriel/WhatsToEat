//
//  HomeViewModel.swift
//  WhatsToEat
//
//  Created by Jay on 5/6/20.
//  Copyright © 2020 JayGabriel. All rights reserved.
//

import Foundation

class HomeViewModel: NSObject {
    
    // MARK: - Properties

    // MARK: YelpAPI
    
    private var yelpAPI: YelpAPI
    
    // MARK: Delegate
    
    var delegate: HomeViewModelDelegate?
    
    // MARK: Data Source
    
    private(set) var data = [String]()

    // MARK: - Lifecycle
    
    init(yelpAPI: YelpAPI = .shared) {
        self.yelpAPI = yelpAPI
        super.init()
    }
}

// MARK: - View Controller Input
extension HomeViewModel {
    
    public func settingsButtonTapped() {
        
    }
    
    public func refreshButtonTapped() {
        
    }
    
    public func searchButtonTapped(keywords: String) {
        
        // TODO: Calculate actual coordinates
        let latitude = 47.608013
        let longitude = -122.335167
        
        yelpAPI.searchForRestaurants(keywords: keywords, limit: 10, latitude: latitude, longitude: longitude) {
            (success, error, results) in
            
            var names = [String]()
            if let results = results {
                for r in results {
                    if let name = r["name"] {
                        names.append(name)
                    }
                }
            }
            self.data = names
            self.delegate?.didReceiveRestaurantsData()
        }
    }
}

// MARK: - View Model Output
protocol HomeViewModelDelegate {
    func didReceiveRestaurantsData() -> Void
}
