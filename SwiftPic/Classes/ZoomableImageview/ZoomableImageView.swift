//
//  ZoomablePhotoView.swift
//  obrClient
//
//  Created by Alex Brown on 6/12/18.
//  Copyright © 2018 K2M, Inc. All rights reserved.
//

import Foundation
import AVKit

// MARK: ZoomableImageViewDelegate
protocol ZoomableImageViewDelegate {
    func zoomableImageViewDidBeginZooming(imageView: ZoomableImageView)
    func zoomableImageViewDidEndZooming(imageView: ZoomableImageView)
}

class ZoomableImageView: UIScrollView {
    
    var zoomDelegate: ZoomableImageViewDelegate?
    
    let image: UIImage
    var imageView: UIImageView?
    
    var hasLaidOut = false
        
    var panGesture: UIPanGestureRecognizer? {
        didSet {
            if let panGesture = panGesture {
                addGestureRecognizer(panGesture)
            }
        }
    }
    
    var isZoomed = false {
        didSet {
            guard let zoomDelegate = zoomDelegate
                else {return}
            
            if isZoomed {
                panGesture?.isEnabled = false
                zoomDelegate.zoomableImageViewDidBeginZooming(imageView: self)
            } else {
                panGesture?.isEnabled = true
                zoomDelegate.zoomableImageViewDidEndZooming(imageView: self)
            }
        }
    }
    
    init(image: UIImage, frame: CGRect) {
        self.image = image
        super.init(frame: frame)
    }
    
    // MARK: UIView methods
    required init?(coder aDecoder: NSCoder) {
        fatalError("init?(coder aDecoder: NSCoder) not supported")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if !hasLaidOut {
            setupScrollView()
            addImage()
            addDoubleTapGesture()
        }
        
        hasLaidOut = true
    }
    
    // MARK: Setup
    func setupScrollView() {
        delegate = self
        minimumZoomScale = 1
        maximumZoomScale = 3
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
    }
    
    /** Adds the 'double tap to zoom' gesture */
    func addDoubleTapGesture() {
        guard let imageView = imageView
            else {return}
        
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(gesture:)))
        doubleTap.numberOfTapsRequired = 2
        imageView.addGestureRecognizer(doubleTap)
    }
    
    /** Creates and adds the UIImageview instance to the scrollView */
    func addImage() {
        var imageViewFrame = frame
        imageViewFrame.origin = CGPoint.zero
        imageView = UIImageView(frame: imageViewFrame)
        imageView!.contentMode = .scaleAspectFit
        imageView!.image = image
        imageView!.isUserInteractionEnabled = true
        addSubview(imageView!)
    }
    
    /**
     The action for the double tap gesture.
     */
    @objc func handleDoubleTap(gesture: UITapGestureRecognizer) {
        guard let view = gesture.view
            else {return}
        
        let touchLocation = gesture.location(ofTouch: 0, in: view)
        
        if zoomScale != 1 {
            setZoomScale(1, animated: true)
        } else {
            let zoomWidth: CGFloat = 100
            let touchLocation = CGRect(x: touchLocation.x - (zoomWidth / 2), y: touchLocation.y - (zoomWidth / 2), width: zoomWidth, height: zoomWidth)
            zoom(to: touchLocation, animated: true)
        }
    }
    
    func updateFrame(newFrame: CGRect, for index: Int) {
        guard let imageView = imageView
            else {return}
        
        // Reset zoom scale
        if isZoomed {
            setZoomScale(1, animated: false)
            isZoomed = false
        }
        
        var currentFrame = frame
        currentFrame.size = newFrame.size
        let newXPosition = CGFloat(index) * currentFrame.size.width
        currentFrame.origin.x = newXPosition
        // Update the current frame
        frame = currentFrame
        
        // Update the image frame
        let imageframe = CGRect(origin: CGPoint.zero, size: newFrame.size)
        imageView.frame = imageframe
    }
}

// MARK: UIScrollViewDelegate
extension ZoomableImageView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        isZoomed = true
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        if scale == 1 {
            isZoomed = false
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isZoomed {
            let imageViewSize = AVMakeRect(aspectRatio: image.size, insideRect: frame)
            let verticalInsets = -(scrollView.contentSize.height - max(imageViewSize.height * zoomScale, scrollView.bounds.height)) / 2
            scrollView.contentInset = UIEdgeInsets(top: verticalInsets, left: 0, bottom: verticalInsets, right: 0)
        }
    }
}
