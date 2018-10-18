//
//  GamePlayViewModel.swift
//  Gridy
//
//  Created by Carl Wainwright on 03/09/2018.
//  Copyright © 2018 Carl Wainwright. All rights reserved.
//

import Foundation
import UIKit

class GamePlayViewModel {
    
    let photo: UIImage
    var photoArray: [UIImage] = []
    let gridSize: Int
    init(photo: UIImage, gridSize: Int) {
        self.photo = photo
        self.gridSize = gridSize
        self.photoArray = shuffledPhoto()

        
    }
    
    private func shuffledPhoto() -> [UIImage] {

        return photo.splitImage(gridSize).shuffled()
        }
    }

    

//    //split photo into segments
//    photoArray = gamePlayViewModel.photo.splitImage(gridSize, gridSize)
//
////randomize the split photo
//for _ in 0..<photoArray.count {
//    let rand = Int(arc4random_uniform(UInt32(photoArray.count)))
//    shuffledPhoto.append(photoArray[rand])
//    photoArray.remove(at: rand)
//    print (shuffledPhoto.indices)
//}
