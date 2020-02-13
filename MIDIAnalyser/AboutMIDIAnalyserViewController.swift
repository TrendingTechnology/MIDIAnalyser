//
//  AboutMIDIAnalyserViewController.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 13/02/2020.
//  Copyright © 2020 AudioKit. All rights reserved.
//

// https://gist.github.com/chsh/ecf534ca79a8cf11e49d

import Cocoa

class AboutMIDIAnalyserViewController: NSViewController, NSApplicationDelegate  {

    
    //var aboutText: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set the size of the window - fixed
        self.preferredContentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height)
        
        // set the text
        /*aboutText = NSTextField(frame: aboutTextFrame.frame)
        aboutText.isEditable = false
        aboutText.stringValue = "About text \n Line 2"
        
        super.view.addSubview(aboutText)*/
        
        
    }



}
