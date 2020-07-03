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
    
    
    private static let subviewBorder: CGFloat = CGFloat(20)
    private static let buttonHeight: CGFloat = CGFloat(25)
    
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
        let sourcePopUpButtonFrame = NSRect(x: MainWindow.subviewBorder, y: MainWindow.subviewBorder, width: 200, height: MainWindow.buttonHeight)
        sourcePopUpButton = NSPopUpButton(frame: sourcePopUpButtonFrame, pullsDown: false)
        sourcePopUpButton.addItem(withTitle: "All inputs")
        sourcePopUpButton.addItems(withTitles: MIDI.availableInputs)
        sourcePopUpButton.autoenablesItems = true
        sourcePopUpButton.setButtonType(.momentaryLight)
        sourcePopUpButton.state = .on
        sourcePopUpButton.target = self
        sourcePopUpButton.action = #selector(sourceChanged)
        
        // add subviews to window
        self.contentView?.addSubview(sourcePopUpButton)
    
        
    }
    
    
    // handle sourcePopUpButton changes
    @objc func sourceChanged(_ sender: NSPopUpButton) {
        MIDI.inputChange(sender.indexOfSelectedItem)
    }
    
    
}
