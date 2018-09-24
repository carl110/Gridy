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
    
    func splitImage(_ rows: Int, _ columns: Int) -> [UIImage] {
        let y = scale * (size.height / CGFloat(rows))
        let x = scale * (size.width / CGFloat(columns))
        var images: [UIImage] = []
        images.reserveCapacity(rows * columns)
        guard let cgImage = cgImage else { return [] }
        (0..<rows).forEach { row in
            (0..<columns).forEach { column in
                var width = Int(x)
                var height = Int(y)
                if row == rows-1 && size.height.truncatingRemainder(dividingBy: CGFloat(rows)) != 0 {
                    height = Int(scale * (size.height - size.height / CGFloat(rows) * (CGFloat(rows)-1)))
                }
                if column == columns-1 && size.width.truncatingRemainder(dividingBy: CGFloat(columns)) != 0 {
                    width = Int(scale * (size.width - (size.width / CGFloat(columns) * (CGFloat(columns)-1))))
                }
                if let image = cgImage.cropping(to: CGRect(origin: CGPoint(x: column * Int(x), y:  row * Int(x)), size: CGSize(width: width, height: height))) {
                    images.append(UIImage(cgImage: image, scale: scale, orientation: imageOrientation))
                }
            }
        }
        return images
    }
    
}

    

