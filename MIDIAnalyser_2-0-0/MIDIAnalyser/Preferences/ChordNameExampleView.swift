//
//  ChordNameExampleView.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 05/07/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Cocoa
import Foundation

class ChordNameExampleView: NSView {
    
    
    // colour pallette
    private var backgroundColor: NSColor = NSColor.controlBackgroundColor
    private var rootTextLabel: NSTextField = NSTextField()
    
    
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

        // fill in the background
        self.wantsLayer = true
        self.layer?.backgroundColor = self.backgroundColor.cgColor
        
        
        
        
    }
    
}
