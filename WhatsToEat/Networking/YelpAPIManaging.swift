//
//  YelpAPIManaging.swift
//  WhatsToEat
//
//  Created by Jay Gabriel on 6/12/25.
//  Copyright © 2025 JayGabriel. All rights reserved.
//

import Foundation

protocol YelpAPIManaging {
    func getRestaurants(_ parameters: RestaurantSearchParameters) async throws -> [Restuarant]
    func getRestaurantDetail(id restaurantID: String) async throws -> RestaurantDetail
}

typealias RestaurantSearchParameters = (
    keywords: String,
    limit: Int,
    latitude: Double,
    longitude: Double
)

