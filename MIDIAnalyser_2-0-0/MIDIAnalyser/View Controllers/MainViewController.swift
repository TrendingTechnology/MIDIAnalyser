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
    var MIDI = MIDIHardwareListener()
    //var keyboard = Keyboard()
    var analyser = ChordAnalyser()
    
    // child view controllers
    private var keyboardViewController: KeyboardViewController?
    

    // view loaded setup
    override func viewDidLoad() {
        
        super.viewDidLoad()

        guard let keyboardViewControllerFetched = children.first as? KeyboardViewController else {
            fatalError("missing keyboardViewController")
        }
        
        keyboardViewController = keyboardViewControllerFetched
        
    }

    // default
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

