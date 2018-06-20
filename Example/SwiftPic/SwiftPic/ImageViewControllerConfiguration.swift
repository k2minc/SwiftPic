//
//  ImageViewControllerConfiguration.swift
//  obrClient
//
//  Created by Alex Brown on 6/13/18.
//  Copyright © 2018 K2M, Inc. All rights reserved.
//

import Foundation
import UIKit

struct ImageViewControllerConfiguration {
    
    let images: [UIImage]
    let startIndex: Int
    
    var imageIndexChanged: ((Int) -> Void)?
    var titleForImageAtIndex: ((Int) -> String)?

    var currentIndex: Int = 0 {
        didSet {
            if let imageIndexChanged = imageIndexChanged {
                imageIndexChanged(currentIndex)
            }
        }
    }
    
    var isSingleImage: Bool {
        return images.count == 1
    }
    
    init(images: [UIImage], startIndex: Int = 0) {
        self.images = images
        self.startIndex = startIndex
    }
}
