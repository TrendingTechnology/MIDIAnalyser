//
//  Key.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 03/07/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Foundation


class Key: NSCopying {
    
    
    // different accidental types
    enum NoteNameFormat {
        case sharps, flats, mixed
    }
    
    // key colours
    enum KeyType {
        case white, black
    }
    
    // lists of possible note names for each way of naming
    static let noteNamesSharps = ["A", "A#", "B", "C", "C#", "D", "D#", "E", "F", "F#", "G", "G#"]
    static let noteNamesFlats  = ["A", "Bb", "B", "C", "Db", "D", "Eb", "E", "F", "Gb", "G", "Ab"]
    static let noteNamesMixed  = ["A", "Bb", "B", "C", "Db", "D", "Eb", "E", "F", "F#", "G", "Ab"]
    
    // key data
    var state: Bool
    var octave: Int
    var MIDINumber: Int
    var keyType: KeyType
    var index: Int

    
    // initialisation
    init(keyType: KeyType, MIDINumber: Int, octave: Int, index: Int) {
        state = false
        self.MIDINumber = MIDINumber
        self.octave = octave
        self.keyType = keyType
        self.index = index
    }
    
    
    // return the note name of the key in the specified format
    static func noteName(format: NoteNameFormat, MIDINumber: Int) -> String {
        
        switch format {
        
        case .sharps:
            return Key.noteNamesSharps[MIDINumber % 12]
            
        case .flats:
            return Key.noteNamesFlats[MIDINumber % 12]
            
        case .mixed:
            return Key.noteNamesMixed[MIDINumber % 12]
            
        }
        
    }
    
    // function for copying key objects
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Key(keyType: keyType, MIDINumber: MIDINumber, octave: octave, index: index)
        return copy
    }
    
}
