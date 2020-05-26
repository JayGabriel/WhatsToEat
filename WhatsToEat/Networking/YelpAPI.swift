//
//  YelpAPI.swift
//  WhatsToEat
//
//  Created by Jay on 5/8/20.
//  Copyright © 2020 JayGabriel. All rights reserved.
//

import Foundation

class YelpAPI {
    
    // MARK: - Properties
    
    static let shared = YelpAPI()
    
    private var keywords = YelpAPIConstants.YelpParameterValues.restaurants
    private var latitude: Double = 0.0
    private var longitude: Double = 0.0
    private var radius = 20000
    private let defaultRadius: Int = 20000
    private var resultsCount = 0
    private var pageOffset = 0
    
    // MARK: - Search
    
    func searchForRestaurants(keywords: String = YelpAPIConstants.YelpParameterValues.restaurants,
                              limit: Int,
                              latitude: Double,
                              longitude: Double,
                              completion: @escaping(_ success: Bool, _ error: Error?, _ results: [Restuarant]) -> Void) {
        
        if self.latitude == latitude && self.longitude == longitude {
            if pageOffset < resultsCount - limit {
                pageOffset += limit
            } else {
                resultsCount = 0
                radius = radius + 1000
                pageOffset = 0
            }
        } else {
            resultsCount = 0
            self.keywords = keywords
            self.latitude = latitude
            self.longitude = longitude
            self.radius = defaultRadius
            self.pageOffset = 0
        }
        
        let queryItems = [URLQueryItem(name: YelpAPIConstants.YelpParameterKeys.latitude, value: String(latitude)),
                          URLQueryItem(name: YelpAPIConstants.YelpParameterKeys.longitude, value: String(longitude)),
                          URLQueryItem(name: YelpAPIConstants.YelpParameterKeys.radius, value: String(radius)),
                          URLQueryItem(name: YelpAPIConstants.YelpParameterKeys.term, value: keywords),
                          URLQueryItem(name: YelpAPIConstants.YelpParameterKeys.limit, value: String(limit)),
                          URLQueryItem(name: YelpAPIConstants.YelpParameterKeys.offset, value: String(pageOffset)),
                          URLQueryItem(name: YelpAPIConstants.YelpParameterKeys.sort_by, value: YelpAPIConstants.YelpParameterValues.best_match),
                          URLQueryItem(name: YelpAPIConstants.YelpResponseKeys.categories, value: YelpAPIConstants.YelpParameterValues.categories)
        ]
        
        var urlComponents = URLComponents(string: YelpAPIConstants.YelpParameterKeys.SearchURL)
        urlComponents?.queryItems = queryItems
        
        guard let url = urlComponents?.url else {
            completion(false, nil, [])
            return
        }
        
        let request = NSMutableURLRequest(url: url)
        request.addValue("\(YelpAPIConstants.YelpParameterKeys.Bearer) \(YelpAPIConstants.YelpParameterValues.API_Key)", forHTTPHeaderField: YelpAPIConstants.YelpParameterKeys.Authorization)
        
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest) { data, response, error in
            if let error = error {
                completion(false, error, [])
                return
            }
            
            guard let data = data else {
                completion(false, error, [])
                return
            }
            
            var parsedResult: [String: AnyObject]
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
            } catch {
                completion(false, error, [])
                return
            }
                       
            guard let totalResultsCount = parsedResult[YelpAPIConstants.YelpResponseKeys.total] as? Int else {
                completion(false, error, [])
                return
            }
            
            self.resultsCount = totalResultsCount
            
            guard let restaurants = parsedResult[YelpAPIConstants.YelpResponseKeys.businesses] as? [[String: AnyObject]] else {
                completion(false, error, [])
                return
            }
            
            var formattedResults = [Restuarant]()
            restaurants.forEach { restaurant in
                guard
                    let id = restaurant[YelpAPIConstants.YelpResponseKeys.id] as? String,
                    let name = restaurant[YelpAPIConstants.YelpResponseKeys.name] as? String,
                    let coordinates = restaurant[YelpAPIConstants.YelpResponseKeys.coordinates] as? [String:Double],
                    let restraurantLatitude = coordinates[YelpAPIConstants.YelpResponseKeys.latitude],
                    let restaurantLongitude = coordinates[YelpAPIConstants.YelpResponseKeys.longitude],
                    let location = restaurant[YelpAPIConstants.YelpResponseKeys.location] as? [String:AnyObject],
                    let addressArray = location[YelpAPIConstants.YelpResponseKeys.display_address] as? [String],
                    let distance = restaurant[YelpAPIConstants.YelpResponseKeys.distance] as? Double,
                    let phone = restaurant[YelpAPIConstants.YelpResponseKeys.phone] as? String,
                    let previewImageURL = restaurant[YelpAPIConstants.YelpResponseKeys.image_url] as? String,
                    let rating = restaurant[YelpAPIConstants.YelpResponseKeys.rating] as? Double,
                    let ratingCount = restaurant[YelpAPIConstants.YelpResponseKeys.review_count] as? Int,
                    let urlLink = restaurant[YelpAPIConstants.YelpResponseKeys.url] as? String,
                    let categories = restaurant[YelpAPIConstants.YelpResponseKeys.categories],
                    let mainCategory = categories[0] as? [String:String],
                    let mainCategoryTitle = mainCategory[YelpAPIConstants.YelpResponseKeys.title] else {
                        completion(false, error, [])
                        return
                }
                
                var price = String()
                if let p = restaurant[YelpAPIConstants.YelpResponseKeys.price] {
                    price = p as! String
                } else {
                    price = ""
                }
                
                // The extracted information is stored in a dictionary and is passed back to the calling controller.
                formattedResults.append(Restuarant(
                    id: id,
                    name: name,
                    latitude: restraurantLatitude,
                    longitude: restaurantLongitude,
                    addressArray: addressArray,
                    distance: distance,
                    phone: phone,
                    previewImageURL: previewImageURL,
                    rating: rating,
                    ratingCount: ratingCount,
                    url: urlLink,
                    mainCategoryTitle: mainCategoryTitle,
                    price: price)
                )
            }
            completion(true, nil, formattedResults)
        }
        task.resume()
    }
}

