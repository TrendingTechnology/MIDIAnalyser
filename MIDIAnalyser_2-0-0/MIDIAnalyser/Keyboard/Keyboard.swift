//
//  Keyboard.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 03/07/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Foundation

class Keyboard {
    
    
    // keyboard constants
    static var nKeys: Int = 88
    static var nWhiteKeys: Int = 52
    static var nBlackKeys: Int = 36
    static var minMIDINumber: Int = 21  // A0
    static var maxMIDINumber: Int = 108 // C8

    
    // class variables
    var keys: [Key] = Array()
    var sustainedKeys: [Key] = Array()
    var sustainPressed: Bool = false
    
    
    // initialisation
    init() {
        
        // generate the key objects
        let octaveKeyTypes: [Key.KeyType] = [.white, .black, .white, .white, .black, .white, .black, .white, .white, .black, .white, .black]
        
        for MIDINumber in Keyboard.minMIDINumber...Keyboard.maxMIDINumber {
            
            let octave: Int = (MIDINumber - Keyboard.minMIDINumber + 9) / 12
            let index: Int = MIDINumber - Keyboard.minMIDINumber
            let keyType: Key.KeyType = octaveKeyTypes[index % 12]
            let key: Key = Key(keyType: keyType , MIDINumber: MIDINumber, octave: octave, index: index)
            
            keys.append(key)
            sustainedKeys.append(key.copy() as! Key)
            
        }
        
        // add observers
        MIDINotificationCenter.observe(type: .noteOn, observer: self, selector: #selector(keyUpdate))
        MIDINotificationCenter.observe(type: .noteOff, observer: self, selector: #selector(keyUpdate))
        MIDINotificationCenter.observe(type: .control, observer: self, selector: #selector(keyUpdate))
  
    }
    
    
    // get the index in for the key array for a particular MIDI number
    static func keyIndexOfMIDINumber(_ MIDINumber: Int) -> Int {
        return MIDINumber - Keyboard.minMIDINumber
    }
    
    // get the MIDI number for a particular index in the key array
    static func MIDINumberOfKeyIndex(_ keyIndex: Int) -> Int {
        return keyIndex + Keyboard.minMIDINumber
    }
    
    
    // event handler
    @objc func keyUpdate(_ notification: Notification) {
                
        switch notification.name.rawValue {
        
        // case for noteOn messages
        case MIDINotificationCenter.MIDINotificationType.noteOn.rawValue:
            
            if let message = notification.object as? MIDINoteMessage {
                
                if message.noteNumber >= Keyboard.minMIDINumber && message.noteNumber <= Keyboard.maxMIDINumber {
                    let keyIndex = Keyboard.keyIndexOfMIDINumber(message.noteNumber)
                    
                    if !sustainPressed {
                        keys[keyIndex].state = true
                    }
                    else {
                        keys[keyIndex].state = true
                        sustainedKeys[keyIndex].state = true
                    }
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: ChordNotesMessage.ChordNotesMessageName), object: ChordNotesMessage(keysPressed()))
                }
                
            }
            
        // case for noteOff messages
        case MIDINotificationCenter.MIDINotificationType.noteOff.rawValue:
            
            if let message = notification.object as? MIDINoteMessage {
                
                if message.noteNumber >= Keyboard.minMIDINumber && message.noteNumber <= Keyboard.maxMIDINumber {
                    let keyIndex = Keyboard.keyIndexOfMIDINumber(message.noteNumber)
                    
                    if !sustainPressed {
                        keys[keyIndex].state = false
                    }
                    else {
                        sustainedKeys[keyIndex].state = false
                    }
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: ChordNotesMessage.ChordNotesMessageName), object: ChordNotesMessage(keysPressed()))
                }
            }
            
        // case for control messages
        case MIDINotificationCenter.MIDINotificationType.control.rawValue:
            
            if let message = notification.object as? MIDIControlMessage {
                
                // sustain pedal
                if message.controlMessageType == MIDIControlMessage.MIDIControlMessageType.sustain {
                    
                    if message.value == 127 {
                        sustainPressed = true
                        for i in 0 ..< keys.count {
                            sustainedKeys[i].state = keys[i].state
                        }
                    }
                    else {
                        sustainPressed = false
                        for i in 0 ..< keys.count {
                            keys[i].state = sustainedKeys[i].state
                        }
                    }
                    
                }
                
            }
        
        // default case, other notifications or objects
        default:
            break
            
        }
        
    }
    
    
    // return all MIDINumbers currently pressed
    func keysPressed() -> [Int] {
        
        var keyStates: [Int] = Array()
        
        for key in keys {
            if key.state {
                keyStates.append(key.MIDINumber)
            }
        }
        
        return keyStates
        
    }
    
    
    // check if a key index belongs to a white key
    static func isWhiteKeyIndex(_ keyIndex: Int) -> Bool {
                                  // A
        let isWhiteKey: [Bool] = [true, false, true, true, false, true, false, true, true, false, true, false]
        var result: Bool = false
        
        if keyIndex >= 0 && keyIndex < Keyboard.nKeys {
            if isWhiteKey[keyIndex % 12] {
                result =  true
            }
        }
        else {
            print("isWhiteKeyIndex: invalid key index: ", keyIndex)
        }
        
        return result
    }
    
    
}
