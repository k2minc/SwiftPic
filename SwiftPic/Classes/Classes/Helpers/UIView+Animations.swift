//
//  UIView+Animations.swift
//  ImageViewer
//
//  Created by Alex Brown on 6/14/18.
//  Copyright © 2018 K2M. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func fadeIn(duration: Double) {
        fadeIn(alpha: 1, duration: duration)
    }
    
    func fadeIn(alpha: CGFloat, duration: Double) {
        isHidden = false
        UIView.animate(withDuration: duration, animations: {
            self.alpha = alpha
        })
    }
    
    func fadeOut(duration: Double) {
        UIView.animate(withDuration: duration, animations: {
            self.alpha = 0
        }) { (complete) in
            self.isHidden = true
        }
    }
}
