//
//  UIAlertController+extensions.swift
//  Gridy
//
//  Created by Carl Wainwright on 20/11/2018.
//  Copyright © 2018 Carl Wainwright. All rights reserved.
//

import Foundation
import UIKit

extension UIAlertController {
    
    //to stop the following warning : ERROR: -[UIAlertController supportedInterfaceOrientations] was invoked recursively! Instead of using presentingViewController = <UINavigationController: ...>, will return super's value
    open override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.all
    }
    open override var shouldAutorotate: Bool {
        return false
    }
}
