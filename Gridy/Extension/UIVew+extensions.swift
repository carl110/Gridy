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
    //creates a blur effect
    func blurView(style: UIBlurEffect.Style) {
        let blurEffect = UIBlurEffect(style: style)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = self.bounds
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(blurView)
    }
    //puts see through hole onm a blur view
    func holeInBlur(xPosition: CGFloat, yPosition:CGFloat, width: CGFloat, height: CGFloat) {
        let xPosition = xPosition
        let yPosition = yPosition
        let width = width
        let height = height
        //Add hole to blur view
        let scanLayer = CAShapeLayer()
        //Size of hole
        let scanRect = CGRect.init(x: xPosition, y: yPosition, width: width, height: height)
        let outerPath = UIBezierPath(rect: scanRect)
        let superlayerPath = UIBezierPath.init(rect: self.frame)
        //        outerPath.usesEvenOddFillRule = true
        outerPath.append(superlayerPath)
        scanLayer.path = outerPath.cgPath
        scanLayer.fillRule = CAShapeLayerFillRule.evenOdd
        //        scanLayer.fillColor = UIColor.black.cgColor
        self.layer.mask = scanLayer
    }
    //captures picture of part of the screen
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
    
    func fadeIn(_ duration: TimeInterval = 0.5, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveLinear, animations: {
            self.alpha = 1.0
        }, completion: completion)
    }
    
    func fadeOut(_ duration: TimeInterval = 0.5, delay: TimeInterval = 1.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIView.AnimationOptions.curveLinear, animations: {
            self.alpha = 0.0
        }, completion: completion)
    }
    //round corners of a view, individually or all together
    func roundCorners(for corners: UIRectCorner, cornerRadius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.layer.mask = maskLayer
    }
}



