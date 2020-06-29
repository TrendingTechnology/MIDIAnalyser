//
//  Keyboard.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 05/04/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Foundation


public class Keyboard {
    
    
    // enumerated types
    enum KeyType {case whiteKey, blackKey}
    enum Accidentals {case sharps, flats, mixed}
    
    // keyboard constants
    static var nKeys: Int = 88
    static var nWhiteKeys: Int = 52
    static var nBlackKeys: Int = 36
    
    static var minMIDINumber = 21      // A0
    static var maxMIDINumber = 108     // C8
    
    // class variables
    var keyStates: [Bool] = Array()     // state of all keys on keyboard
    
    
    // initialisation
    init() {
        keyStates = Array(repeating: false, count: Keyboard.nKeys)
    }
    
    
    // update the state of a single key
    func setKeyState(MIDINumber: Int, state: Bool) {
        
        let keyIndex = keyIndexOfMIDINumber(MIDINumber)
        
        if isValidKeyIndex(keyIndex) {
            
            keyStates[keyIndex] = state
            
        }
        
    }
    
    
    // get the state of a single key
    func getKeyState(MIDINumber: Int) -> Bool {
        return keyStates[keyIndexOfMIDINumber(MIDINumber)]
    }
    
    
    // check if a key index is valid
    func isValidKeyIndex(_ keyIndex: Int) -> Bool {
        
        var result: Bool = false
        
        if keyIndex >= 0 && keyIndex <= Keyboard.nKeys {
            result = true
        }
        else {
            print("invalid key index")
        }
        
        return result
    }
    
    
    // convert a MIDI number to a key index
    func keyIndexOfMIDINumber(_ MIDINumber: Int) -> Int {
        return MIDINumber - Keyboard.minMIDINumber
    }
    
    
    // get the note name of a particular key
    static func noteNameOfKey(keyIndex: Int, type: Accidentals) -> String {
        
        // lists of possible note names
        let noteNamesSharps = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
        let noteNamesFlats  = ["C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B"]
        let noteNamesMixed  = ["C", "Db", "D", "Eb", "E", "F", "F#", "G", "Ab", "A", "Bb", "B"]
        
        switch(type) {
            
        case Accidentals.sharps:
            return noteNamesSharps[keyIndex % 12]

        case Accidentals.flats:
            return noteNamesFlats[keyIndex % 12]
            
        case Accidentals.mixed:
            return noteNamesMixed[keyIndex % 12]

        }
    }
    
    
    // check if a key is white
    static func isWhiteKey(keyIndex: Int) -> Bool {
        
                                  // A  // Bb  // B  // C
        let isWhiteKey: [Bool] = [true, false, true, true, false, true, false, true, true, false, true, false]
        var result: Bool = false
        
        if isWhiteKey[keyIndex % 12] {
            result = true
        }
        
        return result
    }
    
    
}
