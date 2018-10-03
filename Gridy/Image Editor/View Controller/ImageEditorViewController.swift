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
//    let grid = Grid()
    var gridSize = 4

    @IBOutlet weak var gridStepper: UIStepper!
    @IBOutlet weak var stepperLabel: UILabel!
    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var gridView: Grid!
    @IBOutlet weak var selectImage: UIButton!
    
    
    @IBAction func gridStepper(_ sender: UIStepper) {

        stepperLabel.text = Int(sender.value).description
        gridView.gridSize = CGFloat(Int(sender.value))
        gridSize = Int(sender.value)
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
        //use of superview to ensure pan uses orientation of screen for pan and not the image(without image pan would be backwards if image rotated)
        let translation = recognizer.translation(in: self.imageView.superview)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPoint.zero, in: self.imageView.superview)
        
        if recognizer.state == .ended {
            endGesture()
        }
    }
    @IBAction func handleRotate(recognizer : UIRotationGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = view.transform.rotated(by: recognizer.rotation)
            recognizer.rotation = 0

        }
        if recognizer.state == .ended {
            endGesture()
        }
    }
    @IBAction func handlePinch(recognizer : UIPinchGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = view.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
            recognizer.scale = 1
        }
        if recognizer.state == .ended {
            endGesture()
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
        //set initial value then min and max
        gridStepper.value = 4
        //check if device being used is iPad
        if (UIDevice.current.userInterfaceIdiom == UIUserInterfaceIdiom.pad)
        {
            // Ipad
            gridStepper.maximumValue = 10
        }
        else
        {
            // Iphone
            gridStepper.maximumValue = 6
        }
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
    
    func endGesture() {


        var rotation = atan2(imageView.transform.b, imageView.transform.a)
        rotation = rotation * CGFloat((180 / Double.pi))

        if (30 ... 60).contains(rotation) || (120 ... 150).contains(rotation) || (-60 ... -30).contains(rotation) || (-150 ... -120).contains(rotation) {
            UIView.animate(withDuration: 0.3) {
                self.imageView.frame.size.width = 1.25 * self.gridView.frame.size.width
                self.imageView.center = self.gridView.center
            }
        }
        else {
            if imageView.frame.width < gridView.frame.width || imageView.frame.height < gridView.frame.height {
                UIView.animate(withDuration: 0.3) {
                    self.imageView.frame.size.width = self.gridView.frame.size.width
                    self.imageView.center = self.gridView.center
                }
            }
        }
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
                
                self.imageView.frame.origin.x = (self.gridView.frame.minX + (self.gridView.frame.width - self.imageView.frame.width))
            }
        }
        //bottom
        if imageView.frame.minY <= gridView.frame.minY && (imageView.frame.minY + imageView.frame.height) < (gridView.frame.minY + gridView.frame.height) {
            UIView.animate(withDuration: 0.3) {
                //                self.imageView.center = self.gridView.center
                self.imageView.frame.origin.y = (self.gridView.frame.minY + ((self.gridView.frame.height - self.imageView.frame.height)))
            }
        }
    }
    
    func assignDependancies(imageEditorFlowController: ImageEditorFlowController, imageEditorViewModel: ImageEditorViewModel){
        self.imageEditorFlowController = imageEditorFlowController
        self.imageEditorViewModel = imageEditorViewModel
    }
    //Allows all gestures to be used at the same time - requires UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
