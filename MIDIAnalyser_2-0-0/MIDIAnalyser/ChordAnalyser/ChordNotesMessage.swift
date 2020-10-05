//
//  ChordNotesMessage.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 04/07/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Foundation


class ChordNotesMessage {
    
    static let ChordNotesMessageName = "chordNotes"
    
    var notes: [Int]
    
    init(_ notes: [Int]) {
        self.notes = notes
    }
    
}

