//
//  UIDevice+Extensions.swift
//  WhatsToEat
//
//  Created by Jonell on 6/8/20.
//  Copyright © 2020 JayGabriel. All rights reserved.
//

import UIKit

extension UIDevice {
    var hasBottomSafeAreaInset: Bool {
        let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
