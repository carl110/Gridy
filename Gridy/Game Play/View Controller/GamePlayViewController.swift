//
//  GamePlayViewController.swift
//  Gridy
//
//  Created by Carl Wainwright on 03/09/2018.
//  Copyright © 2018 Carl Wainwright. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class GamePlayViewController: UIViewController, GamePlayDelegate {
    
    fileprivate var gamePlayFlowController : GamePlayFlowController!
    fileprivate var gamePlayViewModel : GamePlayViewModel!
    fileprivate var imageEditorViewModel : ImageEditorViewModel!
    fileprivate var gamePlayUICollectionViewCell: GamePlayUICollectionViewCell!
    
    var gridSize = Int()
    var dragView = UIImageView()
    var completePuzzle = UIImageView()
    var additionalTime = 10.0
    //create empty array for cell locations
    var cellCoordinatesArray = [CGPoint]()
    var halfCellHypotenuse = CGFloat()
    var player:AVAudioPlayer = AVAudioPlayer()
    
    @IBOutlet weak var hint: UIButton!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var puzzleGrid: Grid!
    @IBOutlet weak var gamePlayCollectionView: GamePlayCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hint.roundCorners(for: .allCorners, cornerRadius: 8)
        soundButton.roundCorners(for: .allCorners, cornerRadius: 8)
        soundButton.centerTextHorizontally(spacing: 2)
        soundButton.setTitle("Sound Off", for: .normal)

        //load grid with correct number of cells
        puzzleGrid.gridSize = CGFloat(gamePlayViewModel.gridSize)
        gridSize = gamePlayViewModel.gridSize
        gamePlayCollectionView.puzzleImages = gamePlayViewModel.photoArray
        gamePlayCollectionView.gamePlayViewController = self
        gamePlayCollectionView.gamePlayDelegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super .viewDidAppear(true)
        //loop through grid and assign coordinates of each cell to array
        for row in 0...(gridSize - 1) {
            for col in 0...gridSize - 1{
                let puzzleCellSize = puzzleGrid.frame.width / CGFloat(gridSize)
                let arrayItem = CGPoint(x: puzzleGrid.frame.minX + (puzzleCellSize * CGFloat(col)) + (puzzleCellSize / 2), y: puzzleGrid.frame.minY + (puzzleCellSize * CGFloat(row)) + (puzzleCellSize / 2))
                cellCoordinatesArray.append(arrayItem)
            }
        }
        halfCellHypotenuse = (CGFloat(sqrt(pow(Double(Int(puzzleGrid.frame.width) / gridSize), 2.00) + pow(Double(Int(puzzleGrid.frame.width) / gridSize), 2.00)))) / 2
        
    }
    //Stops the rotation of the current screen
    override open var shouldAutorotate: Bool {
        return false
    }
    
    @IBAction func soundButton (_sender: UIButton) {
        
        if gamePlayCollectionView.soundVolume == Float(1) {
            gamePlayCollectionView.soundVolume = 0
            soundButton.setTitle("Sound Off", for: .normal)
        } else {
            gamePlayCollectionView.soundVolume = 1
            soundButton.setTitle("Sound On", for: .normal)
        }
        
        
    }
    @IBAction func hint(_ sender: UIButton) {
        hint.disableButton()
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
        //wait 8 seconds first time then an extra 10 seconds each time
        DispatchQueue.main.asyncAfter(deadline: .now() + additionalTime) {
            self.completePuzzle.removeFromSuperview()
            self.hint.enableButton()
        }
        additionalTime += 10.0
    }
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        let location = sender.location(in: view)
        view.subviews.last!.center = location
        if sender.state == .ended {
            let puzzleCellLocation = sender.location(in: view)
            if puzzleGrid.frame.contains(location) {
                //loop to see where puzzle piece is and snap to closest cell
                for cellLocation in cellCoordinatesArray {
                    if puzzleCellLocation.distance(toPoint: cellLocation) < halfCellHypotenuse {
                        UIView.animate(withDuration: 0.3) {
                            self.dragView.center = cellLocation
                        }
                    }
                }
            } else {
                //add image from dragView back to array
                gamePlayCollectionView.puzzleImages.append(dragView.image!)
                //reload UICollectionView to show added cell
                gamePlayCollectionView.reloadData()
                //delete dragView
                dragView.removeFromSuperview()
            }
        }
    }
    
    func didEnd() {
        let panGesture = UIPanGestureRecognizer(target:self, action: #selector(handlePan(sender:)))
        //        self.puzzleGrid.subviews.last!.addGestureRecognizer(panGesture)
        view.subviews.last!.addGestureRecognizer(panGesture)
        gamePlayCollectionView.reloadData()

        
        //        dragView.addGestureRecognizer(panGesture)
        //        puzzleGrid.subviews.last?.addGestureRecognizer(panGesture)
    }
    
    func assignDependancies(gamePlayFlowController: GamePlayFlowController, gamePlayViewModel: GamePlayViewModel){
        self.gamePlayFlowController = gamePlayFlowController
        self.gamePlayViewModel = gamePlayViewModel
    }
}

