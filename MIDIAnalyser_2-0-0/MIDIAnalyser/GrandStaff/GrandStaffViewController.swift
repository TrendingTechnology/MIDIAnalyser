//
//  GrandStaffViewController.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 08/07/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Cocoa

class GrandStaffViewController: NSViewController {
    
    private var grandStaffView: GrandStaffView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        grandStaffView = GrandStaffView(frame: self.view.frame)
        self.view = grandStaffView
        
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()

    }
    
}
