//
//  ImageViewControllerViewModel.swift
//  obrClient
//
//  Created by Alex Brown on 6/13/18.
//  Copyright © 2018 K2M, Inc. All rights reserved.
//

import Foundation
import UIKit

struct SPImageViewControllerViewModel {
    
    let images: [UIImage]
    let startIndex: Int
    
    var imageIndexChanged: ((Int) -> Void)?
    var titleForImageAtIndex: ((Int) -> String)?
    
    var imageViews = [ZoomableImageView]()
    
    // MARK: Gesture state
    
    /** tracks whether a user is zooming on an image */
    var isZoomed = false
    
    /** tracks the pan gesture for dismissing images is in progress */
    var isDismissing = false
    
    /** tracks the pan gesture for scrollview scrolling is in progress */
    var isSwiping = false
    
    // MARK Status bar
    
    /** Sets the modalPresentationCapturesStatusBarAppearance property in SPViewController */
    let managesOwnStatusBar: Bool
    
    /** returned when prefersStatusBarHidden is called in SPViewController */
    let hidesStatusBar: Bool
    
    /** returned when preferredStatusBarUpdateAnimation is called in SPViewController */
    let statusBarHideAnimation: UIStatusBarAnimation
    
    /** returned when preferredStatusBarStyle is called in SPViewController */
    let statusBarStyle: UIStatusBarStyle
    
    var currentIndex: Int = 0 {
        didSet {
            if let imageIndexChanged = imageIndexChanged {
                imageIndexChanged(currentIndex)
            }
        }
    }
    
    init(configuration: SPConfiguration) {
        images = configuration.images
        imageIndexChanged = configuration.imageIndexChanged
        titleForImageAtIndex = configuration.titleForImageAtIndex
        
        managesOwnStatusBar = configuration.managesOwnStatusBar
        hidesStatusBar = configuration.hidesStatusBar
        statusBarHideAnimation = configuration.statusBarHideAnimation
        statusBarStyle = configuration.statusBarStyle
        
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


