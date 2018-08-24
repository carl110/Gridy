//
//  UIVew+extensions.swift
//  Gridy
//
//  Created by Carl Wainwright on 24/08/2018.
//  Copyright © 2018 Carl Wainwright. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    
    func mainButton (radius:CGFloat) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        
    }
    

}
