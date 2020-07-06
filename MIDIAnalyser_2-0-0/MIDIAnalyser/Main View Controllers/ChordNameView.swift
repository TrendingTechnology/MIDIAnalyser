//
//  ChordNameView.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 04/07/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Cocoa


class ChordNameView: NSView {
    
    
    // text labels

    
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
    
    
    // drawing function
    override func draw(_ dirtyRect: NSRect) {
        
        // superclass draw
        super.draw(dirtyRect)

        // set the background of the view
        self.wantsLayer = true
        self.layer?.backgroundColor = self.backgroundColor.cgColor
    }
    
}
