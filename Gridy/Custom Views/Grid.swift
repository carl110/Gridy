//
//  Grid.swift
//  Gridy
//
//  Created by Carl Wainwright on 03/09/2018.
//  Copyright © 2018 Carl Wainwright. All rights reserved.
//

import UIKit

class Grid: UIView {
    
    private var path = UIBezierPath()
    fileprivate var gridSize: CGFloat {
        return 4
    }
    fileprivate var gridWidth: CGFloat {
        return bounds.width/CGFloat(gridSize)
    }
    fileprivate func drawGrid() {
        path = UIBezierPath()
        path.lineWidth = 2
        for index in 0...Int(gridSize) {
            let start = CGPoint(x: 0, y: CGFloat(index) * gridWidth)
            let end = CGPoint(x: bounds.width, y: CGFloat(index) * gridWidth)
            path.move(to: start)
            path.addLine(to: end)
        }
        for index in 0...Int(gridSize) {
            let start = CGPoint(x: CGFloat(index) * gridWidth, y: 0 )
            let end = CGPoint(x: CGFloat(index) * gridWidth, y:bounds.height)
            path.move(to: start)
            path.addLine(to: end)
        }
        path.close()
    }
    override func draw(_ rect: CGRect) {
        drawGrid()
        UIColor.white.setStroke()
        path.stroke()
    }
}
