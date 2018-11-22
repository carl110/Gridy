//
//  UIVisualEffects+extension.swift
//  Gridy
//
//  Created by Carl Wainwright on 06/09/2018.
//  Copyright © 2018 Carl Wainwright. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    //converts UIView to UIImage
    convenience init(view: UIView) {
        UIGraphicsBeginImageContext(view.frame.size)
        view.layer.render(in: UIGraphicsGetCurrentContext()!)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        self.init(cgImage: (image?.cgImage)!)
    }
    //splits and image into (X) pieces
    func splitImage(_ rowsandcolumns: Int) -> [Int : UIImage] {
        let y = scale * (size.height / CGFloat(rowsandcolumns))
        let x = scale * (size.width / CGFloat(rowsandcolumns))
        var images = [Int : UIImage]()
        images.reserveCapacity(rowsandcolumns * rowsandcolumns)
        guard let cgImage = cgImage else { return [:] }
        (0..<rowsandcolumns).forEach { row in
            (0..<rowsandcolumns).forEach { column in
                var width = Int(x)
                var height = Int(y)
                if row == rowsandcolumns-1 && size.height.truncatingRemainder(dividingBy: CGFloat(rowsandcolumns)) != 0 {
                    height = Int(scale * (size.height - size.height / CGFloat(rowsandcolumns) * (CGFloat(rowsandcolumns)-1)))
                }
                if column == rowsandcolumns-1 && size.width.truncatingRemainder(dividingBy: CGFloat(rowsandcolumns)) != 0 {
                    width = Int(scale * (size.width - (size.width / CGFloat(rowsandcolumns) * (CGFloat(rowsandcolumns)-1))))
                }
                if let image = cgImage.cropping(to: CGRect(origin: CGPoint(x: column * Int(x), y:  row * Int(x)), size: CGSize(width: width, height: height))) {
                    images[images.count] = UIImage(cgImage: image, scale: scale, orientation: imageOrientation)
                }
            }
        }
        return images
    }
    
    
    func isEqualToImage(image: UIImage) -> Bool {
        guard let data1: Data = self.pngData(),
            let data2: Data = image.pngData() else {
                return false
        }
        return data1.elementsEqual(data2)
    }
    
    func elementsEqual(to image: UIImage) -> Bool {
        guard let data1: Data = self.pngData(),
            let data2: Data = image.pngData() else {
                return false
        }
        return data1.elementsEqual(data2)
    }
}


