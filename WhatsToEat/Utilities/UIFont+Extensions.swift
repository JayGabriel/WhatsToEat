//
//  UIFont+Extensions.swift
//  WhatsToEat
//
//  Created by jay on 8/15/20.
//  Copyright © 2020 JayGabriel. All rights reserved.
//

import UIKit

extension UIFont {
    static let emptyResultsLabel = UIFont.systemFont(ofSize: 18, weight: .semibold)
    
    static let searchViewTitleLabel = UIFont.systemFont(ofSize: 15, weight: .semibold)
    static let searchViewKeywordField = UIFont.systemFont(ofSize: 22, weight: .heavy)
    static let searchViewLocationTextField = UIFont.systemFont(ofSize: 21, weight: .light)
    
    static let restaurantListTableViewCellName = UIFont.systemFont(ofSize: !UIDevice().iPhoneSE ? 32 : 25, weight: .heavy)
    static let restaurantListTableViewCellKind = UIFont.systemFont(ofSize: !UIDevice().iPhoneSE ? 28 : 20, weight: .bold)
    
    static let restaurantDetailName = UIFont.systemFont(ofSize: !UIDevice().iPhoneSE ? 32 : 25, weight: .bold)
    static let restaurantDetailCategory = UIFont.systemFont(ofSize: !UIDevice().iPhoneSE ? 20 : 16, weight: .bold)
    static let restaurantDetailDistance = UIFont.systemFont(ofSize: 20, weight: .bold)
    static let restaurantDetailPrice = UIFont.systemFont(ofSize: 20, weight: .bold)
    static let restaurantDetailReviewCount = UIFont.italicSystemFont(ofSize: 15)
    static let restaurantDetailAddress = UIFont.systemFont(ofSize: 15, weight: .medium)
    static let restaurantDetailBusinessHours = UIFont.systemFont(ofSize: 15, weight: .light)
    static let restaurantDetailDirecions = UIFont.systemFont(ofSize: 15, weight: .light)
    static let restaurantDetailPhone = UIFont.systemFont(ofSize: 15, weight: .light)
}
