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
    var orderedPhotoArray: [Int:UIImage] = [:]
    let gridSize: Int
    init(photo: UIImage, gridSize: Int) {
        self.photo = photo
        self.gridSize = gridSize
        self.photoArray = photoSplitToPuzzlePieces()
        self.orderedPhotoArray = dictionaryOfPhotos()

        
    }
    
    private func photoSplitToPuzzlePieces() -> [UIImage] {

        return photo.splitImage(gridSize).shuffled()
        }
    
    private func dictionaryOfPhotos() -> [Int:UIImage] {
        
        return photo.splitImage(gridSize).toDictionary
    }
    }
