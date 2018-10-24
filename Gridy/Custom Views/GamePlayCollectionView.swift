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
    
 
    let gamePlayViewController = GamePlayViewController()

    override func awakeFromNib() {
        delegate = self
        dataSource = self
    }
    
    var puzzleImages: [UIImage] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print (puzzleImages.count)
        return puzzleImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GamePlayUICollectionViewCell", for: indexPath) as! GamePlayUICollectionViewCell
        cell.config(puzzleImages: puzzleImages[indexPath.row])
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureHandler(sender:)))
        longPressGesture.delegate = self
        cell.addGestureRecognizer(longPressGesture)
        return cell
    }
    
    @objc func longPressGestureHandler(sender:UILongPressGestureRecognizer) {
        if let cellView = sender.view {
            //look at state of gesture
            switch sender.state {
            case .began:
                print ("longPress began")
                let cellImageView = cellView as? UIImageView
                //Hide the cell in collectionView
                cellView.isHidden = true
                let newImageView = UIImageView(image: cellImageView?.image)
                //Thread 1: Fatal error: Unexpectedly found nil while unwrapping an Optional value
                newImageView.frame.size = CGSize(width: 20, height: 20)
                newImageView.center = sender.location(in: gamePlayViewController.view)
                gamePlayViewController.dragView = newImageView
                gamePlayViewController.view.addSubview(gamePlayViewController.dragView)
            case .changed:
                print ("longPress changed")
            case .ended:
                print ("longPress ended")
                cellView.isHidden = false
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
