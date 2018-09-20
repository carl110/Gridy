//
//  GamePlayViewController.swift
//  Gridy
//
//  Created by Carl Wainwright on 03/09/2018.
//  Copyright © 2018 Carl Wainwright. All rights reserved.
//

import Foundation
import UIKit

class GamePlayViewController: UIViewController {
    
    fileprivate var gamePlayFlowController : GamePlayFlowController!
    fileprivate var gamePlayViewModel : GamePlayViewModel!
    fileprivate var imageEditorViewModel : ImageEditorViewModel!
    var photoArray: [UIImage] = []

    var shuffledPhoto: [UIImage] = []
    var gridSize = Int()

    @IBOutlet weak var userSelectedImage: UIImageView!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gridSize = gamePlayViewModel.gridSize
        userSelectedImage.image = gamePlayViewModel.photo
        //split photo into segments
        photoArray = gamePlayViewModel.photo.splitImage(gridSize, gridSize)

        //randomize the split photo
        for _ in 0..<photoArray.count {
            let rand = Int(arc4random_uniform(UInt32(photoArray.count)))
            shuffledPhoto.append(photoArray[rand])
            photoArray.remove(at: rand)
//            print (shuffledPhoto.indices)
        }

    }
    
    
    func assignDependancies(gamePlayFlowController: GamePlayFlowController, gamePlayViewModel: GamePlayViewModel){
        self.gamePlayFlowController = gamePlayFlowController
        self.gamePlayViewModel = gamePlayViewModel
    }
}

