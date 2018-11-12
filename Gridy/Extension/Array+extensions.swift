//
//  [CGPoint]+extensions.swift
//  Gridy
//
//  Created by Carl Wainwright on 09/11/2018.
//  Copyright © 2018 Carl Wainwright. All rights reserved.
//

import Foundation
import UIKit

extension Array {
    //calculates the closes cell in a gris to a nonFixedLocation
    func closestCell(nonFixedLocation: CGPoint, hyp: CGFloat) -> CGPoint {
        var x:CGPoint!
        for i in self as! [CGPoint]{
            if nonFixedLocation.distance(toPoint: i ) < hyp {
                x = i
            }
        }
        return x
    }
}
