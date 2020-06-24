//
//  String+Extensions.swift
//  WhatsToEat
//
//  Created by Jay on 6/28/20.
//  Copyright © 2020 JayGabriel. All rights reserved.
//

import Foundation

extension String {
    func from24HourTo12Hour() -> String? {
        guard self.count == 4 else { return nil }
        guard Set(self).allSatisfy({ $0.isNumber }) else { return nil }
        
        let digits = Array(self)
        
        guard let hour = Int(String(digits[0...1])) else { return nil }

        return "\(hour > 12 ? hour - 12 : hour):\(String(digits[2...3]))\(hour >= 12 ? "PM" : "AM")"
    }
}
