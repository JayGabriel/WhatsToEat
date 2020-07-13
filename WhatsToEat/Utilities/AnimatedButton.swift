//
//  AnimatedButton.swift
//  WhatsToEat
//
//  Created by Jay Gabriel on 7/12/20.
//  Copyright © 2020 JayGabriel. All rights reserved.
//

import UIKit

class AnimatedButton: UIButton {
    private enum Constants {
        static let shadowColor: CGColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
        static let shadowOffset: CGSize = CGSize(width: 0.0, height: 5.0)
        static let shadowOpacity: Float = 0.75
        static let shadowRadius: CGFloat = 10.0
    }
        
    override var isHighlighted: Bool {
        didSet {
            self.animatePulse(highlighted: isHighlighted, scale: 0.9)
        }
    }
    
    init() {
        super.init(frame: .zero)
        self.addShadow(
            color: Constants.shadowColor,
            offset: Constants.shadowOffset,
            opacity: Constants.shadowOpacity,
            radius: Constants.shadowRadius)
        self.adjustsImageWhenHighlighted = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
