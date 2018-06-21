//
//  ImageViewerAnimatorDismissing.swift
//  obrClient
//
//  Created by Alex Brown on 6/8/18.
//  Copyright © 2018 K2M, Inc. All rights reserved.
//

import Foundation
import UIKit

public class ImageViewerAnimatorDismissing: NSObject, UIViewControllerAnimatedTransitioning {
    
    let originImageView: UIImageView
    let animationTime: Double
    
    public init(originImageView: UIImageView, animationTime: Double) {
        self.originImageView = originImageView
        self.animationTime = animationTime
    }
    
    public func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationTime
    }
    
    public func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        guard
            let fromVC = transitionContext.viewController(forKey: .from) as? SPImageViewController,
            let originImage = originImageView.image
            else { return }
        
        let toFrame = originImageView.convert(originImageView.bounds, to: fromVC.view)
        let targetFrame = transitionContext.initialFrame(for: fromVC)
        
        originImageView.isHidden = true
        
        let offsetY = fromVC.viewModel.currentImageView().frame.origin.y
        let offsetX: CGFloat = 0
        let width = originImage.size.width
        let height = originImage.size.height
        let aspectRatio = height / width
        let yPos = (targetFrame.size.height / 2) - (targetFrame.width * aspectRatio / 2) + offsetY
        let originFrame = CGRect(x: offsetX, y: yPos, width: targetFrame.width, height: targetFrame.width * aspectRatio)
        
        let imageView = UIImageView(frame: originFrame)
        imageView.image = originImage
        imageView.contentMode = originImageView.contentMode
        imageView.clipsToBounds = true
        imageView.clearsContextBeforeDrawing = false
        
        let fadeOutView = UIView(frame: targetFrame)
        fadeOutView.backgroundColor = .black
        let currentAlpha: CGFloat = fromVC.view.backgroundColor?.cgColor.alpha ?? 1
        fadeOutView.alpha = currentAlpha
        
        fromVC.view.isHidden = true
        container.addSubview(fadeOutView)
        container.addSubview(imageView)
        
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
