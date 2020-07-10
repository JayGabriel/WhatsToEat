//
//  RestaurantDetailViewModel.swift
//  WhatsToEat
//
//  Created by Jonell on 6/19/20.
//  Copyright © 2020 JayGabriel. All rights reserved.
//

import Foundation
import UIKit

// MARK: - View Model Output

protocol RestaurantDetailViewModelDelegate {
    func didReceiveRestaurantDetails()
}

class RestaurantDetailViewModel {
    
    // MARK: - Properties
    
    private let restaurant: Restuarant
    private let yelpAPI: YelpAPI
    private(set) var supplementaryImageURLs = [String]()
    private(set) var businessHours: String? = nil
    private var isOpen: Int? = nil
    
    var name: String {
        return restaurant.name
    }
    
    var category: String {
        return restaurant.mainCategoryTitle
    }
    
    var distance: String {
        return String(format: restaurant.distance > 1.0 ? "%.0f" : "%.2f", restaurant.distance) + "mi"
    }
    
    var rating: UIImage? {
        switch restaurant.rating {
        case 0.0:
            return UIImage.YelpRating.zero
        case 1.0:
            return UIImage.YelpRating.one
        case 1.5:
            return UIImage.YelpRating.oneHalf
        case 2.0:
            return UIImage.YelpRating.two
        case 2.5:
            return UIImage.YelpRating.twoHalf
        case 3.0:
            return UIImage.YelpRating.three
        case 3.5:
            return UIImage.YelpRating.threeHalf
        case 4.0:
            return UIImage.YelpRating.four
        case 4.5:
            return UIImage.YelpRating.fourHalf
        case 5.0:
            return UIImage.YelpRating.five
        default:
            return nil
        }
    }
    
    var reviewCount: String {
        return "\(restaurant.reviewCount) reviews"
    }
    
    var price: String {
        return restaurant.price
    }
    
    var imageURL: String {
        return restaurant.previewImageURL
    }
    
    var address: String {
        return restaurant.addressArray.joined(separator: "\n")
    }
    
    var url: String {
        return restaurant.url
    }
    
    var latitude: Double {
        return restaurant.latitude
    }
    
    var longitude: Double {
        return restaurant.longitude
    }
    
    var phone: String {
        return restaurant.phone
    }
    
    // MARK: Delegate
    
    var delegate: RestaurantDetailViewModelDelegate?
    
    // MARK: - Lifecycle
    
    init(restaurant: Restuarant, yelpAPI: YelpAPI = .shared) {
        self.restaurant = restaurant
        self.yelpAPI = yelpAPI
        
        getDetailedRestaurantData()
    }
    
    private func getDetailedRestaurantData() {
        yelpAPI.getDetailedRestaurantData(restaurantID: restaurant.id) { (success, error, restaurantDetail) in
            guard let restaurantDetail = restaurantDetail else {
                return
            }
            
            if let imageURLs = restaurantDetail.imageURLs {
                self.supplementaryImageURLs = imageURLs
            }
            
            if
                let businessHours = restaurantDetail.businessHours,
                let weekdayIndex = Calendar.current.dateComponents([.weekday], from: Date()).weekday,
                let currentBusinessHours = businessHours.first(where: { $0.day == weekdayIndex }) {
                self.businessHours = "Today's hours\n\(currentBusinessHours.open) - \(currentBusinessHours.closed)"
            }
            
            self.delegate?.didReceiveRestaurantDetails()
        }
    }
    
    func supplementaryImageViewModelFor(_ indexPath: IndexPath) -> SupplementaryImageCollectionViewCellViewModel? {
        guard indexPath.row < supplementaryImageURLs.count else { return nil }
        guard let url = URL(string: supplementaryImageURLs[indexPath.row]) else { return nil}
        do {
            let data = try Data(contentsOf: url)
            let supplementaryImageCollectionViewCellViewModel = SupplementaryImageCollectionViewCellViewModel(imageData: data)
            return supplementaryImageCollectionViewCellViewModel
        } catch {
            return nil
        }
    }
}
