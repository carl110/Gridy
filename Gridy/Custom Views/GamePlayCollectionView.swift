//
//  GamePlayCollectionView.swift
//  Gridy
//
//  Created by Carl Wainwright on 15/10/2018.
//  Copyright © 2018 Carl Wainwright. All rights reserved.
//

import Foundation
import UIKit

class GamePlayCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    


    override func awakeFromNib() {
        delegate = self
        dataSource = self
    }
    
    var puzzleImages: [UIImage] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print (puzzleImages.count)
        return puzzleImages.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GamePlayUICollectionViewCell", for: indexPath) as! GamePlayUICollectionViewCell
        cell.config(puzzleImages: puzzleImages[indexPath.row])

        return cell
    }

    
    @objc func longPressGestureHandler(sender:UILongPressGestureRecognizer) {
        switch sender.state {
        case .began:
            print ("longPress began")
        case .changed:
            print ("longPress changed")

        case .ended:
            print ("longPress ended")

        default :
            print("Default")
        }
    }
    
    
    

    
}
