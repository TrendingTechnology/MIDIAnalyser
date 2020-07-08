//
//  GrandStaffView.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 08/07/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Cocoa
import Foundation


class GrandStaffView: NSView {
    
    // subviews
    private var bassStaff: StaffLineView = StaffLineView(frame: NSRect())
    private var trebleStaff: StaffLineView = StaffLineView(frame: NSRect())
    var bassClefTextField: NSTextField = NSTextField()
    var trebleClefTextField: NSTextField = NSTextField()


    // initialisation
    required init?(coder: NSCoder) {
        
        // superclass initialisation
        super.init(coder: coder)
        
    }
    
    override init(frame: NSRect) {
        
        // superclass initialisation
        super.init(frame: frame)
//        self.wantsLayer = true
//        self.layer?.backgroundColor = .black
        
        // clef characters
        self.bassClefTextField.stringValue = "\u{1D122}"
        self.trebleClefTextField.stringValue = "\u{1D11E}"
        
        // text fields for clefs
        self.bassClefTextField.isEditable = false
        self.bassClefTextField.isSelectable = false
        self.bassClefTextField.isBordered = false
        self.bassClefTextField.drawsBackground = false
        self.bassClefTextField.textColor = .white
        self.bassClefTextField.canDrawSubviewsIntoLayer = true
        self.bassClefTextField.frame = NSRect()
        
        self.trebleClefTextField.isEditable = false
        self.trebleClefTextField.isSelectable = false
        self.trebleClefTextField.isBordered = false
        self.trebleClefTextField.drawsBackground = false
        self.trebleClefTextField.textColor = .white
        self.trebleClefTextField.canDrawSubviewsIntoLayer = true
        self.trebleClefTextField.frame = NSRect()
        
        // add subviews
        self.addSubview(bassStaff)
        self.addSubview(trebleStaff)
        self.addSubview(bassClefTextField)
        self.addSubview(trebleClefTextField)
        
    }
    

    override func draw(_ dirtyRect: NSRect) {
        
        // superclass drawing
        super.draw(dirtyRect)
        
        // call the drawing functions
        drawStaffLines()
        drawVerticalLines()
        drawClefs()        
        
    }
    
    private func drawStaffLines() {

        let staffSize: NSSize = NSSize(width: self.frame.width, height: 46) // (h - 2) /4 must be whole number
        
        let staffSpacing: CGFloat = 50
        let bassStaffOrigin: NSPoint = NSPoint(x: self.frame.origin.x, y: 50)
        let trebleStaffOrigin: NSPoint = NSPoint(x: bassStaffOrigin.x,
                                                 y: bassStaffOrigin.y + staffSize.height + staffSpacing)
        
        bassStaff.frame = NSRect(origin: bassStaffOrigin, size: staffSize)
        trebleStaff.frame = NSRect(origin: trebleStaffOrigin, size: staffSize)
    }
    
    
    private func drawClefs() {
        
        let lineSpacing: CGFloat = bassStaff.frame.height / CGFloat(bassStaff.numberOfLines - 1) - 2 * bassStaff.lineWidth / CGFloat(bassStaff.numberOfLines - 1)
            
        bassClefTextField.font = NSFont.systemFont(ofSize: lineSpacing * 4.6, weight: .thin)
        bassClefTextField.frame.origin.x = self.frame.origin.x + lineSpacing / 2
        bassClefTextField.frame.origin.y = bassStaff.frame.origin.y + lineSpacing + lineSpacing * 0.15
        bassClefTextField.frame.size.height = lineSpacing * 4.4
        bassClefTextField.frame.size.width = lineSpacing * 4
        
        trebleClefTextField.font = NSFont.systemFont(ofSize: lineSpacing * 9, weight: .thin)
        trebleClefTextField.frame.origin.x = self.frame.origin.x + lineSpacing / 2
        trebleClefTextField.frame.origin.y = trebleStaff.frame.origin.y - 2 * lineSpacing + lineSpacing * 0.05
        trebleClefTextField.frame.size.height = lineSpacing * 10
        trebleClefTextField.frame.size.width = lineSpacing * 4
        // trebleClefTextField.drawsBackground = true

    }
    
    
    private func drawVerticalLines() {
        
        // fetch and setup graphics context
        guard let context = NSGraphicsContext.current?.cgContext else{
            fatalError("Missing NSGraphicsContext in StaffView")
        }
        
        context.setStrokeColor(CGColor.white)
        
        let halfPixelOffset: CGFloat = 0.5
        
        // draw the left side line
        do {
            
            let startPoint: CGPoint = CGPoint(x: bassStaff.frame.origin.x,
                                              y: bassStaff.frame.origin.y + halfPixelOffset * 2)
            let endPoint: CGPoint = CGPoint(x: startPoint.x,
                                            y: trebleStaff.frame.origin.y + trebleStaff.frame.size.height)
            
            context.setLineWidth(4)
            context.beginPath()
            context.move(to: startPoint)
            context.addLine(to: endPoint)
            context.strokePath()

            
        }
        
        // draw the right side lines
        do {
            
            let startPoint: CGPoint = CGPoint(x: bassStaff.frame.origin.x + bassStaff.frame.size.width,
                                              y: bassStaff.frame.origin.y + halfPixelOffset * 2)
            let endPoint: CGPoint = CGPoint(x: startPoint.x,
                                            y: trebleStaff.frame.origin.y + trebleStaff.frame.size.height)
            
            context.setLineWidth(6)
            context.beginPath()
            context.move(to: startPoint)
            context.addLine(to: endPoint)
            context.strokePath()
            
        }
        
        do {

            let offset: CGFloat = 8
            
            let startPoint: CGPoint = CGPoint(x: bassStaff.frame.origin.x + bassStaff.frame.size.width - offset,
                                              y: bassStaff.frame.origin.y + halfPixelOffset * 2)
            let endPoint: CGPoint = CGPoint(x: startPoint.x,
                                            y: trebleStaff.frame.origin.y + trebleStaff.frame.size.height)
            
            context.setLineWidth(2)
            context.beginPath()
            context.move(to: startPoint)
            context.addLine(to: endPoint)
            context.strokePath()
            
        }
        
    }


}


