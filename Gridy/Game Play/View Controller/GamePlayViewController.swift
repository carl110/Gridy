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


    @IBOutlet weak var puzzleGrid: Grid!
    
    @IBOutlet weak var gamePlayCollectionView: GamePlayCollectionView!
    
//    @IBAction func handleLongTap(recognizer: UILongPressGestureRecognizer) {
//        let chosen = recognizer.location(in: self.collectionView)
//        //identify cell that was pressed
//        if let indexPath = self.collectionView.indexPathForItem(at: chosen) {
//            let cell = self.collectionView.cellForItem(at: indexPath)
//        if recognizer.state == .began {
//                cell?.removeFromSuperview()
//                self.view.addSubview(cell!)
//        }
//            else if recognizer.state == .changed {
//                guard let view = cell else {
//                    return
//                }
//                let location = recognizer.location(in: self.view)
//                view.center = CGPoint (x: view.center.x + (location.x - view.center.x), y: view.center.y + (location.y - view.center.y))
//    
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        let location = sender.location(in: view)
        gamePlayCollectionView.center = location
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        gridSize = gamePlayViewModel.gridSize
         gamePlayCollectionView.puzzleImages = gamePlayViewModel.photoArray
        
        let panGesture = UIPanGestureRecognizer(target:self, action: #selector(handlePan(sender:)))
        gamePlayCollectionView.addGestureRecognizer(panGesture)
        


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

