//
//  BlackKeyView.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 04/07/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Cocoa

class BlackKeyView: NSBox {
    
    
    // colours and shape
    var pressedColor: NSColor = NSColor.systemBlue
    let defaultColor: NSColor = NSColor.black
    

    // key state
    var state: Bool = false
    
    // initialisation
    required init?(coder: NSCoder) {
        
        // superclass initialisation
        super.init(coder: coder)
        
    }
    
    override init(frame: NSRect) {
        
        // superclass initialisation
        super.init(frame: frame)
        
        // setup appearance
        self.boxType = .custom
        self.cornerRadius = 1
        self.borderWidth = 0.5
        self.fillColor = defaultColor
        self.borderColor = NSColor.black
        self.borderType = .grooveBorder // groove
        self.focusRingType = .none
        self.appearance = NSAppearance(named: .darkAqua)
        
    }
    
    

    // drawing function
    override func draw(_ dirtyRect: NSRect) {

        // superclass drawing
        super.draw(dirtyRect)

    }
    
}
