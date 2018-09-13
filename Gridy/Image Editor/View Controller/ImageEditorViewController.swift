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
    
    
//    let VC = ViewController()
    
    func assignDependancies(imageEditorFlowController: ImageEditorFlowController, imageEditorViewModel: ImageEditorViewModel){
        self.imageEditorFlowController = imageEditorFlowController
        self.imageEditorViewModel = imageEditorViewModel
    }
    
    @IBOutlet weak var blurView: UIView!
    
    @IBOutlet weak var imageView: UIImageView!

    @IBOutlet weak var gridView: Grid!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        imageView.image = imageEditorViewModel.photo
        blurView.blurView(style: .regular)

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
    //Allows all gestures to be used at the same time - requires UIGestureRecognizerDelegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

}
