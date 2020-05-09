//
//  HomeViewModel.swift
//  WhatsToEat
//
//  Created by Jay on 5/6/20.
//  Copyright © 2020 JayGabriel. All rights reserved.
//

import Foundation
import MapKit

class HomeViewModel {
    
    // MARK: - Properties

    private var locationManager: CLLocationManager
    
    // MARK: - Lifecycle
    
    init(locationManager: CLLocationManager = CLLocationManager()) {
        self.locationManager = locationManager
    }
    
    // MARK: - Input
    
    public func settingsButtonTapped() {
    }
    
    public func refreshButtonTapped() {
    }
    
    public func searchButtonTapped() {
    }
}
