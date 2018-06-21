//
//  ZoomableImageViewTests.swift
//  SwiftPic_Example
//
//  Created by Alex Brown on 6/21/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import SwiftPic

@testable import SwiftPic
class ZoomableImageViewTests: QuickSpec {
    
    override func spec() {
        describe("when initialized") {
            it("class variables should be set") {
                let frame = CGRect(x: 10, y: 10, width: 150, height: 150)
                let image = UIImage()
                let imageView = ZoomableImageView(image: image, frame: frame)
                expect(imageView.image).to(equal(image))
                expect(imageView.frame).to(equal(frame))
            }
        }
        
        describe("layoutSubViews") {
            let frame = CGRect(x: 10, y: 10, width: 150, height: 150)
            let image = UIImage()
            let imageView = ZoomableImageView(image: image, frame: frame)
            
            beforeEach {
                imageView.hasLaidOut = false
            }
            
            context("When called") {
                it("should  create UIImageView instance") {
                    imageView.layoutSubviews()
                    expect(imageView.imageView).toNot(beNil())
                }
                it("should setup scrollview") {
                    imageView.layoutSubviews()
                    expect(imageView.delegate).toNot(beNil())
                    expect(imageView.minimumZoomScale).to(equal(1))
                    expect(imageView.maximumZoomScale).to(equal(3))
                    expect(imageView.showsVerticalScrollIndicator).to(beFalse())
                    expect(imageView.showsHorizontalScrollIndicator).to(beFalse())
                }
            }
        }
        
    }
}
