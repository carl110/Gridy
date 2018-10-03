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

    @IBOutlet weak var puzzleGrid: Grid!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.collectionView)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPoint.zero, in: self.collectionView)

        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gridSize = gamePlayViewModel.gridSize

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

