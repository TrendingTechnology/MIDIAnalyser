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
    @IBOutlet weak var appearancePopUpButton: NSPopUpButton!
    
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
        
        // set up the pop up button
        appearancePopUpButton.action = #selector(appearanceChanged)
        appearancePopUpButton.target = self
        
        // load the appearance
        if let appearanceName = Preferences.load(key: .AppearanceName) as? String {
            appearancePopUpButton.selectItem(withTitle: appearanceName)
        }
        else {
            appearancePopUpButton.selectItem(withTitle: "Always dark")
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
    
    // colour theme changed
    @objc func appearanceChanged() {
    
        
        var appearance: NSAppearance = NSAppearance(named: .darkAqua)!
        
        // decide appearance based on title of button
        switch appearancePopUpButton.titleOfSelectedItem {
        
        case "Always light":
            appearance = NSAppearance(named: .aqua)!
            break
        case "Always dark":
            appearance = NSAppearance(named: .darkAqua)!
            break
        case "System setting":
            if UserDefaults.standard.object(forKey: "AppleInterfaceStyle") == nil {
                appearance = NSAppearance(named: .aqua)!
            }
            break
        default:
            break
            
        }
        
        // update the appearance
        NSApp.appearance = appearance
        
        // encode and save to user preferences
        /// TODO: archiving method depreciated, update
        let encodedAppearance = NSKeyedArchiver.archivedData(withRootObject: appearance)
        Preferences.save(key: .Appearance, data: encodedAppearance)
        
        // also save the name of the appearance selected
        Preferences.save(key: .AppearanceName, data: appearancePopUpButton.titleOfSelectedItem ?? "")
        
    }
    
}




