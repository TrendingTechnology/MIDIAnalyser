//
//  MIDITypingListener.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 06/07/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Cocoa

class MIDITypingListener: NSViewController {
    
    
    // mapping for keyboard letters to MIDI number
    static private let characterMIDINumberDictionary: [String : Int] = [
        "a" : 60,
        "w" : 61,
        "s" : 62,
        "e" : 63,
        "d" : 64,
        "f" : 65,
        "t" : 66,
        "g" : 67,
        "y" : 68,
        "h" : 69,
        "u" : 70,
        "j" : 71,
        "k" : 72,
        "o" : 73,
        "l" : 74,
        "p" : 75
    ]
    
    
    // default velocity to send for keyDown events
    static private let defaultVelocity: Int = 127
    
    // is the listener enabled by user preferences
    var enabled: Bool = true
    
    
    // start monitoring key events
    func startListening() {

        // monitor keyDown events
        NSEvent.addLocalMonitorForEvents(matching: .keyDown) {
            
            self.keyDown(with: $0)
            
            // to stop macOS error sound, return nil if the key is handled (in the list of allowed keys)
            // otherwise allow the event to be passed up the responder chain
            if MIDITypingListener.characterMIDINumberDictionary[$0.characters ?? ""] != nil {
                return nil
            }
            
            return $0
        }

        // monitor keyUp events
        NSEvent.addLocalMonitorForEvents(matching: .keyUp) {
            self.keyUp(with: $0)
            return $0
        }
        
        // load default preference for whether to enable listening or not
        if let preferEnabled = Preferences.load(key: .MIDITypingEnabled) as? Bool {
            enabled = preferEnabled
        }
        
        // add observer for change to preferences
        PreferencesNotificationCenter.observe(type: .MIDITypingEnabled, observer: self, selector: #selector(enabledChanged))
        
    }
    
    
    // key handlers
    override func keyDown(with event: NSEvent) {
        
        // only respond to events if enabled
        if enabled {
            
            // only handle non-repeated events
            if !event.isARepeat {
                
                let key: String = event.characters ?? ""
                
                // post a message if the key is in the dictionary
                if let noteNumber = MIDITypingListener.characterMIDINumberDictionary[key] {
                    let message: MIDINoteMessage = MIDINoteMessage(messageType: .noteOn, noteNumber: noteNumber, velocity: MIDITypingListener.defaultVelocity)
                    MIDINotificationCenter.post(type: message.messageType, object: message)
                }

            }

        }
        
    }
    
    override func keyUp(with event: NSEvent) {
        
        // only respond to inputs if enabled
        if enabled {
            
            // only handle non-repeated events
            if !event.isARepeat {
                
                let key: String = event.characters ?? ""
                
                // post a message if the key is in the dictionary
                if let noteNumber = MIDITypingListener.characterMIDINumberDictionary[key] {
                    let message: MIDINoteMessage = MIDINoteMessage(messageType: .noteOff, noteNumber: noteNumber, velocity: MIDITypingListener.defaultVelocity)
                    MIDINotificationCenter.post(type: message.messageType, object: message)
                }
            }
            
        }
    }
    
    // receiver for change to enable
    @objc func enabledChanged(_ notification: Notification) {
        
        // load preference for whether to enable or not
        if let preferEnabled = Preferences.load(key: .MIDITypingEnabled) as? Bool {
            enabled = preferEnabled
        }
        
        print("enabledChanged()")
    }
    
    
}
