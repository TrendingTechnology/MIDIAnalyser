//
//  Keyboard.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 11/02/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Foundation
import Cocoa
import AudioKit

class Keyboard {
    
    // variables
    let minMIDINumber = 21
    let maxMIDINumber = 108
    
    var nKeys: Int?
    var keyStates: [Bool] = Array()     // represents state of all keys on keyboard
    var noteStates: [Bool] = Array()    // representes states of the 12 chromatic notes
    
    var nKeysPressed: Int = 0
    var notes: [Int] = []
    
    enum Accidentals {case sharps; case flats; case mixed;}
    let noteNamesSharps = ["C", "C#", "D", "D#", "E", "F", "F#", "G", "G#", "A", "A#", "B"]
    let noteNamesFlats  = ["C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab", "A", "Bb", "B"]
    let noteNamesMixed  = ["C", "Db", "D", "Eb", "E", "F", "F#", "G", "Ab", "A", "Bb", "B"]

    
    // initialiser
    init() {
        nKeys = maxMIDINumber - (minMIDINumber - 1)
        keyStates = Array(repeating: false, count: nKeys!)
        noteStates = Array(repeating: false, count: 12)
    }
    
    
    // accessor functions
    func updateKeys(key: Int, state: Bool) {
        
        if(key >= minMIDINumber && key <= maxMIDINumber) {
            keyStates[key - minMIDINumber] = state
            noteStates[(key) % 12] = state
            
            // determine how many keys pressed and which notes
            nKeysPressed = 0
            var nNotes: Int = 0
            
            for keyState in keyStates {
                if keyState {
                    nKeysPressed += 1
                }
            }
            
            notes = Array(repeating: 0, count: nKeysPressed)
            
            for i in 0...(nKeys! - 1) {
                if keyStates[i] {
                    notes[nNotes] = i
                    nNotes += 1
                }
            }
            
        }
        else {
            print("Invalid key input")
        }
    }
    
    func getKeyState(key: Int) -> Bool {
        return keyStates[key - minMIDINumber]
    }
    
    
    // utility functions
    func noteNameOfKey(key: Int, type: Accidentals) -> String {
        
        switch(type) {
            
        case Accidentals.sharps:
            return noteNamesSharps[key % 12]

        case Accidentals.flats:
            return noteNamesFlats[key % 12]
            
        case Accidentals.mixed:
            return noteNamesMixed[key % 12]

        }
    }
    
}
