//
//  ImageViewController.swift
//  obrClient
//
//  Created by Alex Brown on 6/7/18.
//  Copyright © 2018 K2M, Inc. All rights reserved.
//

import UIKit

public class ImageViewController: UIViewController {

    @IBOutlet weak var imageTitle: UILabel!
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    
    var viewModel: ImageViewControllerViewModel
    // Tracks whether the user is scrolling, we use this to bypass the system calling scrollview delegate methods automatically
    var isUserScrolling = false
    
    var scrollViewContentSize = CGSize.zero
    override public var prefersStatusBarHidden: Bool {
        return true
    }
    
    override public var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    var offsetForCurrentIndex: CGFloat {
        return offsetForIndex(index: viewModel.currentIndex)
    }
    
    public init(configuration: ImageViewControllerConfiguration) {
        viewModel = ImageViewControllerViewModel(configuration: configuration)
        let bundle = Bundle(for: ImageViewController.classForCoder())
        super.init(nibName: "ImageViewController", bundle: bundle)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init?(coder aDecoder: NSCoder) not supported")
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        headerView.alpha = 0
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChange), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        updateTitle()
        loadImages()
        setupScrollView()
        toggleHeaderView(alpha: 1)
    }
    
    @objc func orientationChange() {
        print(viewModel.currentIndex)
        let newFrame = scrollView.frame//CGRect(x: 0, y: 0, width: scrollView.frame.size.height, height: scrollView.frame.size.width)
        viewModel.updateImageFrames(newFrame: newFrame)
        scrollView.contentSize = CGSize(width: CGFloat(viewModel.imageViews.count) * newFrame.size.width, height: newFrame.size.height)
        // Update content offset for new scrollView frame
        scrollView.contentOffset = CGPoint(x: CGFloat(viewModel.currentIndex) * newFrame.size.width, y: 0)
    }
    
    func updateTitle() {
        self.imageTitle.text = viewModel.updateTitle()
    }
    
    func setupScrollView() {
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
    }
    
    func loadImages() {
        var contentWidth: CGFloat = 0
        for (index, image) in viewModel.images.enumerated() {
            let xOrigin = CGFloat(index) * scrollView.frame.size.width
            let frame = CGRect(x: xOrigin, y: 0, width: scrollView.frame.size.width, height: scrollView.frame.size.height)
            let scrollableImageView = ZoomableImageView(image: image, frame: frame)
            scrollableImageView.zoomDelegate = self
            addGestures(imageView: scrollableImageView)
            scrollView.addSubview(scrollableImageView)
            viewModel.imageViews.append(scrollableImageView)
            
            contentWidth += scrollView.frame.size.width
        }
        scrollViewContentSize = CGSize(width: contentWidth, height: scrollView.frame.size.height)
        scrollView.contentSize = scrollViewContentSize
        
        scrollView.contentOffset = CGPoint(x: CGFloat(viewModel.startIndex) * scrollView.frame.size.width, y: 0)
    }
    
    func addGestures(imageView: ZoomableImageView) {
        let imagePaneGesture = UIPanGestureRecognizer(target: self, action: #selector(imagePanned(gesture:)))
        imagePaneGesture.maximumNumberOfTouches = 1
        imagePaneGesture.delegate = self
        imageView.panGesture = imagePaneGesture
    }
    
    @objc func imagePanned(gesture: UIPanGestureRecognizer) {
        handleMoveGesture(gesture: gesture)
    }
    
    func handleMoveGesture(gesture: UIPanGestureRecognizer) {
        if gesture.state == .changed {
            panGestureChanged(gesture: gesture)
        } else if gesture.state == .ended {
            panGestureEnded(gesture: gesture)
        }
    }
    
    func panGestureChanged(gesture: UIPanGestureRecognizer) {
        guard let view = gesture.view
            else {return}
        
        let translation = gesture.translation(in: self.view)
        let translationPoint = CGPoint(x: view.center.x, y: view.center.y + translation.y)
        gesture.setTranslation(CGPoint.zero, in: view)
        
        let centerY = view.frame.height / 2
        let yMax = view.frame.height
        let topDeltaY = translationPoint.y / centerY
        let bottomDeltaY = (yMax - translationPoint.y) / centerY
        var alpha: CGFloat = 1
        if topDeltaY < 1 {
            alpha = topDeltaY
        } else if bottomDeltaY < 1 {
            alpha = bottomDeltaY
        }
        
        self.view.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: alpha).cgColor
        
        UIView.animate(withDuration: 0.01) {
            view.center = translationPoint
        }
        
        toggleHeaderView(alpha: 0)
    }
    
    func panGestureEnded(gesture: UIPanGestureRecognizer) {
        guard let view = gesture.view
            else {return}
        
        var frame = view.frame
        let shouldDismiss = frame.origin.y < -100 || frame.origin.y > 100
        if shouldDismiss {
            dismiss(animated: true, completion: nil)
        } else {
            frame.origin.x = offsetForCurrentIndex
            frame.origin.y = 0
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.5, options: .curveEaseIn, animations: {
                self.viewModel.currentImageView().frame = frame
                self.view.layer.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1).cgColor
            }, completion: nil)
        }
        toggleHeaderView(alpha: 1)
    }
    
    @objc func toggleControls() {
        let showing = headerView.alpha > 0
        if showing {
            headerView.fadeOut(duration: 0.2)
        } else {
            headerView.fadeIn(duration: 0.2)
        }
    }
    
    func toggleHeaderView(alpha: CGFloat) {
        if headerView.alpha == alpha {return}
        
        headerView.fadeIn(alpha: alpha, duration: 0.2)
    }
    
    func offsetForIndex(index: Int) -> CGFloat {
        return CGFloat(index) * scrollView.frame.size.width
    }
    
    override public func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ImageViewController {
    @IBAction func closebuttonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ImageViewController: ZoomableImageViewDelegate {
    
    func zoomableImageViewDidBeginZooming(imageView: ZoomableImageView) {
        scrollView.isScrollEnabled = false
        toggleHeaderView(alpha: 0)
    }
    
    func zoomableImageViewDidEndZooming(imageView: ZoomableImageView) {
        scrollView.isScrollEnabled = true
        toggleHeaderView(alpha: 1)
    }
}

extension ImageViewController: UIScrollViewDelegate {
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isUserScrolling = true
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        isUserScrolling = false
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Unless the user is invoking the scroll we don't want to do anything
        if !isUserScrolling {return}
        
        var index = lroundf(Float(scrollView.contentOffset.x / (scrollView.frame.size.width)))
        if index < 0 { index = 0 }
        if index > viewModel.imageViews.count - 1 { index = viewModel.imageViews.count - 1 }
        if index != viewModel.currentIndex {
            viewModel.currentIndex = index
            updateTitle()
        }
    }
}

extension ImageViewController: UIGestureRecognizerDelegate {
    /// Returns the distance of a given number from zero as a positive value. For example -100 would return 100.
    func positiveDistanceFromZero(_ value: CGFloat) -> CGFloat {
        var distance = value
        if distance < 0 {
            distance.negate()
        }
        return distance
    }

    /**
     Decide which gesture to handle here and cancel the other. We use 2 gesture recognizers and decide which value to handle based on the valocity.
     We test both the x and y values and chech which is the greatest (positive or negative); for example a bigger movement along the x axis would
     trigger the swipe (ltr) handler, and a greater movement along the y axis would trigger the swipe/dismiss (utd) handler.
    */
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if
            let gestureRecognizer = gestureRecognizer as? UIPanGestureRecognizer,
            let otherGestureRecognizer = otherGestureRecognizer as? UIPanGestureRecognizer {
            let panImageVelocity = gestureRecognizer.velocity(in: self.view)
            let scrollImagevelocity = otherGestureRecognizer.velocity(in: self.view)
            
            let dismissingValue = positiveDistanceFromZero(panImageVelocity.y)
            let scrollingValue = positiveDistanceFromZero(scrollImagevelocity.x)

            viewModel.isDismissing = dismissingValue > scrollingValue
            viewModel.isSwiping = scrollingValue >= dismissingValue

            if viewModel.isDismissing {
                otherGestureRecognizer.cancel()
            }
            if viewModel.isSwiping {
                gestureRecognizer.cancel()
            }
        }

        return false
    }    
}
