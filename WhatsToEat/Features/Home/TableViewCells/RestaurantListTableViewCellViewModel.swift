//
//  RestaurantListTableViewCellViewModel.swift
//  WhatsToEat
//
//  Created by Jay on 5/25/20.
//  Copyright © 2020 JayGabriel. All rights reserved.
//

import Foundation

class RestaurantListTableViewCellViewModel {
    let name: String
    let kind: String
    let imageData: String
        
    init(name: String, kind: String, imageData: String) {
        self.name = name
        self.kind = kind
        self.imageData = imageData
    }
}
