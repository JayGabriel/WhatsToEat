//
//  Images.swift
//  WhatsToEat
//
//  Created by Jay on 6/3/20.
//  Copyright © 2020 JayGabriel. All rights reserved.
//

import UIKit

extension UIImage {
    static let randomIcon: UIImage = #imageLiteral(resourceName: "random")
    static let refreshIcon: UIImage = #imageLiteral(resourceName: "refresh")
    static let mapIcon: UIImage = #imageLiteral(resourceName: "map")
    static let listIcon: UIImage = #imageLiteral(resourceName: "list")
    static let directionsIcon: UIImage = #imageLiteral(resourceName: "directons")
    static let phoneIcon: UIImage = #imageLiteral(resourceName: "phone")
    
    static let yelpLogo: UIImage = #imageLiteral(resourceName: "YelpLogo")
    
    struct YelpRating {
        static let zero: UIImage = #imageLiteral(resourceName: "rating0")
        static let one: UIImage = #imageLiteral(resourceName: "rating1")
        static let oneHalf: UIImage = #imageLiteral(resourceName: "rating1h")
        static let two: UIImage = #imageLiteral(resourceName: "rating2")
        static let twoHalf: UIImage = #imageLiteral(resourceName: "rating2h")
        static let three: UIImage = #imageLiteral(resourceName: "rating3")
        static let threeHalf: UIImage = #imageLiteral(resourceName: "rating2h")
        static let four: UIImage = #imageLiteral(resourceName: "rating4")
        static let fourHalf: UIImage = #imageLiteral(resourceName: "rating4h")
        static let five: UIImage = #imageLiteral(resourceName: "rating5")
    }
}
