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
    //set econds for timer
    var seconds = 10
    //declare NSObject Timer
    var timer = Timer()
    var imageLocationDictionary: [UIImage:CGPoint] = [:]
    
    @IBOutlet weak var countDownTimer: UILabel!
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
        countDownTimer.alpha = 0
        //load grid with correct number of cells
        puzzleGrid.gridSize = CGFloat(gamePlayViewModel.gridSize)
        gridSize = gamePlayViewModel.gridSize
        gamePlayCollectionView.puzzleImages = gamePlayViewModel.shuffledphotoArray
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
        
        imageLocationDictionary = Dictionary(uniqueKeysWithValues: zip(gamePlayViewModel.orderedPhotoArray, cellCoordinatesArray))
        
//        imageLocationDictionary = [gamePlayViewModel.orderedPhotoArray:cellCoordinatesArray]
//        let dict = cellCoordinatesArray.toDictionary

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
        //Start Timer
        runTimer()
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
            self.countDownTimer.fadeIn()
            self.completePuzzle.fadeOut()
        }
        //wait 8 seconds first time then an extra 10 seconds each time
        DispatchQueue.main.asyncAfter(deadline: .now() + additionalTime) {
            self.completePuzzle.removeFromSuperview()
            self.hint.enableButton()
            //Stop timer
            self.timer.invalidate()
            //Set timer to new value
            self.seconds = Int(self.additionalTime)
            self.countDownTimer.alpha = 0
        }
        additionalTime += 10.1
    }
    @objc func handlePan(sender: UIPanGestureRecognizer) {
        //declare puzzlepiece
        let puzzlePiece = sender.view as! UIImageView
        let location = sender.location(in: view)
        //set currently pressed puzzlepiece to be on top
        self.view.bringSubviewToFront(puzzlePiece)
        sender.view?.center = location
        if sender.state == .ended {
            
            if (self.view.subviews.filter{ $0.center == (self.cellCoordinatesArray.closestCell(nonFixedLocation: location, hyp: self.halfCellHypotenuse)) }).count == 0 {
                
                print (sender.view?.center as Any)
                
            }
            if puzzleGrid.frame.contains(location) {
                UIView.animate(withDuration: 0.3) {
                    //check if the cell already contains a puzzlepiece
                    if (self.view.subviews.filter{ $0.center == (self.cellCoordinatesArray.closestCell(nonFixedLocation: location, hyp: self.halfCellHypotenuse)) }).count == 0 {
                        //loop to see where puzzle piece is and snap to closest cell
                        sender.view?.center = self.cellCoordinatesArray.closestCell(nonFixedLocation: location, hyp: self.halfCellHypotenuse) } else {
                        //add image from puzzlePiece back to array
                        self.gamePlayCollectionView.puzzleImages.append(puzzlePiece.image!)
                        //reload UICollectionView to show added cell
                        self.gamePlayCollectionView.reloadData()
                        //delete dragView
                        puzzlePiece.removeFromSuperview()
                    }
                }
            } else {
                //add image from puzzlePiece back to array
                gamePlayCollectionView.puzzleImages.append(puzzlePiece.image!)
                //reload UICollectionView to show added cell
                gamePlayCollectionView.reloadData()
                //delete dragView
                puzzlePiece.removeFromSuperview()
                scoreCount += 1
                
            }
//            for (index, element) in cellCoordinatesArray.enumerated() {
//                print ("Item \(index): \(element)")
//            }
//            var cellIndex = cellCoordinatesArray.index(of: (sender.view?.center)!)
//            print (cellIndex)
////
//            print (gamePlayViewModel.orderedPhotoArray[cellIndex!])
//
//            print (imageLocationDictionary)

            
            scoreCount += 1
            score.text = "Score : \(scoreCount)"
        }
    }
    
    
    func didEnd() {
        let panGesture = UIPanGestureRecognizer(target:self, action: #selector(handlePan(sender:)))
        view.subviews.last!.addGestureRecognizer(panGesture)
        gamePlayCollectionView.reloadData()
    }
    //set timer to use seconds (timerinterval)
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(updatedTimer)), userInfo: nil, repeats: true)
    }
    //Sets timer to countdown in intervals of 1
    @objc func updatedTimer() {
        seconds -= 1
        countDownTimer.text = "\(seconds)"
    }
    
    func assignDependancies(gamePlayFlowController: GamePlayFlowController, gamePlayViewModel: GamePlayViewModel){
        self.gamePlayFlowController = gamePlayFlowController
        self.gamePlayViewModel = gamePlayViewModel
    }
}

