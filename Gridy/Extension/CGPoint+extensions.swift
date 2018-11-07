//
//  CGPoint+extensions.swift
//  Gridy
//
//  Created by Carl Wainwright on 01/11/2018.
//  Copyright © 2018 Carl Wainwright. All rights reserved.
//

import Foundation
import UIKit

extension CGPoint {
    
    func distance(toPoint p:CGPoint) -> CGFloat {
        return sqrt(pow(x - p.x, 2) + pow(y - p.y, 2))
    }
    
    func vector(toPoint p:CGPoint) -> CGPoint {
        return CGPoint(x: x - CGFloat(p.x), y: y - CGFloat(p.y))
    }
}
