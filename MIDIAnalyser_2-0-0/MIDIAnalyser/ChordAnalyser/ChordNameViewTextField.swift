//
//  ChordNameViewTextField.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 07/07/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Cocoa
import Foundation

class ChordNameViewTextField: NSTextField {
    
    // initialisation
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override init(frame: NSRect) {
        
        // superclass initialisation
        super.init(frame: frame)
    }
    
    convenience init(text: String, fontSize: CGFloat, origin: NSPoint) {
        
        // self initialisation (no frame)
        self.init(frame: NSRect())
    
        // set appearance
        self.stringValue = text
        self.isEditable = false
        self.isSelectable = false
        self.isBordered = false
        self.drawsBackground = false
        self.alignment = .center
        self.font = .systemFont(ofSize: fontSize, weight: .thin)
        self.usesSingleLineMode = true
        
        
        // position the frame centrally
        let centeredOrigin: NSPoint = NSPoint(x: origin.x - self.intrinsicContentSize.width / 2,
                                              y: origin.y - self.intrinsicContentSize.height / 2)
        
        self.frame = NSRect(origin: centeredOrigin, size: self.intrinsicContentSize)
        
    }
    
    
    // drawing function
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        self.textColor = NSColor(named: "ChordNameText")

        // Drawing code here.
    }
    
}
