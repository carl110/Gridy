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
    var gridSize: CGFloat = 4 {
        didSet {

            //not pulling through bounds
            drawGrid()

            print ("didSet")

        }
    }
    override func draw(_ rect: CGRect) {
        
        print ("draw rect \(bounds.width) /n grid size \(gridSize)")
        drawGrid()
        UIColor.white.setStroke()
        path.stroke()
    }
    fileprivate var gridWidth: CGFloat {

        return bounds.width/CGFloat(gridSize)
        

    }
    fileprivate func drawGrid() {
        
        if let subLayer = self.layer.sublayers {
            for layer in subLayer {
                layer.removeFromSuperlayer()
            }
        }
        

        let gridLayer = CAShapeLayer()
        print ("draw grid")
        print ("gridSize \(gridSize)")
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
        print ("draw grid gridWidth \(gridWidth)")
        path.close()

        self.layer.addSublayer(gridLayer)
        self.setNeedsDisplay()
    }

}
