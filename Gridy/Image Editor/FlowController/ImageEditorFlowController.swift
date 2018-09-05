//
//  ImageEditorFlowController.swift
//  Gridy
//
//  Created by Carl Wainwright on 03/09/2018.
//  Copyright © 2018 Carl Wainwright. All rights reserved.
//

import Foundation
import UIKit

class ImageEditorFlowController {
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func showGamePlay(with photo: UIImage) {
        
        GamePlayFactory.PushIn(navigationController: navigationController, photo: photo)
        
    }
    
}
