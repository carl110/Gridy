//
//  GridyImageViewController.swift
//  Gridy
//
//  Created by Carl Wainwright on 28/08/2018.
//  Copyright © 2018 Carl Wainwright. All rights reserved.
//

import UIKit

class PartialTransparentView: UIView {
    var rectsArray: [CGRect]?
    
    convenience init(rectsArray: [CGRect]) {
        self.init()
        
        self.rectsArray = rectsArray
        
        backgroundColor = UIColor.black.withAlphaComponent(0.6)
        isOpaque = false
    }
    
    override func draw(_ rect: CGRect) {
        backgroundColor?.setFill()
        UIRectFill(rect)
        
        guard let rectsArray = rectsArray else {
            return
        }
        
        for holeRect in rectsArray {
            let holeRectIntersection = rect.intersection(holeRect)
            UIColor.clear.setFill()
            UIRectFill(holeRectIntersection)
        }
    }
}
