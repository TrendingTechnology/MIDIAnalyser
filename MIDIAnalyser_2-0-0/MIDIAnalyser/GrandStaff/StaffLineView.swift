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
        

        context.setShouldAntialias(false)
        context.setAllowsAntialiasing(false)
        context.setStrokeColor(NSColor(named: "GrandStaffForeground")?.cgColor ?? .white)
        context.setLineWidth(lineWidth)
        
        // calculate line dimensions
        calculateDimensions()
        
        // draw the lines
        for i in 0 ..< numberOfLines {
            
            context.beginPath()
            context.move(to: lineStartPoints[i])
            context.addLine(to: lineEndPoints[i])
            context.strokePath()

        }
    
        
    }
    
    func calculateDimensions() {
        
        let halfPixelOffset: CGFloat = 0.5
        lineSpacing = self.frame.height / CGFloat(numberOfLines - 1) - 2 * lineWidth / CGFloat(numberOfLines - 1)
        
        lineStartPoints.removeAll()
        lineEndPoints.removeAll()
        
        for i in 0 ..< numberOfLines {
            
            let startPoint: CGPoint = CGPoint(x: self.frame.origin.x - 20,
                                              y: CGFloat(i) * lineSpacing
                                                 + lineWidth + halfPixelOffset)

            let endPoint: CGPoint = CGPoint(x: self.frame.origin.x - 20 + self.frame.size.width,
                                            y: startPoint.y)
            
            lineStartPoints.append(startPoint)
            lineEndPoints.append(endPoint)
            
        }
        
    }
    
    
    
    
    
}
