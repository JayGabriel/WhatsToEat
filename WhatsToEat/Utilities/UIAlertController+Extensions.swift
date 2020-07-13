//
//  UIAlertController+Extensions.swift
//  WhatsToEat
//
//  Created by Jay Gabriel on 7/13/20.
//  Copyright © 2020 JayGabriel. All rights reserved.
//

import UIKit

extension UIAlertController {
    static func generateDismissableErrorAlertController(errorMessage: String) -> UIAlertController {
        let alertController = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
        alertController.view.tintColor = .WhatsToEatPrimary
        return alertController
    }
}
