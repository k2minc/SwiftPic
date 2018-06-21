//
//  ImageCollectionViewController.swift
//  ImageViewer
//
//  Created by Alex Brown on 6/14/18.
//  Copyright © 2018 K2M. All rights reserved.
//

import UIKit
import SwiftPic

private let reuseIdentifier = "Cell"

class ImageCollectionViewController: UICollectionViewController {
    
    typealias PlanetImage = (name: String, image: UIImage)

    lazy var planetImages: [PlanetImage] = [
        PlanetImage(name: "Mercury", image: #imageLiteral(resourceName: "mercury")),
        PlanetImage(name: "Venus", image: #imageLiteral(resourceName: "venus")),
        PlanetImage(name: "Earth", image: #imageLiteral(resourceName: "earth")),
        PlanetImage(name: "Mars", image: #imageLiteral(resourceName: "mars")),
        PlanetImage(name: "Jupiter", image: #imageLiteral(resourceName: "jupiter")),
        PlanetImage(name: "Saturn", image: #imageLiteral(resourceName: "saturn")),
        PlanetImage(name: "Uranus", image: #imageLiteral(resourceName: "uranus")),
        PlanetImage(name: "Neptune", image: #imageLiteral(resourceName: "neptune")),
        PlanetImage(name: "Pluto (i'm a planet! 😆)", image: #imageLiteral(resourceName: "pluto"))
    ]
    
    var images: [UIImage] {
        return planetImages.map({ $0.image })
    }
    
    var selectedCell: PlanetCollectionViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        if let collectionView = collectionView {
            let nib = UINib(nibName: "PlanetCollectionViewCell", bundle: nil)
            collectionView.register(nib, forCellWithReuseIdentifier: reuseIdentifier)
        }
        // Do any additional setup after loading the view.
        self.title = "Planets"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return planetImages.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PlanetCollectionViewCell
        if cell == nil {
            cell = PlanetCollectionViewCell()
        }
        
        cell?.imageView.image = planetImages[indexPath.row].image
        cell?.planetName.text = planetImages[indexPath.row].name
        
        return cell!
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? PlanetCollectionViewCell {
            selectedCell = cell
        }
        
        var configuration = SPConfiguration(images: images, startIndex: indexPath.row)
        
        configuration.imageIndexChanged = { [weak self] index in
            guard let weakSelf = self
                else {return}
            
            weakSelf.selectedCell?.imageView.isHidden = false
            
            let updatedIndex = IndexPath(item: index, section: 0)
            if let updatedCell = weakSelf.collectionView?.cellForItem(at: updatedIndex) as? PlanetCollectionViewCell {
                weakSelf.selectedCell = updatedCell
                updatedCell.imageView.isHidden = true
            }
        }
        configuration.titleForImageAtIndex = { [weak self] index in
            guard let weakSelf = self
                else {return ""}
            
            return weakSelf.planetImages[index].name
        }
        
        let imageDetail = SPImageViewController(configuration: configuration)
        imageDetail.modalPresentationStyle = .custom
        imageDetail.transitioningDelegate = self
        self.present(imageDetail, animated: true, completion: nil)
    }
}

extension ImageCollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 220)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(10, 10, 10, 10)
    }
}

extension ImageCollectionViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let cell = selectedCell {
            return ImageViewerAnimatorPresenting(originImageView: cell.imageView, animationTime: 0.5)
        }
        return nil
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if let cell = selectedCell {
            return ImageViewerAnimatorDismissing(originImageView: cell.imageView, animationTime: 0.4)
        }
        return nil
    }
}
