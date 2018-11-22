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
    var puzzleDictionary: [Int:UIImage]
    var images: [UIImage]
    
    let gridSize: Int
    init(photo: UIImage, gridSize: Int, puzzleDictionary: [Int:UIImage]) {
        self.photo = photo
        self.gridSize = gridSize
        self.puzzleDictionary = puzzleDictionary
        self.images = puzzleDictionary.values.map{$0}
}
}
