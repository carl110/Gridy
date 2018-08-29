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
        
        guard
            let imageViewSize = self.imageView?.frame.size,
            let titleLabelSize = self.titleLabel?.frame.size else {
                return
        }
        let totalHeight = imageViewSize.height + titleLabelSize.height
        
        let colour = UIColor( red: CGFloat(243/255.0), green: CGFloat(233/255.0), blue: CGFloat(210/255.0), alpha: CGFloat(1.0) )

        let buttonFont = "Helvetica Neue"
        let buttonWidth = 120
        let buttonHeight = 100
        



        
        self.frame.size = CGSize(width: buttonWidth, height: buttonHeight)

        self.layer.cornerRadius = 8

        self.backgroundColor = colour
        
        self.setTitleColor(UIColor.black, for: .normal)

        self.titleLabel?.font = UIFont (name: buttonFont, size: 16)
        self.titleLabel?.adjustsFontSizeToFitWidth = true


        self.imageEdgeInsets = UIEdgeInsets(
            top: -(totalHeight - imageViewSize.height + 10),
            left: 0.0,
            bottom: 0.0,
            right: -titleLabelSize.width - 10
        )
        
        self.titleEdgeInsets = UIEdgeInsets(
            top: 0.0,
            left: -imageViewSize.width,
            bottom: -(totalHeight - titleLabelSize.height + 10),
            right: 0.0
        )

    }
}
