//
//  UIView+Extensions.swift
//  WhatsToEat
//
//  Created by Jay on 5/21/20.
//  Copyright © 2020 JayGabriel. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func addShadow(color: CGColor, offset: CGSize, opacity: Float, radius: CGFloat) {
        layer.masksToBounds = false
        layer.shadowColor = color
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }
}
