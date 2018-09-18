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
    
   
    func snapshot(of rect: CGRect? = nil) -> UIImage? {
        // snapshot entire view
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, false, UIScreen.main.scale)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let wholeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // if no bounds provided, return image of whole view
        
        guard let image = wholeImage, let rect = rect
            else { return wholeImage }
        
        // otherwise, grab specified bounds of image
        
        let scale = image.scale
        let scaledRect = CGRect(x: rect.origin.x * scale, y: rect.origin.y * scale, width: rect.size.width * scale, height: rect.size.height * scale)
        guard let cgImage = image.cgImage?.cropping(to: scaledRect) else { return nil }
        return UIImage(cgImage: cgImage, scale: scale, orientation: .up)
    }
    
    
}



