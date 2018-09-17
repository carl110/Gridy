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
        addSubview(blurView)
        
        
        
    }
    func holeInBlur(xPosition: CGFloat, yPosition:CGFloat, width: CGFloat, height: CGFloat) {
        
        let xPosition = xPosition
        let yPosition = yPosition
        let width = width
        let height = height
        //Add hole to blur view
        let scanLayer = CAShapeLayer()
        //Size of hole (need to find wa to autosize with the Grid
        let scanRect = CGRect.init(x: xPosition, y: yPosition, width: width, height: height)
        
        let outerPath = UIBezierPath(rect: scanRect)
        
        let superlayerPath = UIBezierPath.init(rect: self.frame)
        //        outerPath.usesEvenOddFillRule = true
        outerPath.append(superlayerPath)
        scanLayer.path = outerPath.cgPath
        scanLayer.fillRule = kCAFillRuleEvenOdd
        //        scanLayer.fillColor = UIColor.black.cgColor
        
        self.layer.mask = scanLayer
    }
    
    func croppedImage(frame: CGRect?) -> UIImage {
        let scaleFactor = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, scaleFactor)
        self.drawHierarchy(in: bounds, afterScreenUpdates: true)
        var image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        if let frame = frame {
            // UIImages are measured in points, but CGImages are measured in pixels
            let scaledRect = frame.applying(CGAffineTransform(scaleX: scaleFactor, y: scaleFactor))
            
            if let imageRef = image.cgImage!.cropping(to: scaledRect) {
                image = UIImage(cgImage: imageRef)
            }
        }
        return image
    }
    
    
}



