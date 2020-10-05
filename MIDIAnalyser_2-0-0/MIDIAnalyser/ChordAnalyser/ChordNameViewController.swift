//
//  ChordNameViewController.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 04/07/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Cocoa

class ChordNameViewController: NSViewController {
    
    
    // chord analyser hosted here, could make it static instead
    private var chordAnalyser = ChordAnalyser()
    
    
    // initialisation on view load
    override func viewDidLoad() {
        
        // superclass load
        super.viewDidLoad()
        
        // create the view
        self.view = ChordNameView(frame: self.view.frame)
        

    }
    
}
