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
    var completePuzzle = UIImageView()

    @IBOutlet weak var hint: UIButton!
    @IBOutlet weak var puzzleGrid: Grid!
    @IBOutlet weak var gamePlayCollectionView: GamePlayCollectionView!
   
    @IBAction func hint(_ sender: UIButton) {
        //create size and location for hintView
        let hintImageView = UIImageView(image: gamePlayViewModel.photo)
        hintImageView.frame.size = CGSize(width: puzzleGrid.frame.width, height: puzzleGrid.frame.height)
        hintImageView.center = puzzleGrid.center
        completePuzzle = hintImageView
        completePuzzle.alpha = 0
        self.view.addSubview(completePuzzle)
        completePuzzle.fadeIn()
        //wait 2 seconds from code run to run fadeout
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.completePuzzle.fadeOut()
        }
        //wait 6 seconds from code run to remove temp image from superview
        DispatchQueue.main.asyncAfter(deadline: .now() + 6) {
            self.completePuzzle.removeFromSuperview()
            
        }
        
    }
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        let location = sender.location(in: view)
        dragView.center = location
        if sender.state == .ended {
            let puzzleCellLocation = sender.location(in: view)
            //if location of dragview is outseide of the grid
            if (puzzleCellLocation.x < puzzleGrid.frame.minX) || (puzzleCellLocation.x > puzzleGrid.frame.maxX) || (puzzleCellLocation.y < puzzleGrid.frame.minY) || (puzzleCellLocation.y > puzzleGrid.frame.maxY) {

                //add image from dragView back to array
                gamePlayCollectionView.puzzleImages.append(dragView.image!)
                //reload UICollectionView to show added cell
                gamePlayCollectionView.reloadData()
                //delecte dragView
                dragView.removeFromSuperview()
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
        
    }
    
    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
        let panGesture = UIPanGestureRecognizer(target:self, action: #selector(handlePan(sender:)))
        dragView.addGestureRecognizer(panGesture)
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

