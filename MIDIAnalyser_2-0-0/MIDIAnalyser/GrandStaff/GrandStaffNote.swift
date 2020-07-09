//
//  GrandStaffNote.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 09/07/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Foundation


class GrandStaffNote {
    
    // enumerated types
    enum StemDirection {
        case up, down
    }
    
    enum NoteHeadDirection {
        case left, right
    }
    
    enum Staff {
        case treble, bass
    }
    
    // class variables
    static let noteHeadCode: String = "\u{E136}"
    static let trebleStaffLowestMIDINumber = 60
    static let trebleStaffFirstLedgerLowMIDINumber = 60
    
    var MIDINumber: Int = 0
    var staff: Staff = .treble
    
    // get variables
    var octave: Int {
        get {
            return (MIDINumber - Keyboard.minMIDINumber + 9) / 12
        }
    }
    
    var staffToDrawOn: Staff {
        get {
            return self.octave < 4 ? .bass : .treble
        }
    }
    
    var lineToDrawOn: Float {
        get {
            if staffToDrawOn == .treble {
                return Float(MIDINumber - GrandStaffNote.trebleStaffLowestMIDINumber - 2) / 2
            }
            else {
                return Float(0) /// missing
            }
        }
    }
    
    var requiresLedgerLine: Bool {
        get {
            if staffToDrawOn == .treble { /// only for bottom ledger
                return MIDINumber <= GrandStaffNote.trebleStaffFirstLedgerLowMIDINumber
            }
            else {
                return false /// missing
            }
        }
    }
    
    // initialisation
    init(MIDINumber: Int) {
        self.MIDINumber = MIDINumber
    }
    
    // work out which staff to draw on
    
    
    
}
