//
//  KeyboardView.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 04/07/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Cocoa

class KeyboardView: NSView {
    
    
    // colour pallette
    private let backgroundColor: NSColor = NSColor.black
    
    // key views
    var whiteKeys: [WhiteKeyView] = Array()
    var blackKeys: [BlackKeyView] = Array()
    
    // key dimensions
    private var whiteKeyWidth: CGFloat = CGFloat()
    private var whiteKeyHeight: CGFloat = CGFloat()
    private var blackKeyWidth: CGFloat = CGFloat()
    private var blackKeyHeight: CGFloat = CGFloat()
    
    
    // initialisation
    required init?(coder: NSCoder) {
        
        // superclass initialisation
        super.init(coder: coder)
        
    }
    
    override init(frame: NSRect) {
        
        // superclass initialisation
        super.init(frame: frame)
        
        // calculate key dimensions
        whiteKeyWidth = CGFloat(self.frame.size.width) / CGFloat(Keyboard.nWhiteKeys)
        whiteKeyHeight = CGFloat(self.frame.size.height)
        blackKeyWidth = 0.7 * whiteKeyWidth
        blackKeyHeight = 0.64 * whiteKeyHeight

        // create keys
        for i in 0 ... Keyboard.nWhiteKeys {

            let whiteKeyFrame = NSRect(x: CGFloat(self.frame.origin.x) + CGFloat(i) * whiteKeyWidth,
                                       y: CGFloat(self.frame.origin.y),
                                       width: CGFloat(whiteKeyWidth - 0.5), // -2
                                       height: whiteKeyHeight)

            let whiteKey = WhiteKeyView(frame: whiteKeyFrame)
            whiteKeys.append(whiteKey)
        }

        let blackKeyOffsets = [0,  1,  1,  2,  2,  2,
                                   3,  3,  4,  4,  4,
                                   5,  5,  6,  6,  6,
                                   7,  7,  8,  8,  8,
                                   9,  9, 10, 10, 10,
                                  11, 11, 12, 12, 12,
                                  13, 13, 14, 14, 14,
                                  15, 15, 16, 16, 16]

        for i in 0 ..< Keyboard.nBlackKeys {

            var x = CGFloat(self.frame.origin.x)
            x += (whiteKeyWidth - CGFloat(blackKeyWidth / 2))
            x += CGFloat(i + blackKeyOffsets[i]) * whiteKeyWidth

            let blackKeyFrame = NSRect(x: x,
                                       y: CGFloat(self.frame.origin.y) + CGFloat(self.frame.size.height) - blackKeyHeight,
                                       width: CGFloat(blackKeyWidth * 0.9),
                                       height: blackKeyHeight)

            let blackKey = BlackKeyView(frame: blackKeyFrame)
            blackKeys.append(blackKey)

        }

        // add keys to view
        for key in whiteKeys {self.addSubview(key)}
        for key in blackKeys {self.addSubview(key)}
        
    }

    
}
