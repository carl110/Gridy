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
