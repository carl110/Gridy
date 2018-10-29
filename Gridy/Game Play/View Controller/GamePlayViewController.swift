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
   
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        let location = sender.location(in: view)
        dragView.center = location
        if sender.state == .ended {
            let puzzleCellLocation = sender.location(in: view)
            //if location of dragview is outseide of the grid
            if (puzzleCellLocation.x < puzzleGrid.frame.minX) || (puzzleCellLocation.x > puzzleGrid.frame.maxX) || (puzzleCellLocation.y < puzzleGrid.frame.minY) || (puzzleCellLocation.y > puzzleGrid.frame.maxY) {
                //delecte dragView
                dragView.removeFromSuperview()
                //add image from dragView back to array
                gamePlayCollectionView.puzzleImages.append(dragView.image!)
                //reload UICollectionView to show added cell
                gamePlayCollectionView.reloadData()
                print ("return cell")
            } else { //puzzle piece within the puzzle grid
                let puzzleCellSize = puzzleGrid.frame.width / CGFloat(gridSize)
                //loop to see where puzzle piece is and snap to closest cell
                for cellsInGridByX in 0...gridSize {
                    if (puzzleCellLocation.x > puzzleGrid.frame.minX + (CGFloat(cellsInGridByX) * puzzleCellSize)) && (puzzleCellLocation.x < (puzzleGrid.frame.minX + (puzzleCellSize * CGFloat(cellsInGridByX)) + puzzleCellSize)) {
                        for cellsInGridByY in 0...gridSize {
                            if (puzzleCellLocation.y > puzzleGrid.frame.minY + (CGFloat(cellsInGridByY) * puzzleCellSize)) && (puzzleCellLocation.y < (puzzleGrid.frame.minY + (puzzleCellSize * CGFloat(cellsInGridByY)) + puzzleCellSize)) {
                                UIView.animate(withDuration: 0.3) {
                                    self.dragView.center = CGPoint(x:
                                        self.puzzleGrid.frame.minX + (puzzleCellSize * CGFloat(cellsInGridByX)) + (puzzleCellSize / 2), y:
                                        self.puzzleGrid.frame.minY + (puzzleCellSize * CGFloat(cellsInGridByY)) + (puzzleCellSize / 2))
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //load grid with correct number of cells
        puzzleGrid.gridSize = CGFloat(gamePlayViewModel.gridSize)
        gridSize = gamePlayViewModel.gridSize
        gamePlayCollectionView.puzzleImages = gamePlayViewModel.photoArray
        gamePlayCollectionView.gamePlayViewController = self
        let panGesture = UIPanGestureRecognizer(target:self, action: #selector(handlePan(sender:)))
        self.view.addGestureRecognizer(panGesture)
    }

    func assignDependancies(gamePlayFlowController: GamePlayFlowController, gamePlayViewModel: GamePlayViewModel){
        self.gamePlayFlowController = gamePlayFlowController
        self.gamePlayViewModel = gamePlayViewModel
    }
}

