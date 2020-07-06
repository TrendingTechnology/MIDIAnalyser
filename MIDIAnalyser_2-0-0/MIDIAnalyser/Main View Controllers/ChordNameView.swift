//
//  ChordNameView.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 04/07/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Cocoa

class ChordNameView: NSView {
    
    
    // colour pallette
    private var backgroundColor: NSColor = NSColor.controlShadowColor
    
    
    // initialisation
    required init?(coder: NSCoder) {
        
        // superclass initialisation
        super.init(coder: coder)
        
    }
    
    override init(frame: NSRect) {
        
        // superclass initialisation
        super.init(frame: frame)
        
    }
    

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        // appearance
        self.wantsLayer = true
        self.layer?.backgroundColor = self.backgroundColor.cgColor
    }
    
}
