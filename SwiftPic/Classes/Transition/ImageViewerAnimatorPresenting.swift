//
//  ImageViewerAnimatorPresenting.swift
//  obrClient
//
//  Created by Alex Brown on 6/8/18.
//  Copyright © 2018 K2M, Inc. All rights reserved.
//

import Foundation
import AVKit

public class ImageViewerAnimatorPresenting: NSObject {
    let originImageView: UIImageView
    let animationTime: Double
    
    public init(originImageView: UIImageView, animationTime: Double) {
        self.originImageView = originImageView
        self.animationTime = animationTime
    }
}

// MARK: UIViewControllerAnimatedTransitioning
extension ImageViewerAnimatorPresenting: UIViewControllerAnimatedTransitioning {
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationTime
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        guard
            let toView = transitionContext.view(forKey: .to),
            let toVc = transitionContext.viewController(forKey: .to),
            let fromVc = transitionContext.viewController(forKey: .from),
            let originImage = originImageView.image
            else { return }
        
        // The absolute position of the origin imageView in it's parent
        let fromFrame = originImageView.convert(originImageView.bounds, to: fromVc.view)
        
        // The destination frame for the imageView pulled from the context
        let targetFrame = transitionContext.finalFrame(for: toVc)
        
        // Set the origin image to hidden, gives the impression that we're animating the original image
        originImageView.isHidden = true
        
        toView.translatesAutoresizingMaskIntoConstraints = true
        
        toView.frame = targetFrame
        toView.isHidden = true
        
        let fadeInView = UIView(frame: targetFrame)
        fadeInView.backgroundColor = .black
        fadeInView.alpha = 0
        
        let width = originImage.size.width
        let height = originImage.size.height
        
        // Borrowing functionality from AVKit to calculate the frame of the image as it will appear in the target imageView.
        let targetImageViewSize = AVMakeRect(aspectRatio: CGSize(width: width, height: height), insideRect: targetFrame)
        
        // Calculate the origin frame for the new imageView
        let imageView = UIImageView(frame: fromFrame)
        imageView.image = originImage
        imageView.contentMode = originImageView.contentMode
        imageView.clipsToBounds = true
        imageView.clearsContextBeforeDrawing = false
        
        // Setup container
        container.addSubview(toView)
        container.addSubview(fadeInView)
        container.addSubview(imageView)
        
        // Animate the transition
        let duration = transitionDuration(using: transitionContext)
        UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.9, options: .curveEaseOut, animations: {
            imageView.frame = targetImageViewSize
            fadeInView.alpha = 1
        }) { (complete) in
            imageView.removeFromSuperview()
            fadeInView.removeFromSuperview()
            toView.isHidden = false
            toVc.viewDidAppear(true)
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
        
    }
}
