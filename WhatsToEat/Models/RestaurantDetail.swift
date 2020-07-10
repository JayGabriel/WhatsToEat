//
//  RestaurantDetail.swift
//  WhatsToEat
//
//  Created by Jay on 6/28/20.
//  Copyright © 2020 JayGabriel. All rights reserved.
//

import Foundation

struct RestaurantDetail {
    let imageURLs: [String]?
    let businessHours: [BusinessHours]?
    let isOpen: Int?
}

struct BusinessHours {
    let day: Int
    let open: String
    let closed: String
}
