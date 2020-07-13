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
    func shouldDisplayRestaurantDetail(viewModel: RestaurantDetailViewModel)
    func errorOccurred(errorMessage: String)
}

class HomeViewModel: NSObject {
    private struct Constants {
        static let loadRestaurantsErrorMessage: String = "Failed to load restaurant data."
        static let loadLocationErrorMessage: String = "Failed to load location."
        static let locationNotSetErrorMessage: String = "Location not set."
    }
    
    // MARK: - Properties

    // MARK: YelpAPI
    private var yelpAPI: YelpAPI
    
    // MARK: Location
    private var locationManager: CLLocationManager
    private var currentSearchLocation: CLLocation?
    
    // MARK: Delegate
    var delegate: HomeViewModelDelegate?
    
    // MARK: Data Source
    private(set) var restaurantData = [Restuarant]() {
        didSet { self.delegate?.didReceiveRestaurantsData() }
    }
    
    var restaurantTableCellViewModels: [RestaurantListTableViewCellViewModel] {
        return restaurantData.map {
            RestaurantListTableViewCellViewModel(name: $0.name, kind: $0.mainCategoryTitle, imageData: $0.previewImageURL)
        }
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
    
    public func randomButtonTapped() {
        guard let locationText = self.currentSearchLocationString else {
            delegate?.errorOccurred(errorMessage: Constants.locationNotSetErrorMessage)
            return
        }
        
        geocodeLocationString(cityToGeocode: locationText) { success, error, result in
            guard
                let locationDictionary = result,
                let locationString = locationDictionary["locationString"] as? String,
                let location = locationDictionary["location"] as? CLLocation,
                let countryCode = locationDictionary["countryCode"] as? String,
                let keywordText = YelpAPIConstants.CountryStyles.AllStyles.filter({$0.2.contains(countryCode)}).randomElement()?.1 else {
                    self.delegate?.errorOccurred(errorMessage: Constants.loadLocationErrorMessage)
                    return
            }
                        
            self.currentSearchKeywordsString = keywordText
            self.currentSearchLocation = location
            self.currentSearchLocationString = locationString
            
            self.searchForRestaurants(keywords: keywordText,
                                      limit: 5,
                                      location: location)
        }
    }

    
    public func refreshButtonTapped() {
        guard
            let keywordText = self.currentSearchKeywordsString,
            let locationText = self.currentSearchLocationString else {
                return
        }

        searchButtonTapped(keywordText: keywordText, locationText: locationText)
    }
    
    public func didSelectRow(at indexPath: IndexPath) {
        guard indexPath.section < restaurantData.count else {
            return
        }
        
        let selectedRestaurant = restaurantData[indexPath.section]
        delegate?.shouldDisplayRestaurantDetail(viewModel: RestaurantDetailViewModel(restaurant: selectedRestaurant))
    }
    
    public func searchButtonTapped(keywordText: String, locationText: String?) {
        self.currentSearchKeywordsString = keywordText
        self.currentSearchLocationString = locationText
        
        restaurantData.removeAll()        
        
        if let locationText = locationText {
            geocodeLocationString(cityToGeocode: locationText, completionHandlerForGeocode: {
                (success, error, result) in
                
                if error != nil {
                    self.delegate?.errorOccurred(errorMessage: Constants.loadLocationErrorMessage)
                    return
                }
                
                guard
                    let locationDictionary = result,
                    let locationString = locationDictionary["locationString"] as? String,
                    let location = locationDictionary["location"] as? CLLocation else {
                        self.delegate?.errorOccurred(errorMessage: Constants.loadLocationErrorMessage)
                        return
                }
                self.currentSearchLocation = location
                self.currentSearchLocationString = locationString
                self.searchForRestaurants(keywords: keywordText,
                                          limit: 5,
                                          location: location)
            })
        } else {
            guard let location = currentSearchLocation else {
                delegate?.errorOccurred(errorMessage: Constants.loadLocationErrorMessage)
                return
            }
            searchForRestaurants(keywords: keywordText,
                                 limit: 5,
                                 location: location)
        }
    }
    
    private func searchForRestaurants(keywords: String, limit: Int, location: CLLocation) {
        yelpAPI.searchForRestaurants(keywords: keywords,
                                     limit: limit,
                                     latitude: location.coordinate.latitude,
                                     longitude: location.coordinate.longitude) { (success, error, results) in
                               
            self.restaurantData = results
            guard let region = self.calculateNewRegion(from: results) else { return }
            self.delegate?.didUpdateRegion(region: region)
        }
    }
    
    private func calculateNewRegion(from restaurants: [Restuarant]) -> MKCoordinateRegion? {
        var minLatitude: Double?, maxLatitude: Double?, minLongitude: Double?, maxLongitude: Double?
        
        for restaurant in restaurants {
            minLatitude = minLatitude == nil ? restaurant.latitude : min(restaurant.latitude, minLatitude!)
            maxLatitude = maxLatitude == nil ? restaurant.latitude : max(restaurant.latitude, maxLatitude!)

            minLongitude = minLongitude == nil ? restaurant.longitude : min(restaurant.longitude, minLongitude!)
            maxLongitude = maxLongitude == nil ? restaurant.longitude : max(restaurant.longitude, maxLongitude!)
        }
        
        guard
            minLatitude != nil,
            maxLatitude != nil,
            minLongitude != nil,
            maxLongitude != nil else {
            if let currentLocation = currentSearchLocation {
                 return MKCoordinateRegion(center: currentLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: CLLocationDegrees(0.1), longitudeDelta: CLLocationDegrees(0.1)))
            } else {
                return nil
            }
        }
        
        var region = MKCoordinateRegion()
        region.center.latitude = (minLatitude! + maxLatitude!) / 2;
        region.center.longitude = (minLongitude! + maxLongitude!) / 2;

        region.span.latitudeDelta = (maxLatitude! - minLatitude!) * 1.5
        region.span.longitudeDelta = (maxLongitude! - minLongitude!) * 1.5

        return region
    }
}

// MARK: - CLLocationManagerDelegate

extension HomeViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        
        self.currentSearchLocation = location
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: { placemark, error in
            if error != nil {
                self.delegate?.errorOccurred(errorMessage: Constants.loadRestaurantsErrorMessage)
                return
            }
            
            guard
                let foundPlacemarks = placemark,
                let firstPlacemark = foundPlacemarks.first,
                let state = firstPlacemark.administrativeArea,
                let city = firstPlacemark.locality else {
                    self.delegate?.errorOccurred(errorMessage: Constants.loadRestaurantsErrorMessage)
                    return
            }
            
            self.currentSearchLocationString = "\(city), \(state)"
        })
        
        delegate?.didUpdateRegion(region: MKCoordinateRegion(center: location.coordinate, span: MKCoordinateSpan(latitudeDelta: CLLocationDegrees(0.1), longitudeDelta: CLLocationDegrees(0.1))))
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
    }
    
    func geocodeLocationString(cityToGeocode: String, completionHandlerForGeocode: @escaping(_ result: Bool, _ errorString: String?, _ result: [String:Any]?) -> Void) {
        
        let geocoder = CLGeocoder()

        geocoder.geocodeAddressString(cityToGeocode, completionHandler: { (placemark, error) in

            if error != nil {
                self.delegate?.errorOccurred(errorMessage: Constants.loadLocationErrorMessage)
                return
            }
            
            guard
                let foundPlacemarks = placemark,
                let firstPlacemark = foundPlacemarks.first,
                let city = firstPlacemark.locality,
                let state = firstPlacemark.administrativeArea,
                let location = firstPlacemark.location,
                let countryCode = firstPlacemark.isoCountryCode
            else {
                self.delegate?.errorOccurred(errorMessage: Constants.loadRestaurantsErrorMessage)
                return
            }
        
            let locationInfo: [String: Any] = [
                "locationString": "\(city), \(state)",
                "location": location,
                "countryCode": countryCode
            ]
            completionHandlerForGeocode(true, nil, locationInfo)
        })
    }
}
