//
//  UIButton+extension.swift
//  Gridy
//
//  Created by Carl Wainwright on 24/08/2018.
//  Copyright © 2018 Carl Wainwright. All rights reserved.
//

import Foundation
import UIKit

extension GamePlayViewController : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GamePlayUICollectionVeiwCell", for: indexPath) as! GamePlayUICollectionVeiwCell
        //        cell.titleLabel.text = nameArr[indexPath.row]
        for _ in photoArray {
            cell.userImageView.image = photoArray[indexPath.item]
        }
        //        cell.userImageView.image = nameArr
        return cell
    }
}
