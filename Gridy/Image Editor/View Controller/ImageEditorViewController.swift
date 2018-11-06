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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectImage.roundCorners(for: .allCorners, cornerRadius: 8)
        selectImage.centerTextHorizontally(spacing: 2)
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

    var allGesturesEnded: Bool = true
    var panState: UIGestureRecognizer.State = .ended {
        didSet {
            allGesturesEnded = panState == .ended && pinchState == .ended && rotateState == .ended
        }
    }
    var pinchState: UIGestureRecognizer.State = .ended{
        didSet {
            allGesturesEnded = panState == .ended && pinchState == .ended && rotateState == .ended
        }
    }
    var rotateState: UIGestureRecognizer.State = .ended{
        didSet {
            allGesturesEnded = panState == .ended && pinchState == .ended && rotateState == .ended
        }
    }
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        panState = recognizer.state
        if allGesturesEnded {
            endGesture()
        }
        //use of superview to ensure pan uses orientation of screen for pan and not the image(without image pan would be backwards if image rotated)
        let translation = recognizer.translation(in: self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        
        if recognizer.state == .ended {
        }
    }
    @IBAction func handleRotate(recognizer : UIRotationGestureRecognizer) {
        rotateState = recognizer.state
        if allGesturesEnded {
            endGesture()
        }
        if let view = recognizer.view {
            view.transform = view.transform.rotated(by: recognizer.rotation)
            recognizer.rotation = 0

        }
        if recognizer.state == .ended {

        }
    }
    @IBAction func handlePinch(recognizer : UIPinchGestureRecognizer) {
        pinchState = recognizer.state
        if allGesturesEnded {
            endGesture()
        }
        if let view = recognizer.view {
            view.transform = view.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
            recognizer.scale = 1
        }
        if recognizer.state == .ended {

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
    
    
    func endGesture() {
        
        if imageView.frame.size.width < gridView.frame.size.width || imageView.frame.size.height < gridView.frame.size.height {
            //get current rotation value
            let rotation = atan2(imageView.transform.b, imageView.transform.a)
            print (rotation * CGFloat((180 / Double.pi)))
            //rotate back to origin
            imageView.transform = CGAffineTransform(rotationAngle: CGFloat(2*Double.pi))
            //scale in origin
            imageView.transform = imageView.transform.scaledBy(x: gridView.frame.size.width / imageView.frame.size.width, y: gridView.frame.size.height / imageView.frame.size.height)
            //rotate back to set angle
            imageView.transform = CGAffineTransform(rotationAngle: rotation)
            //centre the imageView
            imageView.center = gridView.center
            
        }
        
        //Set limit of image pan
        //top
        if imageView.frame.minY > gridView.frame.minY {
            UIView.animate(withDuration: 0.3) {
                self.imageView.center = CGPoint(x: self.imageView.center.x, y: self.imageView.center.y - (self.imageView.frame.minY - self.gridView.frame.minY))
            }
        }
        //left
        if imageView.frame.minX > gridView.frame.minX {
            UIView.animate(withDuration: 0.3) {
                self.imageView.center = CGPoint(x: self.imageView.center.x - (self.imageView.frame.minX - self.gridView.frame.minX),
                                                y: self.imageView.center.y)
            }
        }
        //right
        if imageView.frame.maxX < gridView.frame.maxX {
            UIView.animate(withDuration: 0.3) {
                self.imageView.center = CGPoint(x: self.imageView.center.x + (self.gridView.frame.maxX - self.imageView.frame.maxX),
                                                y: self.imageView.center.y)
            }
        }
        //bottom
        if imageView.frame.maxY < gridView.frame.maxY {
            UIView.animate(withDuration: 0.3) {
                self.imageView.center = CGPoint(x: self.imageView.center.x,
                                                y: self.imageView.center.y + (self.gridView.frame.maxY - self.imageView.frame.maxY))
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
