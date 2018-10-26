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
    fileprivate var gamePlayUICollectionViewCell: GamePlayUICollectionViewCell!

    var gridSize = Int()
    var dragView = UIImageView()

    @IBOutlet weak var puzzleGrid: Grid!
    
    @IBOutlet weak var gamePlayCollectionView: GamePlayCollectionView!
//    
//    @objc func handlePan(sender: UIPanGestureRecognizer) {
//        let location = sender.location(in: view)
//        gamePlayCollectionView.center = location
//    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //load grid with correct number of cells
        puzzleGrid.gridSize = CGFloat(gamePlayViewModel.gridSize)
        gridSize = gamePlayViewModel.gridSize
        gamePlayCollectionView.puzzleImages = gamePlayViewModel.photoArray
        gamePlayCollectionView.gamePlayViewController = self
        
//        Thread 1: Fatal error: Unexpectedly found nil while unwrapping an Optional value
//        gridSize = gamePlayViewModel.gridSize
//         gamePlayCollectionView.puzzleImages = gamePlayViewModel.photoArray
        
//        let panGesture = UIPanGestureRecognizer(target:self, action: #selector(handlePan(sender:)))
//        gamePlayCollectionView.addGestureRecognizer(panGesture)
        
        


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewDidAppear(true)
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

