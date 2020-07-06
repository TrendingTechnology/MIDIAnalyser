//
//  PreferencesViewController.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 05/07/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Cocoa

class PreferencesMIDIViewController: NSViewController {
        
    // interface builder
    @IBOutlet var inputDevicePopUpButton: NSPopUpButton!
    @IBOutlet var MIDITypingButton: NSButton!
    
    // view loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // set view size
        self.preferredContentSize = NSMakeSize(self.view.frame.size.width, self.view.frame.size.height)

        // update input devices button
        inputDevicePopUpButton.removeAllItems()
        inputDevicePopUpButton.addItems(withTitles: MIDIHardwareListener.listInputs())
        inputDevicePopUpButton.action = #selector(inputDeviceChanged)
        
        // update MIDI typing button
        MIDITypingButton.action = #selector(MIDITypingButtonStateChanged)
        
        // load the preferred input device if it is available
        if let preferredInputDevice = Preferences.load(key: .InputDevice) as? String {
            if let item = inputDevicePopUpButton.item(withTitle: preferredInputDevice) {
                inputDevicePopUpButton.select(item)
                MIDIHardwareListener.inputChange(preferredInputDevice)
            }
        }
        
        // load MIDI typing preferred staate if available
        if let enableMIDITyping = Preferences.load(key: .MIDITypingEnabled) as? Bool {
            MIDITypingButton.state = enableMIDITyping ? .on : .off
        }
        else {
            MIDITypingButton.state = .on // enabled by default
        }
        
    }
    
    // view appeared
    override func viewDidAppear() {
        super.viewDidAppear()
        
    }
    
    // input device change handler
    @objc func inputDeviceChanged() {
        Preferences.save(key: .InputDevice, data: inputDevicePopUpButton.selectedItem!.title)
    }
    
    // MIDI typing state change handler
    @objc func MIDITypingButtonStateChanged() {
        Preferences.save(key: .MIDITypingEnabled, data: MIDITypingButton.state == .on ? true : false)
    }
    
}
