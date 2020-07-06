//
//  ChordNameViewController.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 04/07/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Cocoa

class ChordNameViewController: NSViewController {
    
    
    // views
    private var chordNameView: ChordNameView!
    private var chordAnalyser = ChordAnalyser()
    
    
    // initialisation on view load
    override func viewDidLoad() {
        
        // superclass load
        super.viewDidLoad()
        
        // create the view
        chordNameView = ChordNameView(frame: self.view.frame)
        self.view.addSubview(chordNameView)

    }
    
}
