//
//  MKAnnotation+Restaurant.swift
//  WhatsToEat
//
//  Created by Jay on 7/2/20.
//  Copyright © 2020 JayGabriel. All rights reserved.
//

import MapKit

class MKRestaurantAnnotation: MKPointAnnotation {
    let restaurant: Restuarant
    
    init(restaurant: Restuarant) {
        self.restaurant = restaurant
        super.init()
        self.title = restaurant.name
        self.subtitle = restaurant.mainCategoryTitle
    }
}
