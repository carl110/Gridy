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


protocol GamePlayDelegate {
    func didEnd()
}


class GamePlayCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource,UIGestureRecognizerDelegate {
    
    var gamePlayViewController: GamePlayViewController!
    var gamePlayDelegate: GamePlayDelegate? = nil

    override func awakeFromNib() {
        delegate = self
        dataSource = self
    }
    //create empty array fo puzzleImages
    var puzzleImages: [UIImage] = []
    //declare sound for use
    var magicSound: AVAudioPlayer?
    //initial location of touch to allow removal of cell
    var initialTouchLocation: CGPoint!
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print ("GamePlayCollectionView puzzleImages,count\(puzzleImages.count)")
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
    

    //calculate the location of the inital touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        initialTouchLocation = touches.first!.location(in: gamePlayViewController.gamePlayCollectionView)
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
                print ("Long Press Began")
                
                //Hide the cell in collectionView
                cellView.isHidden = true
                //Thread 1: Fatal error: Unexpectedly found nil while unwrapping an Optional value
                newImageView.frame.size = CGSize(width: gamePlayViewController.puzzleGrid.frame.width / CGFloat(gamePlayViewController.gridSize), height: gamePlayViewController.puzzleGrid.frame.height / CGFloat(gamePlayViewController.gridSize))
                newImageView.center = sender.location(in: gamePlayViewController.view)
                gamePlayViewController.dragView = newImageView
                gamePlayViewController.view.addSubview(gamePlayViewController.dragView)
                gamePlayViewController.dragView.isUserInteractionEnabled = true
            case .changed:
                //define cell and location to allow dragging
                let dragViewCell = gamePlayViewController.dragView
                let location = sender.location(in: gamePlayViewController.view)
                            dragViewCell.center = CGPoint (x: dragViewCell.center.x + (location.x - dragViewCell.center.x), y: dragViewCell.center.y + (location.y - dragViewCell.center.y))
            case .ended:
                // if puzzlePiece location outside of puzzleGrid area then remove the created piece and unhide cell in collectionView
                let puzzleCellLocation = sender.location(in: gamePlayViewController.view)
                if (puzzleCellLocation.x < gamePlayViewController.puzzleGrid.frame.minX) || (puzzleCellLocation.x > gamePlayViewController.puzzleGrid.frame.maxX) || (puzzleCellLocation.y < gamePlayViewController.puzzleGrid.frame.minY) || (puzzleCellLocation.y > gamePlayViewController.puzzleGrid.frame.maxY) {
                    gamePlayViewController.dragView.removeFromSuperview()
                    cellView.isHidden = false
                } else { //puzzle piece within the puzzle grid
                    let puzzleCellSize = gamePlayViewController.puzzleGrid.frame.width / CGFloat(gamePlayViewController.gridSize)
                    //loop to see where puzzle piece is and snap to closest cell
                    for cellsInGridByX in 0...gamePlayViewController.gridSize {
                        if (puzzleCellLocation.x > gamePlayViewController.puzzleGrid.frame.minX + (CGFloat(cellsInGridByX) * puzzleCellSize)) && (puzzleCellLocation.x < (gamePlayViewController.puzzleGrid.frame.minX + (puzzleCellSize * CGFloat(cellsInGridByX)) + puzzleCellSize)) {
                            for cellsInGridByY in 0...gamePlayViewController.gridSize {
                                if (puzzleCellLocation.y > gamePlayViewController.puzzleGrid.frame.minY + (CGFloat(cellsInGridByY) * puzzleCellSize)) && (puzzleCellLocation.y < (gamePlayViewController.puzzleGrid.frame.minY + (puzzleCellSize * CGFloat(cellsInGridByY)) + puzzleCellSize)) {
                                    UIView.animate(withDuration: 0.3) {
                                        self.gamePlayViewController.dragView.center = CGPoint(x:
                                            self.gamePlayViewController.puzzleGrid.frame.minX + (puzzleCellSize * CGFloat(cellsInGridByX)) + (puzzleCellSize / 2), y:
                                            self.gamePlayViewController.puzzleGrid.frame.minY + (puzzleCellSize * CGFloat(cellsInGridByY)) + (puzzleCellSize / 2))
                                        //locate sound file
                                        let path = Bundle.main.path(forResource: "magicWand", ofType: nil)!
                                        //create path for sound file
                                        let url = URL(fileURLWithPath: path)
                                        //find and play sound file
                                        do {
                                            self.magicSound = try AVAudioPlayer(contentsOf: url)
                                            self.magicSound?.play()
                                        } catch {
                                            print("unable to find file")
                                        }
                                        //use initialTouchLocation coordinates to work out which cell was pressed and remove from the puzzleImages array
                                        if let indexPath = self.gamePlayViewController.gamePlayCollectionView.indexPathForItem(at: self.initialTouchLocation) {
                                            //works fine when all cells are visable
                                            self.puzzleImages.remove(at: indexPath.item)
                                            self.gamePlayViewController.gamePlayCollectionView.deleteItems(at: [indexPath])
                      
                                            print ("indexPath \(indexPath)")
                                            print ("indexPath item \(String(describing: self.gamePlayViewController.gamePlayCollectionView.indexPathForItem(at: self.initialTouchLocation)))")
                                       
                                            
                                            self.gamePlayDelegate?.didEnd()

                                        }
                                    }
                                }
                            }
                        }
                    }

                }
            default : break
            }
        }
    }
}
