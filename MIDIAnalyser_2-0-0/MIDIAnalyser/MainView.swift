//
//  MainView.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 18/12/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Cocoa

class MainView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        
        
        super.draw(dirtyRect)

        // set the background of the view
        self.wantsLayer = true
        self.layer?.backgroundColor = NSColor(named: "WindowBackground")?.cgColor ?? .white
    }
    
}
