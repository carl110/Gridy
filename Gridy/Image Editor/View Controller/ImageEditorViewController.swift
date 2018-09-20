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
    fileprivate var gridSize = 4

    @IBOutlet weak var blurView: UIView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var gridView: Grid!
    @IBOutlet weak var selectImage: UIButton!
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
    }
    @IBAction func handleRotate(recognizer : UIRotationGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = view.transform.rotated(by: recognizer.rotation)
            recognizer.rotation = 0
        }
    }
    @IBAction func handlePinch(recognizer : UIPinchGestureRecognizer) {
        if let view = recognizer.view {
            view.transform = view.transform.scaledBy(x: recognizer.scale, y: recognizer.scale)
            recognizer.scale = 1
        }
    }
    @IBAction func doubleTap(recognizer: UITapGestureRecognizer) {
            //set number of taps required to initiate function
            recognizer.numberOfTapsRequired = 2
            if let view = recognizer.view {
                //returns to original size and rotation
                view.transform = CGAffineTransform.identity
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
}
