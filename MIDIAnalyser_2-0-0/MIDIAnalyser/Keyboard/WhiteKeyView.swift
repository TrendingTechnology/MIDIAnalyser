//
//  KeyView.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 04/07/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Foundation
import Cocoa

class WhiteKeyView: NSBox {
    
    // colours and shape
    var pressedColor: NSColor = NSColor.systemBlue
    let defaultColor: NSColor = NSColor.labelColor
    
    // initialisation
    required init?(coder: NSCoder) {
        
        // superclass initialisation
        super.init(coder: coder)
        
    }
    
    // initialisation with frame
    override init(frame: NSRect) {
        
        // superclass initialisation
        super.init(frame: frame)
        
        // setup appearance
        self.boxType = .custom
        self.cornerRadius = 3
        self.borderWidth = 0
        self.fillColor = defaultColor
        self.borderColor = NSColor.secondaryLabelColor
        self.borderType = .noBorder
        self.focusRingType = .none
        self.appearance = NSAppearance(named: .darkAqua)
        
        // subscribe to preferences notification
        PreferencesNotificationCenter.observe(type: .PressedKeyColor, observer: self, selector: #selector(updateKeyPressedColor))
        
        // load preferred pressed colour from userDefaults
        if let colorData = Preferences.load(key: .PressedKeyColor) as? [CGFloat] {
            self.pressedColor = NSColor(calibratedRed: colorData[0], green: colorData[1], blue: colorData[2], alpha: colorData[3])
        }
        
    }
    

    // drawing function
    override func draw(_ dirtyRect: NSRect) {
        
        // superclass drawing
        super.draw(dirtyRect)
        

    }
    
    // update key color
    @objc func updateKeyPressedColor(_ notification: Notification) {

        // load preferred pressed colour from userDefaults
        if let colorData = Preferences.load(key: .PressedKeyColor) as? [CGFloat] {
            self.pressedColor = NSColor(calibratedRed: colorData[0], green: colorData[1], blue: colorData[2], alpha: colorData[3])
        }
        
    }
    
    
}
