//
//  SwiftPicConfigurationTests.swift
//  SwiftPic_Example
//
//  Created by Alex Brown on 6/21/18.
//  Copyright © 2018 CocoaPods. All rights reserved.
//

import Quick
import Nimble
import SwiftPic

@testable import SwiftPic
class SPConfigurationTests: QuickSpec {
    
    override func spec() {
        describe("when initialized") {
            it("class variables should be set") {
                let images = [UIImage(), UIImage(), UIImage()]
                let config = SPConfiguration(images: images, startIndex: 2)

                expect(config.images).toNot(beNil())
                expect(config.images).to(equal(images))
                expect(config.startIndex).to(equal(2))
            }
        }
        describe("when initialized with a single image") {
            it("isSingleImage should be true") {
                let images = [UIImage()]
                let config = SPConfiguration(images: images)
                
                expect(config.isSingleImage).to(beTrue())
            }
        }
        
        describe("when initialized with more than one image") {
            it("isSingleImage should be false") {
                let images = [UIImage(), UIImage()]
                let config = SPConfiguration(images: images)
                
                expect(config.isSingleImage).to(beFalse())
            }
        }
    }
}
