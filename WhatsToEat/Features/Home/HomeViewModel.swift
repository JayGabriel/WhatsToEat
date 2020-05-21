//
//  HomeViewModel.swift
//  WhatsToEat
//
//  Created by Jay on 5/6/20.
//  Copyright © 2020 JayGabriel. All rights reserved.
//

import Foundation
import MapKit

// MARK: - View Model Output

protocol HomeViewModelDelegate {
    func didReceiveRestaurantsData()
    func didUpdateRegion(region: MKCoordinateRegion)
    func didChangeCurrentKeywordsString()
    func didChangeCurrentLocationString()
}

class HomeViewModel: NSObject {
    
    // MARK: - Properties

    // MARK: YelpAPI
    private var yelpAPI: YelpAPI
    
    // MARK: Location
    private var locationManager: CLLocationManager
    private var currentSearchLocation: CLLocation?
    
    // MARK: Delegate
    var delegate: HomeViewModelDelegate?
    
    // MARK: Data Source
    private(set) var data = [String]() {
        didSet { self.delegate?.didReceiveRestaurantsData() }
    }
    
    private(set) var currentSearchKeywordsString: String? = nil {
        didSet { self.delegate?.didChangeCurrentKeywordsString() }
    }
    
    private(set) var currentSearchLocationString: String? = nil {
        didSet { self.delegate?.didChangeCurrentLocationString() }
    }

    // MARK: - Lifecycle
    
    init(yelpAPI: YelpAPI = .shared, locationManager: CLLocationManager = CLLocationManager()) {
        self.yelpAPI = yelpAPI
        self.locationManager = locationManager
        
        super.init()
        locationManager.delegate = self
    }
}

// MARK: - View Controller Input
extension HomeViewModel {
    
    public func viewDidLoad() {
        guard
            CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() == .authorizedAlways
            else {
                locationManager.requestWhenInUseAuthorization()
                return
            }
        
        locationManager.startUpdatingLocation()
    }
    
    public func settingsButtonTapped() {
        
    }
    
    public func refreshButtonTapped() {
        
    }
    
    public func searchButtonTapped(keywordText: String, locationText: String?) {
        self.currentSearchKeywordsString = keywordText
        self.currentSearchLocationString = locationText
        
        if let locationText = locationText {
            geocodeLocationString(cityToGeocode: locationText, completionHandlerForGeocode: {
                (success, error, result) in
                
                guard
                    let locationDictionary = result,
                    let locationString = locationDictionary["locationString"] as? String,
                    let location = locationDictionary["location"] as? CLLocation else {
                        return
                }
                self.currentSearchLocation = location
                self.currentSearchLocationString = locationString
                self.searchForRestaurants(keywords: keywordText,
                                          limit: 10,
                                          location: location)
            })
        } else {
            guard let location = currentSearchLocation else { return }
            searchForRestaurants(keywords: keywordText,
                                 limit: 10,
                                 location: location)
        }
    }
    
    private func searchForRestaurants(keywords: String, limit: Int, location: CLLocation) {
        yelpAPI.searchForRestaurants(keywords: keywords,
                                     limit: limit,
                                     latitude: location.coordinate.latitude,
                                     longitude: location.coordinate.longitude) { (success, error, results) in
                               
            self.data = results.map { $0.name }
            self.updateMap(location: location)
        }
    }
}

// MARK: - CLLocationManagerDelegate

extension HomeViewModel: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        self.currentSearchLocation = location
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { placemark, error in
            if let error = error {
                return
            }
            
            guard
                let foundPlacemarks = placemark,
                let firstPlacemark = foundPlacemarks.first,
                let state = firstPlacemark.administrativeArea,
                let city = firstPlacemark.locality else { return }
            
            self.currentSearchLocationString = "\(city), \(state)"
        })
        
        updateMap(location: location)
        locationManager.stopUpdatingLocation()
    }
    
    func geocodeLocationString(cityToGeocode: String, completionHandlerForGeocode: @escaping(_ result: Bool, _ errorString: String?, _ result: [String:Any]?) -> Void) {
        
        let geocoder = CLGeocoder()

        geocoder.geocodeAddressString(cityToGeocode, completionHandler: { (placemark, error) in

            if error != nil {
                return
            }
            
            guard
                let foundPlacemarks = placemark,
                let firstPlacemark = foundPlacemarks.first,
                let city = firstPlacemark.locality,
                let state = firstPlacemark.administrativeArea,
                let location = firstPlacemark.location
            else {
                return
            }
        
            let locationInfo: [String: Any] = [
                "locationString": "\(city), \(state)",
                "location": location
            ]
            completionHandlerForGeocode(true, nil, locationInfo)
        })
    }
    
    func updateMap(location: CLLocation) {
        let region = MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: CLLocationDegrees(0.1), longitudeDelta: CLLocationDegrees(0.1)))
        delegate?.didUpdateRegion(region: region)
    }
}
