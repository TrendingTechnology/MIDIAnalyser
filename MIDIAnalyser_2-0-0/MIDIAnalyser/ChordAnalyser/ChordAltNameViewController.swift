//
//  ChordAltNameViewController.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 15/07/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Cocoa

class ChordAltNameViewController: NSViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do view setup here.
        
        self.view = ChordAltNameView(frame: self.view.frame)
        
    }
    
}
