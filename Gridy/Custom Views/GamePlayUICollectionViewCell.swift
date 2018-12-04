//
//  GamePlayUICollectionViewCell.swift
//  Gridy
//
//  Created by Carl Wainwright on 20/09/2018.
//  Copyright © 2018 Carl Wainwright. All rights reserved.
//

import Foundation
import UIKit

class GamePlayUICollectionViewCell: UICollectionViewCell {
    

    @IBOutlet weak var userImageView: UIImageView!
    //add array of images as cells
    func config (puzzleImages: UIImage) {
        userImageView.image = puzzleImages
    }
    
    override func prepareForReuse() {
        userImageView.image = UIImage()
    }
}
