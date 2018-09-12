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

    
    func blurView(style: UIBlurEffectStyle) {
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.bounds
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        //Add hole to blur view
        let scanLayer = CAShapeLayer()
        //Size of hole (need to find wa to autosize with the Grid
        let scanRect = CGRect.init(x: 30, y: 170, width: 315, height: 315)
        
        let outerPath = UIBezierPath(rect: scanRect)
        
        let superlayerPath = UIBezierPath.init(rect: blurView.frame)
//        outerPath.usesEvenOddFillRule = true
        outerPath.append(superlayerPath)
        scanLayer.path = outerPath.cgPath
        scanLayer.fillRule = kCAFillRuleEvenOdd
//        scanLayer.fillColor = UIColor.black.cgColor
        
       addSubview(blurView)
        blurView.layer.mask = scanLayer
   
    }

}


