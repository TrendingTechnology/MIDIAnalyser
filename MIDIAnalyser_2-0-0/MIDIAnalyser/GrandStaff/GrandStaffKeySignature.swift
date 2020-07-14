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
        "(select key signature)" : GrandStaffKeySignature.Cmajor,
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
    
    // static members
    static let notes: [String : Accidental] = [
        "F#" : Accidental(type: .sharp, trebleStaffLineNumber: 4,   bassStaffLineNumber: 3,     order: 0),
        "C#" : Accidental(type: .sharp, trebleStaffLineNumber: 2.5, bassStaffLineNumber: 1.5,   order: 1),
        "G#" : Accidental(type: .sharp, trebleStaffLineNumber: 4.5, bassStaffLineNumber: 3.5,   order: 2),
        "D#" : Accidental(type: .sharp, trebleStaffLineNumber: 3,   bassStaffLineNumber: 2,     order: 3),
        "A#" : Accidental(type: .sharp, trebleStaffLineNumber: 1.5, bassStaffLineNumber: 0.5,   order: 4),
        "Bb" : Accidental(type: .flat,  trebleStaffLineNumber: 2,   bassStaffLineNumber: 1,     order: 0),
        "Eb" : Accidental(type: .flat,  trebleStaffLineNumber: 3.5, bassStaffLineNumber: 2.5,   order: 1),
        "Ab" : Accidental(type: .flat,  trebleStaffLineNumber: 1.5, bassStaffLineNumber: 0.5,   order: 2),
        "Db" : Accidental(type: .flat,  trebleStaffLineNumber: 3,   bassStaffLineNumber: 2,     order: 3),
        "Gb" : Accidental(type: .flat,  trebleStaffLineNumber: 1,   bassStaffLineNumber: 0,     order: 4),
        "Cb" : Accidental(type: .flat,  trebleStaffLineNumber: 2.5, bassStaffLineNumber: 1.5,   order: 5)
    ]
    
    static var Cmajor: GrandStaffKeySignature {
        get {
            let sharps: [Accidental] = []
            return GrandStaffKeySignature(sharps: sharps)
        }
    }
    
    static var Gmajor: GrandStaffKeySignature {
        get {
            let sharps: [Accidental] = [
                GrandStaffKeySignature.notes["F#"]!,
            ]
            return GrandStaffKeySignature(sharps: sharps)
        }
    }
    
    static var Dmajor: GrandStaffKeySignature {
        get {
            let sharps: [Accidental] = [
                GrandStaffKeySignature.notes["F#"]!,
                GrandStaffKeySignature.notes["C#"]!
            ]
            return GrandStaffKeySignature(sharps: sharps)
        }
    }
    
    static var Amajor: GrandStaffKeySignature {
        get {
            let sharps: [Accidental] = [
                GrandStaffKeySignature.notes["F#"]!,
                GrandStaffKeySignature.notes["C#"]!,
                GrandStaffKeySignature.notes["G#"]!
            ]
            return GrandStaffKeySignature(sharps: sharps)
        }
    }
    
    static var Emajor: GrandStaffKeySignature {
        get {
            let sharps: [Accidental] = [
                GrandStaffKeySignature.notes["F#"]!,
                GrandStaffKeySignature.notes["C#"]!,
                GrandStaffKeySignature.notes["G#"]!,
                GrandStaffKeySignature.notes["D#"]!
            ]
            return GrandStaffKeySignature(sharps: sharps)
        }
    }
    
    static var Bmajor: GrandStaffKeySignature {
        get {
            let sharps: [Accidental] = [
                GrandStaffKeySignature.notes["F#"]!,
                GrandStaffKeySignature.notes["C#"]!,
                GrandStaffKeySignature.notes["G#"]!,
                GrandStaffKeySignature.notes["D#"]!,
                GrandStaffKeySignature.notes["A#"]!
            ]
            return GrandStaffKeySignature(sharps: sharps)
        }
    }

    static var Fmajor: GrandStaffKeySignature {
        get {
            let flats: [Accidental] = [
                GrandStaffKeySignature.notes["Bb"]!
            ]
            return GrandStaffKeySignature(flats: flats)
        }
    }
    
    static var Bbmajor: GrandStaffKeySignature {
        get {
            let flats: [Accidental] = [
                GrandStaffKeySignature.notes["Bb"]!,
                GrandStaffKeySignature.notes["Eb"]!
            ]
            return GrandStaffKeySignature(flats: flats)
        }
    }
    
    static var Ebmajor: GrandStaffKeySignature {
        get {
            let flats: [Accidental] = [
                GrandStaffKeySignature.notes["Bb"]!,
                GrandStaffKeySignature.notes["Eb"]!,
                GrandStaffKeySignature.notes["Ab"]!
            ]
            return GrandStaffKeySignature(flats: flats)
        }
    }
    
    static var Abmajor: GrandStaffKeySignature {
        get {
            let flats: [Accidental] = [
                GrandStaffKeySignature.notes["Bb"]!,
                GrandStaffKeySignature.notes["Eb"]!,
                GrandStaffKeySignature.notes["Ab"]!,
                GrandStaffKeySignature.notes["Db"]!
            ]
            return GrandStaffKeySignature(flats: flats)
        }
    }
    
    static var Dbmajor: GrandStaffKeySignature {
        get {
            let flats: [Accidental] = [
                GrandStaffKeySignature.notes["Bb"]!,
                GrandStaffKeySignature.notes["Eb"]!,
                GrandStaffKeySignature.notes["Ab"]!,
                GrandStaffKeySignature.notes["Db"]!,
                GrandStaffKeySignature.notes["Gb"]!
            ]
            return GrandStaffKeySignature(flats: flats)
        }
    }
    
    static var Gbmajor: GrandStaffKeySignature {
        get {
            let flats: [Accidental] = [
                GrandStaffKeySignature.notes["Bb"]!,
                GrandStaffKeySignature.notes["Eb"]!,
                GrandStaffKeySignature.notes["Ab"]!,
                GrandStaffKeySignature.notes["Db"]!,
                GrandStaffKeySignature.notes["Gb"]!,
                GrandStaffKeySignature.notes["Cb"]!
            ]
            return GrandStaffKeySignature(flats: flats)
        }
    }
    
}
