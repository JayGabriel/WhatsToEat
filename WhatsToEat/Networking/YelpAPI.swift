//
//  YelpAPI.swift
//  WhatsToEat
//
//  Created by Jay on 5/8/20.
//  Copyright © 2020 JayGabriel. All rights reserved.
//

import Foundation

enum YelpAPIManagerError: Error {
    case urlConfiguration
    case parseResultError
    case generic(_ description: String) // TODO specify
}

class YelpAPIManager: YelpAPIManaging {
    private init() {}
    static let shared = YelpAPIManager()

    // MARK: - Private
    private var keywords = YelpAPIConstants.YelpParameterValues.restaurants
    private var latitude: Double = 0.0
    private var longitude: Double = 0.0
    private var radius = 20000
    private let defaultRadius: Int = 20000
    private var resultsCount = 0
    private var pageOffset = 0
        
    func getRestaurants(_ parameters: RestaurantSearchParameters) async throws -> [Restuarant] {
        let (keywords, limit, latitude, longitude) = parameters
                
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
        
        let queryItems = [
            URLQueryItem(name: YelpAPIConstants.YelpParameterKeys.latitude, value: String(latitude)),
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
            throw YelpAPIManagerError.urlConfiguration
        }
        
        var request = URLRequest(url: url)
        request.addValue("\(YelpAPIConstants.YelpParameterKeys.Bearer) \(YelpAPIConstants.YelpParameterValues.API_Key)", forHTTPHeaderField: YelpAPIConstants.YelpParameterKeys.Authorization)
        
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            var parsedResult: [String: AnyObject]
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
            } catch {
                throw error
            }
            
            guard let totalResultsCount = parsedResult[YelpAPIConstants.YelpResponseKeys.total] as? Int else {
                throw YelpAPIManagerError.generic("no results")
            }
            
            self.resultsCount = totalResultsCount
            
            guard let restaurants = parsedResult[YelpAPIConstants.YelpResponseKeys.businesses] as? [[String: AnyObject]] else {
                throw YelpAPIManagerError.generic("no restaurant key")
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
                    return
                }
                
                var price = String()
                if let p = restaurant[YelpAPIConstants.YelpResponseKeys.price] {
                    price = p as! String
                } else {
                    price = ""
                }
                
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
                    reviewCount: ratingCount,
                    url: urlLink,
                    mainCategoryTitle: mainCategoryTitle,
                    price: price)
                )
            }
            return formattedResults
        } catch {
            throw error
        }
    }
    
    func getRestaurantDetail(id restaurantID: String) async throws -> RestaurantDetail {
        guard let escapedID = restaurantID.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            throw YelpAPIManagerError.generic("encoding failed")
        }
        
        let path = "\(YelpAPIConstants.YelpParameterKeys.BusinessesURL)/\(escapedID)"
        
        guard let url = URL(string: path) else {
            throw YelpAPIManagerError.generic("url failed")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = YelpAPIConstants.YelpParameterKeys.Get
        request.addValue("\(YelpAPIConstants.YelpParameterKeys.Bearer) \(YelpAPIConstants.YelpParameterValues.API_Key)", forHTTPHeaderField: YelpAPIConstants.YelpParameterKeys.Authorization)
                
        do {
            let (data, _) = try await URLSession.shared.data(for: request)
            
            var parsedResult: [String: AnyObject]
            do {
                parsedResult = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: AnyObject]
            } catch {
                throw YelpAPIManagerError.generic("parsing failed")
            }
            
            let imageURLs = parsedResult[YelpAPIConstants.YelpResponseKeys.photos] as? [String]
            var isOpen: Int?
            
            var businessHours = [BusinessHours]()
            
            if
                let hours = parsedResult[YelpAPIConstants.YelpResponseKeys.hours] as? [[String: AnyObject]],
                let hoursDictionary = hours.first {
                
                isOpen = hoursDictionary[YelpAPIConstants.YelpResponseKeys.isOpenNow] as? Int
                
                if let schedules = hoursDictionary[YelpAPIConstants.YelpResponseKeys.open] as? [[String: Any]]{
                    for schedule in schedules {
                        if
                            let day = schedule["day"] as? Int,
                            let start = schedule["start"] as? String,
                            let end = schedule["end"] as? String,
                            let formattedStart = start.from24HourTo12Hour(),
                            let formattedEnd = end.from24HourTo12Hour() {
                            
                            businessHours.append(BusinessHours(day: day, open: formattedStart, closed: formattedEnd))
                        }
                    }
                }
            }
            return RestaurantDetail(imageURLs: imageURLs, businessHours: businessHours, isOpen: isOpen)
        } catch {
            throw error
        }
    }
}

