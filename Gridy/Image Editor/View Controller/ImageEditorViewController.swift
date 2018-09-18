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
    
    var selectedImage: UIImage!
    
    func assignDependancies(imageEditorFlowController: ImageEditorFlowController, imageEditorViewModel: ImageEditorViewModel){
        self.imageEditorFlowController = imageEditorFlowController
        self.imageEditorViewModel = imageEditorViewModel
    }
    
    @IBOutlet weak var blurView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var gridView: Grid!
    
    @IBOutlet weak var selectImage: UIButton!
    
    @IBAction func selectImage(_ sender: UIButton) {
        
        gridView.isHidden = true
        selectedImage = self.view.snapshot(of: CGRect(x: gridView.frame.origin.x, y: gridView.frame.origin.y, width: gridView.frame.width, height: gridView.frame.height))

        if let image = selectedImage {
            imageEditorFlowController.showGamePlay(with: image)
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = imageEditorViewModel.photo
        blurView.blurView(style: .regular)

        print ("view \(gridView.frame.origin.x)")
    }
    
    override func viewDidLayoutSubviews() {
        super .viewDidLayoutSubviews()
        print ("Layout \(gridView.frame.origin.x)")

        let gridViewXLocation = gridView.frame.origin.x
        let gridViewYLocation = gridView.frame.origin.y
        let gridViewWidth = gridView.frame.width
        let gridViewHeight = gridView.bounds.height
        blurView.holeInBlur(xPosition: gridViewXLocation, yPosition: gridViewYLocation, width: gridViewWidth, height: gridViewHeight)
        print ("appear \(gridView.frame.origin.x)")
        
    }
    
    @IBAction func handlePan(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y + translation.y)
            
            
        }
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        
        //            CGFloat scale = 1.0 - (lastScale - pinchscale);
        //            CGRect bounds = [(UIPinchGestureRecognizer*)sender view].bounds;
        //            scale = MIN(scale, maximumHeight / CGRectGetHeight(bounds));
        //            scale = MAX(scale, minimumHeight / CGRectGetHeight(bounds));

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
    
            //        tap.numberOfTapsRequired = 2
            recognizer.numberOfTapsRequired = 2
    
            if let view = recognizer.view {
                //returns to original size and rotation
                view.transform = CGAffineTransform.identity
                //returns image to center
                view.center = self.view.center

            }

        }
    
    //Allows all gestures to be used at the same time - requires UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
}
