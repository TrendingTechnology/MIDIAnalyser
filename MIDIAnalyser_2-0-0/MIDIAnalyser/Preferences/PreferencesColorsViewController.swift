//
//  PreferencesColorsViewController.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 05/07/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Cocoa

class PreferencesColorsViewController: NSViewController {
    
    // interface builder
    @IBOutlet var pressedKeyColorWell: NSColorWell!
    
    // view loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set view size
        self.preferredContentSize = NSMakeSize(self.view.frame.size.width, self.view.frame.size.height)
        
        // set up the colour well
        pressedKeyColorWell.action = #selector(pressedKeyColorChanged)
        pressedKeyColorWell.target = self
        
        if let colorData = Preferences.load(key: .PressedKeyColor) as? [CGFloat] {
            pressedKeyColorWell.color = NSColor(calibratedRed: colorData[0], green: colorData[1], blue: colorData[2], alpha: colorData[3])
        }


        
    }
    
    // view appeared
    override func viewDidAppear() {
        super.viewDidAppear()
        

    }
    
    // colour well changed
    @objc func pressedKeyColorChanged() {
        
        // save data to user defaults
        let color: NSColor = pressedKeyColorWell.color
        
        let colorData: [CGFloat] = [color.redComponent, color.greenComponent, color.blueComponent, color.alphaComponent]
        Preferences.save(key: .PressedKeyColor, data: colorData)
        
    }
    
}




