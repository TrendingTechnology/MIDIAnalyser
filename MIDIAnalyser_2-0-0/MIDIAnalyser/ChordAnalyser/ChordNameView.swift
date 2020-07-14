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
    private var rootTextLabel: ChordNameViewTextField?
    
    // colour pallette
    private let backgroundColor: NSColor = NSColor.controlShadowColor
    
    
    // initialisation
    required init?(coder: NSCoder) {
        // superclass initialisation
        super.init(coder: coder)
        
        
    }
    
    override init(frame: NSRect) {
        
        // superclass initialisation
        super.init(frame: frame)
        
        // setup observers
        NotificationCenter.default.addObserver(self, selector: #selector(updateView), name: NSNotification.Name(rawValue: ChordMessage.ChordMessageName), object: nil)
        
    }
    
    
    // drawing function
    override func draw(_ dirtyRect: NSRect) {
        
        // superclass draw
        super.draw(dirtyRect)

        // set the background of the view
        self.wantsLayer = true
        self.layer?.backgroundColor = self.backgroundColor.cgColor
    }
    
    
    // update the view
    @objc func updateView(_ notification: NSNotification) {
        
        if let message = notification.object as? ChordMessage {
            
            DispatchQueue.main.async {
                
                // remove old views
                for subview in self.subviews where subview is ChordNameViewTextField {
                    subview.removeFromSuperview()
                }
                
                let chordTextLabelOrigin = NSPoint(x: self.frame.origin.x + self.frame.width / 2,
                                                  y: self.frame.origin.y + self.frame.height / 2)
                
                let chordName: String = message.chord.name()
                
                let fontSize = 30 + self.frame.size.width / 15 - CGFloat(chordName.count)
                
                self.rootTextLabel = ChordNameViewTextField(text: chordName, fontSize: fontSize, origin: chordTextLabelOrigin)
                self.addSubview(self.rootTextLabel!)
            }
            
        }
        
    }
    
}
