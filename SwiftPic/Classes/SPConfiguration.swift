//
//  ImageViewControllerConfiguration.swift
//  obrClient
//
//  Created by Alex Brown on 6/13/18.
//  Copyright © 2018 K2M, Inc. All rights reserved.
//

import Foundation
import UIKit

/**
 Provides configuration for SPImageViewController
 */
public struct SPConfiguration {
    
    /** An array of images that will be displayed */
    let images: [UIImage]
    
    /** The position at which the gallery should start */
    let startIndex: Int
    
    /** Called everytime the index is updated (optional) */
    public var imageIndexChanged: ((Int) -> Void)?
    
    /** requests a title for the current image (optional) */
    public var titleForImageAtIndex: ((Int) -> String)?
    
    // MARK: Status Bar
    
    /** Sets the modalPresentationCapturesStatusBarAppearance property in SPViewController */
    var managesOwnStatusBar = true
    
    /** returned when prefersStatusBarHidden is called in SPViewController */
    var hidesStatusBar = false
    
    /** returned when preferredStatusBarUpdateAnimation is called in SPViewController */
    var statusBarHideAnimation: UIStatusBarAnimation = .slide
    
    /** returned when preferredStatusBarStyle is called in SPViewController */
    var statusBarStyle: UIStatusBarStyle = .lightContent
    
    var isSingleImage: Bool {
        return images.count == 1
    }
    
    public init(images: [UIImage], startIndex: Int = 0) {
        self.images = images
        self.startIndex = startIndex
    }
}
