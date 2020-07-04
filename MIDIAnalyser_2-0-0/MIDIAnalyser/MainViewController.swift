//
//  ViewController.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 03/07/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Cocoa

class MainViewController: NSViewController {
    
    
    var MIDI = MIDIHardwareListener()
    var keyboard = Keyboard()
    var analyser = ChordAnalyser()
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

