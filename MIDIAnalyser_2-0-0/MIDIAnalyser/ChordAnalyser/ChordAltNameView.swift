//
//  ChordAltNameView.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 15/07/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Cocoa

class ChordAltNameView: NSView {
    
    
    private var chordTextLabels: [ChordNameViewTextField] = Array()

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
        self.layer?.backgroundColor = NSColor(named: "ChordAltNameBackground")?.cgColor ?? .white
    }
    
    
    // update the view
    @objc func updateView(_ notification: NSNotification) {
        
        if let message = notification.object as? ChordMessage {
            
            DispatchQueue.main.async {
                
                // remove old views
                for subview in self.subviews where subview is ChordNameViewTextField {
                    subview.removeFromSuperview()
                }

                let fontSize: CGFloat = 40 - CGFloat(message.chords.count) * 3
                
                // draw an array of chord text fields
                self.chordTextLabels = Array()
                message.chords.remove(at: 0)        // remove first one as already displayed
                
                let labelHeight: CGFloat = self.frame.height / CGFloat(message.chords.count)
                var i: Int = 0
                
                for chord in message.chords {
                    
                    let chordTextLabelOrigin = NSPoint(x: self.frame.origin.x + self.frame.width / 2,
                                                       y: self.frame.origin.y + self.frame.height - labelHeight / 2 - CGFloat(labelHeight * CGFloat(i)))
                    
                    let newLabel: ChordNameViewTextField = ChordNameViewTextField(text: chord.name(), fontSize: fontSize, origin: chordTextLabelOrigin)
                    //newLabel.isBordered = true
                    
                    self.chordTextLabels.append(newLabel)
                    self.addSubview(self.chordTextLabels[i])
                    
                    i = i + 1
                }
                
                
                
            }
            
        }
        
    }
    
}
