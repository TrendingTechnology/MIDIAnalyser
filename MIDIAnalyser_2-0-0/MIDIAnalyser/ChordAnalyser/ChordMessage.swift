//
//  ChordMessage.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 07/07/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Foundation

class ChordMessage {
    
    static let ChordMessageName = "chordMessage"
    
    var chord: Chord
    
    init(_ chord: Chord) {
        self.chord = chord
    }
    
}
