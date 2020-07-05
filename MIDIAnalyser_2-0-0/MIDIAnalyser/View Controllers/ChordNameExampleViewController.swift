//
//  ChordNameExampleViewController.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 05/07/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Cocoa

class ChordNameExampleViewController: NSViewController {
    
    // views
    private var chordNameExampleView: ChordNameExampleView!

    
    // initialisation on view load
    override func viewDidLoad() {
        
        // superclass load
        super.viewDidLoad()
        
        // create the view
        chordNameExampleView = ChordNameExampleView(frame: self.view.frame)
        self.view.addSubview(chordNameExampleView)

        
    }
    
}
