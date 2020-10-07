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
                
                // replace dictionary with calculation
                // this assumes all accidentals are sharps
                // missing low and high end
                let linesForMIDINumbers: [Int : Float] = [
                    60 : -1,
                    61 : -1,
                    62 : -0.5,
                    63 : -0.5,
                    64 : 0, // E
                    65 : 0.5,
                    66 : 0.5,
                    67 : 1,
                    68 : 1,
                    69 : 1.5,
                    70 : 1.5,
                    71 : 2,
                    72 : 2.5,
                    73 : 2.5,
                    74 : 3,
                    75 : 3,
                    76 : 3.5, // E
                    77 : 4,
                    78 : 4,
                    79 : 4.5,
                    80 : 4.5,
                    81 : 5,
                    82 : 5,
                    83 : 5.5,
                    84 : 6,
                ]
                
                // when accidentals added, need to shift up notes with
                // flats up by half a line
                
                return (linesForMIDINumbers[MIDINumber] ?? 0) + 1
                
            }
            else {
                
                // replace dictionary with calculation
                // this assumes all accidentals are sharps
                // missing low and high end
                let linesForMIDINumbers: [Int : Float] = [
                    36 : -2,
                    37 : -2,
                    38 : -1.5,
                    39 : -1.5,
                    40 : -1,
                    41 : -0.5,
                    42 : -0.5,
                    43 : 0,
                    44 : 0,
                    45 : 0.5,
                    46 : 0.5,
                    47 : 1,
                    48 : 1.5,
                    49 : 1.5,
                    50 : 2,
                    51 : 2,
                    52 : 2.5,
                    53 : 3,
                    54 : 3,
                    55 : 3.5,
                    56 : 3.5,
                    57 : 4.5,
                    58 : 4.5,
                    59 : 5,
                ]
                
                
                return (linesForMIDINumbers[MIDINumber] ?? 0) + 1
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
