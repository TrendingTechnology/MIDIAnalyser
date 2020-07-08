//
//  StaffView.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 08/07/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Cocoa

class StaffLineView: NSView {
    
    
    // staff variables
    let numberOfLines: Int = 5
    var lineStartPoints: [CGPoint] = Array()
    var lineEndPoints: [CGPoint] = Array()
    var lineSpacing: CGFloat = 0
    var lineWidth: CGFloat = 1
    
    
    // initialisation
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: NSRect) {
        
        // superclass initialisation
        super.init(frame: frame)
        
        // default values
        lineStartPoints = Array(repeating: .zero, count: numberOfLines)
        lineEndPoints = Array(repeating: .zero, count: numberOfLines)
        
    }
    
    
    // drawing function
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // fetch and setup graphics context
        guard let context = NSGraphicsContext.current?.cgContext else{
            fatalError("Missing NSGraphicsContext in StaffView")
        }
        
        context.setStrokeColor(CGColor.white)
        context.setLineWidth(lineWidth)
        context.setShouldAntialias(true)
        context.setAllowsAntialiasing(true)
        
        // work out dimensions
        let halfPixelOffset: CGFloat = 0.5
        lineSpacing = self.frame.height / CGFloat(numberOfLines - 1) - 2 * lineWidth / CGFloat(numberOfLines - 1)
        lineStartPoints.removeAll()
        lineEndPoints.removeAll()
        
        // draw the lines and clef
        for i in 0 ..< numberOfLines {

            // figure out start and end point for line
            let startPoint: CGPoint = CGPoint(x: self.frame.origin.x,
                                              y: CGFloat(i) * lineSpacing
                                                 + lineWidth + halfPixelOffset)

            let endPoint: CGPoint = CGPoint(x: self.frame.origin.x + self.frame.size.width,
                                            y: startPoint.y)

            // draw the line
            context.beginPath()
            context.move(to: startPoint)
            context.addLine(to: endPoint)
            context.strokePath()
            
            // record the start and end points
            lineStartPoints.append(startPoint)
            lineEndPoints.append(endPoint)

        }
        
    }
    
    
    
    
    
}
