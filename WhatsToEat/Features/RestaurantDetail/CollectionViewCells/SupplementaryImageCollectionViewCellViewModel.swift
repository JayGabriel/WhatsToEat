//
//  SupplementaryImageCollectionViewCellViewModel.swift
//  WhatsToEat
//
//  Created by Jay on 6/26/20.
//  Copyright © 2020 JayGabriel. All rights reserved.
//

import Foundation

class SupplementaryImageCollectionViewCellViewModel {
    
    // MARK: - Properties
    
    private(set) var imageData: Data
    
    // MARK: - Lifecycle
    
    init(imageData: Data) {
        self.imageData = imageData
    }
}
