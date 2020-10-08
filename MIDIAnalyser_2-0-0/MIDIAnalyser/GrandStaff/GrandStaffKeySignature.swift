//
//  GrandStaffKeySignature.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 08/07/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Foundation


class GrandStaffKeySignature {
    
    // key dictionary
    static let possibleKeys: KeyValuePairs = [
        "(select key signature)" : GrandStaffKeySignature.noKey,
        "no key" : GrandStaffKeySignature.noKey,
        "C major" : GrandStaffKeySignature.Cmajor,
        "G major" : GrandStaffKeySignature.Gmajor,
        "D major" : GrandStaffKeySignature.Dmajor,
        "A major" : GrandStaffKeySignature.Amajor,
        "E major" : GrandStaffKeySignature.Emajor,
        "B major" : GrandStaffKeySignature.Bmajor,
        "F major" : GrandStaffKeySignature.Fmajor,
        "B\u{266D} major" : GrandStaffKeySignature.Bbmajor,
        "E\u{266D} major" : GrandStaffKeySignature.Ebmajor,
        "A\u{266D} major" : GrandStaffKeySignature.Abmajor,
        "D\u{266D} major" : GrandStaffKeySignature.Dbmajor,
        "G\u{266D} major" : GrandStaffKeySignature.Gbmajor
    ]
    
    // enumerated types and structs
    enum AccidentalType {
        case sharp, flat
    }
    
    struct Accidental {
        var type: AccidentalType
        var trebleStaffLineNumber: Float // 0 => first line from bottom, 0.5 => first space between lines, etc...
        var bassStaffLineNumber: Float
        var order: Int
        var name: String
    }
    
    // class variables
    let isSharpsKey: Bool
    let accidentals: [Accidental]
    
    // initialisation
    init(sharps: [Accidental]) {
        accidentals = sharps
        isSharpsKey = true
    }
    
    init(flats: [Accidental]) {
        accidentals = flats
        isSharpsKey = false
    }
    
    init() {
        accidentals = []
        isSharpsKey = false
    }
    
    // static members
    static let accidentals: [String : Accidental] = [
        "F#" : Accidental(type: .sharp, trebleStaffLineNumber: 4,   bassStaffLineNumber: 3,     order: 0,   name: "F#"),
        "C#" : Accidental(type: .sharp, trebleStaffLineNumber: 2.5, bassStaffLineNumber: 1.5,   order: 1,   name: "C#"),
        "G#" : Accidental(type: .sharp, trebleStaffLineNumber: 4.5, bassStaffLineNumber: 3.5,   order: 2,   name: "G#"),
        "D#" : Accidental(type: .sharp, trebleStaffLineNumber: 3,   bassStaffLineNumber: 2,     order: 3,   name: "D#"),
        "A#" : Accidental(type: .sharp, trebleStaffLineNumber: 1.5, bassStaffLineNumber: 0.5,   order: 4,   name: "A#"),
        "Bb" : Accidental(type: .flat,  trebleStaffLineNumber: 2,   bassStaffLineNumber: 1,     order: 0,   name: "Bb"),
        "Eb" : Accidental(type: .flat,  trebleStaffLineNumber: 3.5, bassStaffLineNumber: 2.5,   order: 1,   name: "Eb"),
        "Ab" : Accidental(type: .flat,  trebleStaffLineNumber: 1.5, bassStaffLineNumber: 0.5,   order: 2,   name: "Ab"),
        "Db" : Accidental(type: .flat,  trebleStaffLineNumber: 3,   bassStaffLineNumber: 2,     order: 3,   name: "Db"),
        "Gb" : Accidental(type: .flat,  trebleStaffLineNumber: 1,   bassStaffLineNumber: 0,     order: 4,   name: "Gb"),
        "Cb" : Accidental(type: .flat,  trebleStaffLineNumber: 2.5, bassStaffLineNumber: 1.5,   order: 5,   name: "Cb")
    ]
    

    
    static var noKey: GrandStaffKeySignature {
        get {
            return GrandStaffKeySignature()
        }
    }
    
    static var Cmajor: GrandStaffKeySignature {
        get {
            return GrandStaffKeySignature()
        }
    }
    
    static var Gmajor: GrandStaffKeySignature {
        get {
            let sharps: [Accidental] = [
                GrandStaffKeySignature.accidentals["F#"]!,
            ]
            return GrandStaffKeySignature(sharps: sharps)
        }
    }
    
    static var Dmajor: GrandStaffKeySignature {
        get {
            let sharps: [Accidental] = [
                GrandStaffKeySignature.accidentals["F#"]!,
                GrandStaffKeySignature.accidentals["C#"]!
            ]
            return GrandStaffKeySignature(sharps: sharps)
        }
    }
    
    static var Amajor: GrandStaffKeySignature {
        get {
            let sharps: [Accidental] = [
                GrandStaffKeySignature.accidentals["F#"]!,
                GrandStaffKeySignature.accidentals["C#"]!,
                GrandStaffKeySignature.accidentals["G#"]!
            ]
            return GrandStaffKeySignature(sharps: sharps)
        }
    }
    
    static var Emajor: GrandStaffKeySignature {
        get {
            let sharps: [Accidental] = [
                GrandStaffKeySignature.accidentals["F#"]!,
                GrandStaffKeySignature.accidentals["C#"]!,
                GrandStaffKeySignature.accidentals["G#"]!,
                GrandStaffKeySignature.accidentals["D#"]!
            ]
            return GrandStaffKeySignature(sharps: sharps)
        }
    }
    
    static var Bmajor: GrandStaffKeySignature {
        get {
            let sharps: [Accidental] = [
                GrandStaffKeySignature.accidentals["F#"]!,
                GrandStaffKeySignature.accidentals["C#"]!,
                GrandStaffKeySignature.accidentals["G#"]!,
                GrandStaffKeySignature.accidentals["D#"]!,
                GrandStaffKeySignature.accidentals["A#"]!
            ]
            return GrandStaffKeySignature(sharps: sharps)
        }
    }

    static var Fmajor: GrandStaffKeySignature {
        get {
            let flats: [Accidental] = [
                GrandStaffKeySignature.accidentals["Bb"]!
            ]
            return GrandStaffKeySignature(flats: flats)
        }
    }
    
    static var Bbmajor: GrandStaffKeySignature {
        get {
            let flats: [Accidental] = [
                GrandStaffKeySignature.accidentals["Bb"]!,
                GrandStaffKeySignature.accidentals["Eb"]!
            ]
            return GrandStaffKeySignature(flats: flats)
        }
    }
    
    static var Ebmajor: GrandStaffKeySignature {
        get {
            let flats: [Accidental] = [
                GrandStaffKeySignature.accidentals["Bb"]!,
                GrandStaffKeySignature.accidentals["Eb"]!,
                GrandStaffKeySignature.accidentals["Ab"]!
            ]
            return GrandStaffKeySignature(flats: flats)
        }
    }
    
    static var Abmajor: GrandStaffKeySignature {
        get {
            let flats: [Accidental] = [
                GrandStaffKeySignature.accidentals["Bb"]!,
                GrandStaffKeySignature.accidentals["Eb"]!,
                GrandStaffKeySignature.accidentals["Ab"]!,
                GrandStaffKeySignature.accidentals["Db"]!
            ]
            return GrandStaffKeySignature(flats: flats)
        }
    }
    
    static var Dbmajor: GrandStaffKeySignature {
        get {
            let flats: [Accidental] = [
                GrandStaffKeySignature.accidentals["Bb"]!,
                GrandStaffKeySignature.accidentals["Eb"]!,
                GrandStaffKeySignature.accidentals["Ab"]!,
                GrandStaffKeySignature.accidentals["Db"]!,
                GrandStaffKeySignature.accidentals["Gb"]!
            ]
            return GrandStaffKeySignature(flats: flats)
        }
    }
    
    static var Gbmajor: GrandStaffKeySignature {
        get {
            let flats: [Accidental] = [
                GrandStaffKeySignature.accidentals["Bb"]!,
                GrandStaffKeySignature.accidentals["Eb"]!,
                GrandStaffKeySignature.accidentals["Ab"]!,
                GrandStaffKeySignature.accidentals["Db"]!,
                GrandStaffKeySignature.accidentals["Gb"]!,
                GrandStaffKeySignature.accidentals["Cb"]!
            ]
            return GrandStaffKeySignature(flats: flats)
        }
    }
    
    func isAccidentalInKey(note: GrandStaffNote) -> Bool {
        
        // check if the note matches a sharp
        if self.isSharpsKey {
            for accidental in self.accidentals {
                if note.noteNameSharp == accidental.name {
                    return true
                }
            }
        }
        // check if the note matches a flat
        else {
            for accidental in self.accidentals {
                if note.noteNameFlat == accidental.name {
                    return true
                }
            }
        }
        
        return false
    }
    
}
