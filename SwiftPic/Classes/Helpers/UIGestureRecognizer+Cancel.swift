//
//  UIGestureRecognizer+Cancel.swift
//  ImageViewer
//
//  Created by Alex Brown on 6/14/18.
//  Copyright © 2018 K2M. All rights reserved.
//

import Foundation
import UIKit

extension UIGestureRecognizer {
    
    /** when isEnabled is set to false the gesture is cancelled */
    func cancel() {
        isEnabled = false
        isEnabled = true
    }
}

