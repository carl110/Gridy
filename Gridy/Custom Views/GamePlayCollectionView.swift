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

class GamePlayCollectionView: UICollectionView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var gamePlayViewController: GamePlayViewController!
    var gamePlayDelegate: GamePlayDelegate? = nil
    //create empty array fo puzzleImages
    var puzzleImages: [UIImage] = []
    //declare sound for use
    var magicSound: AVAudioPlayer?
    var soundVolume: Float = 0
    //initial location of touch to allow removal of cell
    var initialTouchLocation: CGPoint!
    
    override func awakeFromNib() {
        delegate = self
        dataSource = self
    }
    //calculate the location of the inital touch
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        initialTouchLocation = touches.first!.location(in: gamePlayViewController.gamePlayCollectionView)
    }
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return puzzleImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! GamePlayUICollectionViewCell
        cell.config(puzzleImages: puzzleImages[indexPath.row])
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureHandler(sender:)))
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
                let puzzleCellLocation = sender.location(in: gamePlayViewController.view)
               //check if puzzle piece is within the puzzleGrid
                if gamePlayViewController.puzzleGrid.frame.contains(puzzleCellLocation) {
                    UIView.animate(withDuration: 0.3) {
                        //Use extension Loop to see which cell the piece is closest to
                        self.gamePlayViewController.dragView.center = self.gamePlayViewController.cellCoordinatesArray.closetsCell(nonFixedLocation: puzzleCellLocation, hyp: self.gamePlayViewController.halfCellHypotenuse)
                        //locate sound file
                        let path = Bundle.main.path(forResource: "magicWand", ofType: nil)!
                        //create path for sound file
                        let url = URL(fileURLWithPath: path)
                        //find and play sound file
                        do {
                            self.magicSound = try AVAudioPlayer(contentsOf: url)
                            self.magicSound?.play()
                            self.magicSound?.volume = self.soundVolume
                        } catch {
                            print("unable to find file")
                        }
                        //use initialTouchLocation coordinates to work out which cell was pressed and remove from the puzzleImages array
                        if let indexPath = self.gamePlayViewController.gamePlayCollectionView.indexPathForItem(at: self.initialTouchLocation) {
                            //works fine when all cells are visable
                            self.puzzleImages.remove(at: indexPath.item)
                            self.gamePlayViewController.gamePlayCollectionView.deleteItems(at: [indexPath])
                            self.gamePlayDelegate?.didEnd()
                        }
                    }
                }
                    // if puzzlePiece location outside of puzzleGrid area then remove the created piece and unhide cell in collectionView
                else {
                    gamePlayViewController.dragView.removeFromSuperview()
                }
                cellView.isHidden = false
            default : break
            }
        }
    }
}
