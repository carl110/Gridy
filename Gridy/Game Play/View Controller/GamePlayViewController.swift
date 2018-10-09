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
    
    @IBAction func handleLongTap(recognizer: UILongPressGestureRecognizer) {
        
        let chosen = recognizer.location(in: self.collectionView)
        //identify cell that was pressed
        if let indexPath = self.collectionView.indexPathForItem(at: chosen) {
            
            let cell = self.collectionView.cellForItem(at: indexPath)
            UIView.animate(withDuration: 0.3) {
                cell?.removeFromSuperview()
                
                self.view.addSubview(cell!)

            }
        }

        }
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        let chosen = recognizer.location(in: self.collectionView)
        //identify cell that was pressed
        if let indexPath = self.collectionView.indexPathForItem(at: chosen) {
            
            let cell = self.collectionView.cellForItem(at: indexPath)

        }
        let translation = recognizer.translation(in: self.collectionView)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPoint.zero, in: self.collectionView)
        
        print ("Photo no \(self.collectionView.visibleCells.endIndex)")

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
            print (shuffledPhoto.indices)
        }

    }
    
    
    func assignDependancies(gamePlayFlowController: GamePlayFlowController, gamePlayViewModel: GamePlayViewModel){
        self.gamePlayFlowController = gamePlayFlowController
        self.gamePlayViewModel = gamePlayViewModel
    }
    
    //Allows all gestures to be used at the same time - requires UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

