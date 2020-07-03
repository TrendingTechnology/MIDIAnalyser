//
//  MainWindow.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 03/07/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Foundation
import Cocoa


class MainWindow : NSWindow {
    
    
    var MIDI = MIDIListener()
    var sourcePopUpButton = NSPopUpButton()

    
    init(screenSize: NSSize) {
        
        // calculate window dimensions and position
        let windowSize = NSSize(width: 800, height: 400)
        
        let contentRect = NSMakeRect(screenSize.width/2 - windowSize.width/2,
                                     screenSize.height/2 - windowSize.height/2,
                                     windowSize.width,
                                     windowSize.height)
        
        // initialise NSWindow superclass
        super.init(contentRect: contentRect,
                   styleMask: [.miniaturizable, .closable, .resizable, .titled],
                   backing: .buffered,
                   defer: false)
        
        // window appearance
        self.title = "MIDIAnalyser"
        self.minSize = windowSize
        self.setContentSize(self.minSize)
        
        // window behaviour
        self.makeKeyAndOrderFront(nil)
        
        // MIDI input selection button
        sourcePopUpButton = NSPopUpButton(frame: NSRect(x: 200, y: 200, width: 200, height: 25), pullsDown: true)
        sourcePopUpButton.addItem(withTitle: "(select input)")
        sourcePopUpButton.addItems(withTitles: MIDI.availableInputs)
        self.contentView?.addSubview(sourcePopUpButton)
        

        
    }
    
}
