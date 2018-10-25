//
//  GamePlayCollectionView.swift
//  Gridy
//
//  Created by Carl Wainwright on 15/10/2018.
//  Copyright © 2018 Carl Wainwright. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class GamePlayCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource,UIGestureRecognizerDelegate {
    
    var gamePlayViewController: GamePlayViewController!
    
    override func awakeFromNib() {
        delegate = self
        dataSource = self
    }
    //create empty array fo puzzleImages
    var puzzleImages: [UIImage] = []
    //declare sound for use
    var magicSound: AVAudioPlayer?
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print (puzzleImages.count)
        return puzzleImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GamePlayUICollectionViewCell", for: indexPath) as! GamePlayUICollectionViewCell
        cell.config(puzzleImages: puzzleImages[indexPath.row])
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureHandler(sender:)))
        longPressGesture.delegate = self
        cell.userImageView.addGestureRecognizer(longPressGesture)
        return cell
    }
    
    @objc func longPressGestureHandler(sender:UILongPressGestureRecognizer) {
        //capture image of the cell
        if let cellView = sender.view {
            let cellImageView = cellView as? UIImageView
            //create new Image of the image chosen
            let newImageView = UIImageView(image: cellImageView?.image)
            
            //look at state of gesture
            switch sender.state {
            case .began:
                print ("longPress began")

                //locate sound file
                let path = Bundle.main.path(forResource: "magicWand", ofType: nil)!
                //create path for sound file
                let url = URL(fileURLWithPath: path)
                //find and play sound file
                do {
                    magicSound = try AVAudioPlayer(contentsOf: url)
                    magicSound?.play()
                } catch {
                    print("unable to find file")
                }
                //Hide the cell in collectionView
                cellView.isHidden = true
                //Thread 1: Fatal error: Unexpectedly found nil while unwrapping an Optional value
                newImageView.frame.size = CGSize(width: gamePlayViewController.puzzleGrid.frame.width / CGFloat(gamePlayViewController.gridSize), height: gamePlayViewController.puzzleGrid.frame.height / CGFloat(gamePlayViewController.gridSize))
                newImageView.center = sender.location(in: gamePlayViewController.view)
                gamePlayViewController.dragView = newImageView
                gamePlayViewController.view.addSubview(gamePlayViewController.dragView)
            case .changed:
                print ("longPress changed")
                //define cell and location to allow dragging
                let cell = gamePlayViewController.dragView
                let location = sender.location(in: gamePlayViewController.view)
                            cell.center = CGPoint (x: cell.center.x + (location.x - cell.center.x), y: cell.center.y + (location.y - cell.center.y))
            case .ended:
                print ("longPress ended")
                // if puzzlePiece location outside of puzzleGrid area then remove the created piece and unhide cell in collectionView
                let puzzleCellLocation = sender.location(in: gamePlayViewController.view)
                if (puzzleCellLocation.x < gamePlayViewController.puzzleGrid.frame.minX) || (puzzleCellLocation.x > gamePlayViewController.puzzleGrid.frame.maxX) || (puzzleCellLocation.y < gamePlayViewController.puzzleGrid.frame.minY) || (puzzleCellLocation.y > gamePlayViewController.puzzleGrid.frame.maxY) {
                    gamePlayViewController.dragView.removeFromSuperview()
                    cellView.isHidden = false
                } else {
                    let puzzleCellSize = gamePlayViewController.puzzleGrid.frame.width / CGFloat(gamePlayViewController.gridSize)
                    
//                    let gridSizeSquared: Int = Int(pow(CGFloat(gamePlayViewController.gridSize),2))
                    for cellsInGridByX in 0...gamePlayViewController.gridSize {

                        if (puzzleCellLocation.x > gamePlayViewController.puzzleGrid.frame.minX + (CGFloat(cellsInGridByX) * puzzleCellSize)) && (puzzleCellLocation.x < (gamePlayViewController.puzzleGrid.frame.minX + (puzzleCellSize * CGFloat(cellsInGridByX)) + puzzleCellSize)) {
                            for cellsInGridByY in 0...gamePlayViewController.gridSize {
                                if (puzzleCellLocation.y > gamePlayViewController.puzzleGrid.frame.minY + (CGFloat(cellsInGridByY) * puzzleCellSize)) && (puzzleCellLocation.y < (gamePlayViewController.puzzleGrid.frame.minY + (puzzleCellSize * CGFloat(cellsInGridByY)) + puzzleCellSize)) {
                            }
                            UIView.animate(withDuration: 0.3) {
                                self.gamePlayViewController.dragView.center = CGPoint(x: self.gamePlayViewController.puzzleGrid.frame.minX + (puzzleCellSize * CGFloat(cellsInGridByX)) + (puzzleCellSize / 2), y: self.gamePlayViewController.puzzleGrid.frame.minY + (puzzleCellSize * CGFloat(cellsInGridByY)) + (puzzleCellSize / 2))
                                print (self.gamePlayViewController.puzzleGrid.frame.minY + (puzzleCellSize * CGFloat(cellsInGridByY)) + (puzzleCellSize / 2))
                                print (self.gamePlayViewController.puzzleGrid.frame.minX + (puzzleCellSize * CGFloat(cellsInGridByX)) + (puzzleCellSize / 2))
                                
                            }
                            //                        puzzleCellLocation = gamePlayViewController.puzzleGrid.frame.width
                            
                        }
                        }
                    }
                }

            default :
                print("Default")
            }
        }
    }
}

///    @IBAction func handleLongTap(recognizer: UILongPressGestureRecognizer) {
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
