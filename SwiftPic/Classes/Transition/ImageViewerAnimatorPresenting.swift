//
//  ImageViewerAnimatorPresenting.swift
//  obrClient
//
//  Created by Alex Brown on 6/8/18.
//  Copyright © 2018 K2M, Inc. All rights reserved.
//

import Foundation
import AVKit

class ImageViewerAnimatorPresenting: NSObject, UIViewControllerAnimatedTransitioning {
    
    let originImageView: UIImageView
    let animationTime: Double
    
    init(originImageView: UIImageView, animationTime: Double) {
        self.originImageView = originImageView
        self.animationTime = animationTime
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return animationTime
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let container = transitionContext.containerView
        guard
            let toView = transitionContext.view(forKey: .to),
            let toVc = transitionContext.viewController(forKey: .to),
            let fromVc = transitionContext.viewController(forKey: .from)
            else { return }
        
        let fromFrame = originImageView.convert(originImageView.bounds, to: fromVc.view)
        let targetFrame = transitionContext.finalFrame(for: toVc)
        originImageView.isHidden = true
        
        toView.translatesAutoresizingMaskIntoConstraints = true
        
        toView.frame = targetFrame
        toView.isHidden = true
        
        let fadeInView = UIView(frame: targetFrame)
        fadeInView.backgroundColor = .black
        fadeInView.alpha = 0
        
        let width = originImageView.image!.size.width
        let height = originImageView.image!.size.height
        
        let targetImageViewSize = AVMakeRect(aspectRatio: CGSize(width: width, height: height), insideRect: targetFrame)
        
        let imageView = UIImageView(frame: fromFrame)
        imageView.image = originImageView.image
        imageView.contentMode = originImageView.contentMode
        imageView.clipsToBounds = true
        imageView.clearsContextBeforeDrawing = false
        
        container.addSubview(toView)
        container.addSubview(fadeInView)
        container.addSubview(imageView)
        
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
