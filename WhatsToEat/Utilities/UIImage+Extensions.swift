//
//  UIImage+Extensions.swift
//  WhatsToEat
//
//  Created by Jay on 6/2/20.
//  Copyright © 2020 JayGabriel. All rights reserved.
//

import UIKit

extension UIImageView {
    public func imageFromUrl(urlString: String) {
        if let url = URL(string: urlString) {
            let request = NSURLRequest(url: url)
            let session = URLSession.shared
            let task = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) in
                if let imageData = data {
                    DispatchQueue.main.async {
                        
                        self.alpha = 0
                        self.image = UIImage(data: imageData)
                        
                        UIView.animate(withDuration: 0.2, animations: {
                            self.alpha = 1
                        })
                    }
                } else {
                    DispatchQueue.main.async {
                        self.image = nil
                    }
                }
            })
            task.resume()
        }
    }
}
