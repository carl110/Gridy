//
//  Main Flow Controller.swift
//  Gridy
//
//  Created by Carl Wainwright on 27/08/2018.
//  Copyright © 2018 Carl Wainwright. All rights reserved.
//

import Foundation
import UIKit

class MainFlowController {
    
    let navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func showImageEditor(with photo: UIImage) {

        ImageEditorFactory.PushIn(navigationController: navigationController, photo: photo)
    
    }
    
}
