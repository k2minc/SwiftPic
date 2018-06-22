//
//  ImageViewerAnimatorDismissing.swift
//  obrClient
//
//  Created by Alex Brown on 6/8/18.
//  Copyright © 2018 K2M, Inc. All rights reserved.
//

import Foundation
import UIKit

public class ImageViewerAnimatorDismissing: NSObject {
    // The imageView we're animating from.
    let originImageView: UIImageView
    let animationTime: Double
    
    // MARK: init.
    public init(originImageView: UIImageView, animationTime: Double) {
        self.originImageView = originImageView
        self.animationTime = animationTime
    }
}

// MARK: UIViewControllerAnimatedTransitioning
extension ImageViewerAnimatorDismissing: UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationTime
    }
    
    // MARK: Transition
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        guard
            let fromVC = transitionContext.viewController(forKey: .from) as? SPImageViewController,
            let originImage = originImageView.image
            else { return }
        
        // The absolute position of the origin imageView in it's parent
        let toFrame = originImageView.convert(originImageView.bounds, to: fromVC.view)
        
        // The destination frame for the imageView pulled from the context
        let targetFrame = transitionContext.initialFrame(for: fromVC)
        
        // Set the origin image to hidden, gives the impression that we're animating the original image
        originImageView.isHidden = true

        // Calculate the origin frame for the new imageView
        let offsetY = fromVC.viewModel.currentImageView().frame.origin.y
        let offsetX: CGFloat = 0
        let width = originImage.size.width
        let height = originImage.size.height
        // important to get the true size of the imahge
        let aspectRatio = height / width
        // This is the actual position of the image when shown in the origin UIImageView.
        let yPos = (targetFrame.size.height / 2) - (targetFrame.width * aspectRatio / 2) + offsetY
        let originFrame = CGRect(x: offsetX, y: yPos, width: targetFrame.width, height: targetFrame.width * aspectRatio)
        
        // Setup our new imageView for the transition
        let imageView = UIImageView(frame: originFrame)
        imageView.image = originImage
        imageView.contentMode = originImageView.contentMode
        imageView.clipsToBounds = true
        imageView.clearsContextBeforeDrawing = false
        
        // Fade out background
        let fadeOutView = UIView(frame: targetFrame)
        fadeOutView.backgroundColor = .black
        let currentAlpha: CGFloat = fromVC.view.backgroundColor?.cgColor.alpha ?? 1
        fadeOutView.alpha = currentAlpha
        
        // Add everything to our transition container.
        fromVC.view.isHidden = true
        container.addSubview(fadeOutView)
        container.addSubview(imageView)
        
        // Animate the transition
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
            imageView.frame = toFrame
            fadeOutView.alpha = 0
        }) { (complete) in
            fromVC.view.isHidden = false
            self.originImageView.isHidden = false
            
            fadeOutView.removeFromSuperview()
            imageView.removeFromSuperview()
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
}
