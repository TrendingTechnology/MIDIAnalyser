//
//  ViewController.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 03/07/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Cocoa


class MainViewController: NSViewController {
    
    
    // analysis and MIDI
    private var MIDI = MIDIHardwareListener()
    
    // child view controllers
    private var keyboardViewController: KeyboardViewController?
    private var chordNameViewController: ChordNameViewController?
    
    // colour palette
    private var backgroundColor: NSColor = .controlColor
    

    // view loaded setup
    override func viewDidLoad() {
        
        // superclass load
        super.viewDidLoad()
        
    }

}

