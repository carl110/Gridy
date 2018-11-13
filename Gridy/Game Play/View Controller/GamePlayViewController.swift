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
    var scoreCount = 0
    
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var hint: UIButton!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var puzzleGrid: Grid!
    @IBOutlet weak var gamePlayCollectionView: GamePlayCollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hint.setRadius(radius: 8)
        soundButton.setRadius(radius: 8)
        soundButton.titleLabel?.numberOfLines = 2
        soundButton.centerTextHorizontally(spacing: 2)
        soundButton.setTitle("Sound Off", for: .normal)
        score.setRadius(radius: 8)
        

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
        
        let dict = cellCoordinatesArray.toDictionary
        let dict2 = gamePlayViewModel.orderedPhotoArray.toDictionary
        
        print ("dictionary array\(dict)")
        print (dict2)
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
        sender.view?.center = location
        if sender.state == .ended {
            if puzzleGrid.frame.contains(location) {
                UIView.animate(withDuration: 0.3) {
                    //loop to see where puzzle piece is and snap to closest cell
                    sender.view?.center = self.cellCoordinatesArray.closestCell(nonFixedLocation: location, hyp: self.halfCellHypotenuse)
                }
            } else {
                
                let puzzlePieceImage = sender.view as! UIImageView
                //add image from dragView back to array
                gamePlayCollectionView.puzzleImages.append(puzzlePieceImage.image!)
                //reload UICollectionView to show added cell
                gamePlayCollectionView.reloadData()
                //delete dragView
                puzzlePieceImage.removeFromSuperview()
                
            }
            scoreCount += 1
            score.text = "Score : \(scoreCount)"
        }
    }
    
    func didEnd() {
        let panGesture = UIPanGestureRecognizer(target:self, action: #selector(handlePan(sender:)))
        view.subviews.last!.addGestureRecognizer(panGesture)
        gamePlayCollectionView.reloadData()
    }
    
    func assignDependancies(gamePlayFlowController: GamePlayFlowController, gamePlayViewModel: GamePlayViewModel){
        self.gamePlayFlowController = gamePlayFlowController
        self.gamePlayViewModel = gamePlayViewModel
    }
}

