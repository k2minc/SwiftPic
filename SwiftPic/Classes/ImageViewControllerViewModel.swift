//
//  ImageViewControllerViewModel.swift
//  obrClient
//
//  Created by Alex Brown on 6/13/18.
//  Copyright © 2018 K2M, Inc. All rights reserved.
//

import Foundation
import UIKit

struct ImageViewControllerViewModel {
    
    let images: [UIImage]
    let startIndex: Int
    
    var imageIndexChanged: ((Int) -> Void)?
    var titleForImageAtIndex: ((Int) -> String)?
    
    var imageViews = [ZoomableImageView]()
    
    // Flags for gesture state
    var isZoomed = false
    var isDismissing = false
    var isSwiping = false
    
    var currentIndex: Int = 0 {
        didSet {
            if let imageIndexChanged = imageIndexChanged {
                imageIndexChanged(currentIndex)
            }
        }
    }
    
    init(configuration: ImageViewControllerConfiguration) {
        images = configuration.images
        imageIndexChanged = configuration.imageIndexChanged
        titleForImageAtIndex = configuration.titleForImageAtIndex
        if configuration.isSingleImage {
            startIndex = 0
        } else {
            startIndex = configuration.startIndex
            currentIndex = startIndex
        }
    }
    
    func currentImageView() -> ZoomableImageView {
        return imageViews[currentIndex]
    }
    
    func nextImageView() -> ZoomableImageView? {
        let nextIndex = currentIndex
        if nextIndex < imageViews.count {
            return imageViews[nextIndex]
        }
        return nil
    }
    
    func updateTitle() -> String {
        if let titleForImageAtIndex = titleForImageAtIndex {
            return titleForImageAtIndex(currentIndex)
        }
        return ""
    }
    
    // Reposition image views when layout changes occur
    func updateImageFrames(newFrame: CGRect) {
        for (index, imageView) in imageViews.enumerated() {
            imageView.updateFrame(newFrame: newFrame, for: index)
        }
    }
    
    func setImageVisibility(hidden: Bool) {
        for (index, imageView) in imageViews.enumerated() {
            if index != currentIndex {
                imageView.isHidden = hidden
            }
        }
    }
}


