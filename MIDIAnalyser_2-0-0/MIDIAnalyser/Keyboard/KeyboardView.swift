//
//  KeyboardView.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 04/07/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Cocoa

class KeyboardView: NSView {
    
    
    // key views
    var whiteKeys: [WhiteKeyView] = Array()
    var blackKeys: [BlackKeyView] = Array()
    
    // container view
    private let keyContainerAspectRatio: CGFloat = 728 / 100 // width : height
    private let keyContainerView = NSView()
    
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
        
        // key container
        self.addSubview(keyContainerView)
        
        // create keys
        // array(repeating:) does not work here
        for _ in 0 ..< Keyboard.nWhiteKeys {
            whiteKeys.append(WhiteKeyView(frame: NSRect()))
        }
        
        for _ in 0 ..< Keyboard.nBlackKeys {
            blackKeys.append(BlackKeyView(frame: NSRect()))
        }
        
        // initialise keys to the correct size
        updateKeyDimensions()
        
        // add keys to their container view
        for key in whiteKeys {keyContainerView.addSubview(key)}
        for key in blackKeys {keyContainerView.addSubview(key)}
        
    }
    
    // drawing function
    override func draw(_ dirtyRect: NSRect) {
        
        // superclass drawing
        super.draw(dirtyRect)
        
        // background color
        self.wantsLayer = true
        //self.layer?.backgroundColor = NSColor.red.cgColor
        
    }
    

    // calculate size of key container
    func updateKeyContainer() {
    
        // aspect ratio of parent view to the container
        let keyboardViewAspectRatio: CGFloat = self.frame.width / self.frame.height
        var keyContainerViewSize: NSSize = NSSize()
        
        // determine the maximum size the container can be
        if keyboardViewAspectRatio > keyContainerAspectRatio {
            keyContainerViewSize =  NSSize(width: self.frame.height * keyContainerAspectRatio,
                                           height: self.frame.height)
        }
        else {
            keyContainerViewSize = NSSize(width: self.frame.width,
                                          height: self.frame.width / keyContainerAspectRatio)
        }
        
        // container for keys
        let keyContainerView = self.subviews[0]
        
        keyContainerView.wantsLayer = true
        //keyContainerView.layer?.backgroundColor = NSColor.blue.cgColor
            
        keyContainerView.frame = NSRect(x: self.frame.origin.x + (self.frame.width - keyContainerViewSize.width) / 2,
                                        y: self.frame.origin.y + (self.frame.height - keyContainerViewSize.height) / 2,
                                        width: keyContainerViewSize.width,
                                        height: keyContainerViewSize.height)

    }
    
    // calculate and update key dimensions
    func updateKeyDimensions() {
        
        // calculate key dimensions
        whiteKeyWidth = CGFloat(keyContainerView.frame.width) / CGFloat(Keyboard.nWhiteKeys)
        whiteKeyHeight = CGFloat(keyContainerView.frame.height)
        blackKeyWidth = 0.7 * whiteKeyWidth
        blackKeyHeight = 0.64 * whiteKeyHeight

        // create white keys
        for i in 0 ..< Keyboard.nWhiteKeys {
            
            // determine dimensions
            let whiteKeyFrame = NSRect(x: CGFloat(i) * whiteKeyWidth,
                                       y: 0,
                                       width: CGFloat(whiteKeyWidth - 1), // -2
                                       height: whiteKeyHeight)
            
            whiteKeys[i].frame = whiteKeyFrame
        }

        // offsets for black key positions
        let blackKeyOffsets = [0,  1,  1,  2,  2,  2,
                                   3,  3,  4,  4,  4,
                                   5,  5,  6,  6,  6,
                                   7,  7,  8,  8,  8,
                                   9,  9, 10, 10, 10,
                                  11, 11, 12, 12, 12,
                                  13, 13, 14, 14, 14,
                                  15, 15, 16, 16, 16]
        

        // create the black keys
        
        for i in 0 ..< Keyboard.nBlackKeys {

            // calculate position
            var x = (whiteKeyWidth - CGFloat(blackKeyWidth / 2))
            x += CGFloat(i + blackKeyOffsets[i]) * whiteKeyWidth

            // determine dimensions
            let blackKeyFrame = NSRect(x: x,
                                       y: CGFloat(keyContainerView.frame.size.height) - blackKeyHeight,
                                       width: CGFloat(blackKeyWidth * 0.9),
                                       height: blackKeyHeight)

            blackKeys[i].frame = blackKeyFrame

        }
        
    }
}
