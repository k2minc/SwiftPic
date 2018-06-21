//
//  SPImageViewControllerViewModelTests.swift
//  SwiftPic_Example
//
//  Created by Alex Brown on 6/21/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import SwiftPic

@testable import SwiftPic
class SPImageViewControllerViewModelTests: QuickSpec {
    
    override func spec() {
        describe("When initialized") {
            context("with a single image", {
                it("should assign global variables", closure: {
                    let images = [UIImage()]
                    var configuration = SPConfiguration(images: images)
                    
                    let imageIndexChangedClosure: (Int) -> Void = { index in }
                    let titleChangedClosure: (Int) -> String = { index in return "title" }
                    
                    configuration.imageIndexChanged = imageIndexChangedClosure
                    configuration.titleForImageAtIndex = titleChangedClosure
                    let viewModel = SPImageViewControllerViewModel(configuration: configuration)
                    
                    expect(viewModel.images).to(equal(images))
                    expect(viewModel.startIndex).to(equal(0))
                    expect(viewModel.imageIndexChanged).toNot(beNil())
                    expect(viewModel.titleForImageAtIndex).toNot(beNil())
                    
                    expect(viewModel.isZoomed).to(beFalse())
                    expect(viewModel.isDismissing).to(beFalse())
                    expect(viewModel.isSwiping).to(beFalse())
                })
            })
            
            context("with multiple images and startIndex", {
                it("startIndex and currentIndex should equal startIndex from configuration object", closure: {
                    let images = [UIImage(), UIImage(), UIImage(), UIImage()]
                    let configuration = SPConfiguration(images: images, startIndex: 2)
                    
                    let viewModel = SPImageViewControllerViewModel(configuration: configuration)
                    
                    expect(viewModel.startIndex).to(equal(2))
                    expect(viewModel.currentIndex).to(equal(2))
                })
            })
        }
        
        describe("when image index changes") {
            let images = [UIImage(), UIImage()]
            var config = SPConfiguration(images: images)
            
            it("should call the imageIndexChanged closure") {
                config.imageIndexChanged = { index in
                    waitUntil(action: { (done) in
                        done()
                    })
                }
                
                var viewModel = SPImageViewControllerViewModel(configuration: config)
                viewModel.currentIndex = 1
            }
        }
        
        
        describe("currentImageView") {
            context("when index is 0") {
                let images = [UIImage(), UIImage()]
                let config = SPConfiguration(images: images)
                
                it("should return the first imageView in the list") {
                    var viewModel = SPImageViewControllerViewModel(configuration: config)
                    let imgView1 = ZoomableImageView(image: UIImage(), frame: CGRect.zero)
                    let imgView2 = ZoomableImageView(image: UIImage(), frame: CGRect.zero)
                    viewModel.imageViews = [imgView1, imgView2]
                    
                    expect(viewModel.currentImageView()).to(equal(imgView1))
                }
            }
        }
        
        describe("updateTitle") {
            context("when updateTitle is called") {
                let images = [UIImage(), UIImage()]
                var config = SPConfiguration(images: images)
                
                it("should trigger the titleForImageAtIndex closure") {
                    config.titleForImageAtIndex = { index in
                        waitUntil(action: { (done) in
                            expect(index).to(equal(1))
                            done()
                        })
                        return "new title"
                    }
                    
                    var viewModel = SPImageViewControllerViewModel(configuration: config)
                    viewModel.currentIndex = 1
                    expect(viewModel.updateTitle()).to(equal("new title"))
                }
            }
        }
        
        describe("updateFrames") {
            context("when updateFrames is called") {
                let images = [UIImage(), UIImage()]
                let config = SPConfiguration(images: images)
                
                it("All imageviews should update to the new frame") {
                    var viewModel = SPImageViewControllerViewModel(configuration: config)
                    let imgView1 = ZoomableImageView(image: UIImage(), frame: CGRect.zero)
                    let imgView2 = ZoomableImageView(image: UIImage(), frame: CGRect.zero)
                    imgView1.layoutSubviews()
                    imgView2.layoutSubviews()
                    viewModel.imageViews = [imgView1, imgView2]
                    
                    let newFrame = CGRect(x: 0, y: 0, width: 100, height: 100)
                    viewModel.updateImageFrames(newFrame: newFrame)
                    for image in viewModel.imageViews {
                        if let img = image.imageView {
                            expect(img.frame).to(equal(newFrame))
                        } else {
                            fail()
                        }
                    }
                }
            }
        }
        
        describe("setImageVisibility") {
            let images = [UIImage(), UIImage()]
            let config = SPConfiguration(images: images)
            var viewModel = SPImageViewControllerViewModel(configuration: config)
            let imgView1 = ZoomableImageView(image: UIImage(), frame: CGRect.zero)
            let imgView2 = ZoomableImageView(image: UIImage(), frame: CGRect.zero)
            imgView1.layoutSubviews()
            imgView2.layoutSubviews()
            viewModel.imageViews = [imgView1, imgView2]
            
            beforeEach {
                imgView1.isHidden = false
                imgView2.isHidden = false
                viewModel.currentIndex = 0
            }

            context("when we pass false") {
                it("should hide images") {
                    viewModel.setImageVisibility(hidden: false)
                    expect(imgView1.isHidden).to(beFalse())
                    expect(imgView2.isHidden).to(beFalse())
                }
            }
            
            context("when we pass true") {
                it("should hide images apart from image at index 0") {
                    viewModel.setImageVisibility(hidden: true)
                    // We never hide the current imageView (at index 0, so this should still be fals
                    expect(imgView1.isHidden).to(beFalse())
                    expect(imgView2.isHidden).to(beTrue())
                }
                
                it("should hide images apart from image at index 1") {
                    viewModel.currentIndex = 1
                    viewModel.setImageVisibility(hidden: true)
                    // We never hide the current imageView (at index 0, so this should still be fals
                    expect(imgView2.isHidden).to(beFalse())
                    expect(imgView1.isHidden).to(beTrue())
                }
            }
        }
    }
}
