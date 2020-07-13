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
    
    func animateAlpha(highlighted: Bool) {
        DispatchQueue.main.async {
            UIView.animate(
                withDuration: 0.05,
                animations: {
                    if highlighted {
                        self.alpha = 0.5
                    } else {
                        self.alpha = 1.0
                    }
                }
            )
        }
    }
    
    func animatePulse(highlighted: Bool, scale: CGFloat) {
        DispatchQueue.main.async {
            UIView.animate(
                withDuration: 0.15,
                delay: 0.0,
                options: .curveEaseInOut,
                animations: {
                    if highlighted {
                        self.transform = CGAffineTransform(scaleX: scale, y: scale)
                    } else {
                        self.transform = .identity
                    }
                }
            )
        }
    }
}
