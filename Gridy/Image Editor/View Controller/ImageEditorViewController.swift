//
//  ImageEditorViewController.swift
//  Gridy
//
//  Created by Carl Wainwright on 03/09/2018.
//  Copyright © 2018 Carl Wainwright. All rights reserved.
//

import Foundation
import UIKit

class ImageEditorViewController: UIViewController, UIGestureRecognizerDelegate {
    
    fileprivate var imageEditorFlowController : ImageEditorFlowController!
    fileprivate var imageEditorViewModel : ImageEditorViewModel!
    //create empty contained for UIImage
    fileprivate var selectedImage: UIImage!
    let grid = Grid()
    var gridSize = 4

    @IBOutlet weak var gridStepper: UIStepper!
    @IBOutlet weak var stepperLabel: UILabel!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var gridView: Grid!
    @IBOutlet weak var selectImage: UIButton!
    
    
    @IBAction func gridStepper(_ sender: UIStepper) {
        stepperLabel.text = Int(sender.value).description
        grid.gridSize = CGFloat(Int(sender.value))
        gridSize = Int(sender.value)
        print (Int(sender.value))
        print ("grid \(grid.gridSize)")


    }
    
    @IBAction func selectImage(_ sender: UIButton) {
        //hide grid so screenshot of user defined image is only the image
        gridView.isHidden = true
        //take snapshot of image manipulated by used and set as selectedImage
        selectedImage = self.view.snapshot(of: CGRect(x: gridView.frame.origin.x, y: gridView.frame.origin.y, width: gridView.frame.width, height: gridView.frame.height))
        //goto showCamePlay pushing above image through
        if let image = selectedImage {
            imageEditorFlowController.showGamePlay(with: image, gridSize: gridSize)
        }
    }
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        
        //Set limit of image pan
        //top
        if imageView.frame.minX > gridView.frame.minX {
            UIView.animate(withDuration: 0.3) {
                self.imageView.frame.origin.x = self.gridView.frame.origin.x
            }
        }
        //left
        if imageView.frame.minY > gridView.frame.minY {
            UIView.animate(withDuration: 0.3) {
                self.imageView.frame.origin.y = self.gridView.frame.origin.y
            }
        }
        //right
        if imageView.frame.minX <= gridView.frame.minX && (imageView.frame.minX + imageView.frame.width) < (gridView.frame.minX + gridView.frame.width) {
            UIView.animate(withDuration: 0.3) {
//                self.imageView.center = self.gridView.center
            self.imageView.frame.origin.x = ((self.gridView.frame.minX + self.gridView.frame.width) - (self.imageView.frame.minX + self.imageView.frame.width))
            }
        }
        //bottom
        if imageView.frame.minY <= gridView.frame.minY && (imageView.frame.minY + imageView.frame.height) < (gridView.frame.minY + gridView.frame.height) {
            UIView.animate(withDuration: 0.3) {
//                self.imageView.center = self.gridView.center
                self.imageView.frame.origin.y = ((self.gridView.frame.minY + self.gridView.frame.height) - (self.imageView.frame.minY + self.imageView.frame.height))
            }
        }
        
        print ("Grid minX \(gridView.frame.minX)")
        print ("minX \(imageView.frame.minX)")
        print ("imageView.frame.width \(imageView.frame.width)")
        print ("gridView.frame.width \(gridView.frame.width)")
        
        print ("imageView.frame.height \(imageView.frame.height)")
        print ("gridView.frame.height \(gridView.frame.height)")
    
    }
    @IBAction func handleRotate(recognizer : UIRotationGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = view.transform.rotated(by: recognizer.rotation)
            recognizer.rotation = 0
        }
//        //show roatetion value
//        var rotation = atan2(imageView.transform.b, imageView.transform.a)
//        rotation = rotation * CGFloat((180 / Double.pi))
//        print (rotation)
    }
    @IBAction func handlePinch(recognizer : UIPinchGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = view.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
            recognizer.scale = 1
        }
        //if picture height and width become less than grid size - resize and centre
        if imageView.frame.size.height < gridView.frame.size.height {
            imageView.frame.size.height = gridView.frame.size.height
            imageView.center = gridView.center
        }
        if imageView.frame.size.width < gridView.frame.size.width {
            imageView.frame.size.width = gridView.frame.size.width
            imageView.center = gridView.center
        }
        if imageView.frame.width < gridView.frame.width {
            imageView.frame.size.width = gridView.frame.size.width
        }
        if imageView.frame.height < gridView.frame.height {
            imageView.frame.size.height = gridView.frame.size.height
        }
    }
    @IBAction func doubleTap(recognizer: UITapGestureRecognizer) {
            //set number of taps required to initiate function
            recognizer.numberOfTapsRequired = 2
            if let view = recognizer.view {


                //returns to original size and rotation
                view.transform = CGAffineTransform.identity
                imageView.frame.size = blurView.frame.size
                //returns image to center
                view.center = self.view.center
            }
        }
    override func viewDidLoad() {
        super.viewDidLoad()
        //set image as image selected from previouse screen
        imageView.image = imageEditorViewModel.photo
        //Add blur to entire view
        blurView.blurView(style: .regular)
        //allows user to keep button pressed to change value
        gridStepper.autorepeat = true
        gridStepper.maximumValue = 10
        gridStepper.minimumValue = 2
        
    }
    //using viewDidLayoutSubview to calculate sizes required for screen used
    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
        //calculate size and position of grid on the current screen used
        let gridViewXLocation = gridView.frame.origin.x
        let gridViewYLocation = gridView.frame.origin.y
        let gridViewWidth = gridView.frame.width
        let gridViewHeight = gridView.bounds.height
        //implament hole in blur in location of grid
        blurView.holeInBlur(xPosition: gridViewXLocation, yPosition: gridViewYLocation, width: gridViewWidth, height: gridViewHeight)
    }
    func assignDependancies(imageEditorFlowController: ImageEditorFlowController, imageEditorViewModel: ImageEditorViewModel){
        self.imageEditorFlowController = imageEditorFlowController
        self.imageEditorViewModel = imageEditorViewModel
    }
    //Allows all gestures to be used at the same time - requires UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
//    func gridSizeSquared() {
//        grid.gridSize = Int(sender.value)
//    }
}
