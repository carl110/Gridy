//
//  ImageEditorFactory.swift
//  Gridy
//
//  Created by Carl Wainwright on 03/09/2018.
//  Copyright © 2018 Carl Wainwright. All rights reserved.
//

import Foundation
import UIKit

class ImageEditorFactory {
    
    static func PushIn(navigationController: UINavigationController, photo: UIImage) {
        
        let imageEditor = UIStoryboard(name: "ImageEditor", bundle: nil).instantiateInitialViewController() as! ImageEditorViewController
        let imageEditorFlowController = ImageEditorFlowController(navigationController: navigationController)
        let imageEditorViewModel = ImageEditorViewModel()
        imageEditor.assignDependancies(imageEditorFlowController: imageEditorFlowController, imageEditorViewModel: imageEditorViewModel)
        
        navigationController.pushViewController(imageEditor, animated: true)
        
    }
}
