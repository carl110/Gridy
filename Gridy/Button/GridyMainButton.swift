//
//  GridyMainButton.swift
//  Gridy
//
//  Created by Carl Wainwright on 24/08/2018.
//  Copyright © 2018 Carl Wainwright. All rights reserved.
//

import Foundation
import UIKit

class GridyMainButton: UIButton {
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let color = UIColor( red: CGFloat(243/255.0), green: CGFloat(233/255.0), blue: CGFloat(210/255.0), alpha: CGFloat(1.0) )
        
        let buttonFont = "Helvetica Neue"
        let buttonWidth = 100
        let buttonHeight = 100
        
        self.frame.size = CGSize(width: buttonWidth, height: buttonHeight)
//        self.frame.origin = CGPoint(x: (((superview?.frame.width)! / 2) - (self.frame.width / 2)), y: self.frame.origin.y)
        
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
//        self.layer.borderWidth = 3
        
        self.backgroundColor = color
        
        self.setTitleColor(UIColor.black, for: .normal)

        self.titleLabel?.font = UIFont (name: buttonFont, size: 16)
        self.titleLabel?.adjustsFontSizeToFitWidth = true


    }
}
