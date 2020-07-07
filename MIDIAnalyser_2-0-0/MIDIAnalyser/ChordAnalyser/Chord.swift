//
//  Chord.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 08/04/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Foundation


class Chord {
    
    
    // enumerated types
    enum BaseTonality: String {
        case unknown = "(no3)"
        case major = ""
        case minor = "m"
        case diminished = "dim"
        case augmented = "aug"
        case sus2 = "sus2"
        case sus4 = "sus4"
        case five = "5"
        case majorNoFive = "(no5)"
        case minorNoFive = "m(no5)"
        case sus2NoFive = "sus2(no5)"
        case sus4NoFive = "sus4(no5)"
    }
    
    enum PrimaryExtension: String {
        case none = ""
        case majorSeventh = "maj7"
        case minorSeventh = "7"
        case sixth = "6"
        case sixNine = "6/9"
    }
    
    enum Extension: Int {
        case flatNine
        case nine
        case sharpNine
        case eleven
        case sharpEleven
        case flatThirteen
        case thirteen
        case sharpThirteen
    }
    
    
    // strings to represent extensions
    let extensionNames: [String] = [
        "b9",
        "9",
        "#9",
        "11",
        "#11",
        "b13",
        "13",
        "#13"
    ]
    
    // chord definition variables
    var primaryExtension: PrimaryExtension = .none
    var baseTonality: BaseTonality = .unknown
    var extensions: [Bool] = Array(repeating: false, count: 8)  // 8 possible extensions
    var chordName: String = ""
    var root: String = ""
    var slashRoot: String = ""
    var isSlashChord: Bool = false
    var hasExtensions: Bool = false
    
    var complexity: Int = 1
    
    
    // initialisation
    init(_ rootNote: String) {
        root = rootNote
    }
    
    
    // chord data functions
    func addExtension(_ ext: Extension) {
        extensions[ext.rawValue] = true
        hasExtensions = true
    }
    
    func setBaseTonality(_ tonality: BaseTonality) {
        baseTonality = tonality
    }
    
    func setPrimaryExtension(_ ext: PrimaryExtension) {
        primaryExtension = ext
    }
    
    func hasBaseTonality(_ tonality: BaseTonality) -> Bool {
        return baseTonality == tonality
    }
    
    func hasPrimaryExtension(_ ext: PrimaryExtension) -> Bool {
        return primaryExtension == ext
    }
    
    func hasExtension(_ ext: Extension) -> Bool {
        return extensions[ext.rawValue]
    }
    
    func setSlash(_ note: String) {
        slashRoot = " / " + note
        isSlashChord = true
    }
    
    func setRoot(_ rootNote: String) {
        root = rootNote
    }
    
    // name generating function
    func name() -> String {
        
        
        if root != "" {
            // generate string of extensions
            var extensionString: String = ""
            
            if(hasExtensions) {
            
                extensionString = "add("
                
                for i in 0...(extensions.count - 1) {
                    if extensions[i] {
                        extensionString += extensionNames[i] + ","
                    }
                }
                
                extensionString += ")"
                extensionString = extensionString.replacingOccurrences(of: ",)", with: ")", options: .literal, range: nil)
                
            }
                
            // special formatting for sus chords with extensions
            if (baseTonality == BaseTonality.sus2) || (baseTonality == BaseTonality.sus4) || (baseTonality == BaseTonality.sus2NoFive) || (baseTonality == BaseTonality.sus4NoFive) {
                chordName = root + primaryExtension.rawValue + baseTonality.rawValue + extensionString + slashRoot
            }
            
            // special formatting for 5 chords with extensions
            else if (baseTonality == BaseTonality.five) && (primaryExtension != PrimaryExtension.none) {
                chordName = root + primaryExtension.rawValue + "(no3)" + extensionString + slashRoot
            }
                
            // diminished chords have primary extensions named differently
            else if (baseTonality == BaseTonality.diminished) && (primaryExtension != PrimaryExtension.none) {
                
                switch primaryExtension {
                
                case PrimaryExtension.sixth:
                    chordName = root + baseTonality.rawValue + "7" + extensionString + slashRoot
                    
                case PrimaryExtension.sixNine:
                    chordName = root + baseTonality.rawValue + "7" + "add(9)" + extensionString + slashRoot
                
                case PrimaryExtension.minorSeventh:
                    chordName = root + "m7b5" + extensionString + slashRoot
                    
                case PrimaryExtension.majorSeventh:
                    chordName = root + "maj7b5" + extensionString + slashRoot
                    
                case PrimaryExtension.none:
                    break
                    
                }
                    
            }
            
            // general chord naming format, no special cases
            else {
               chordName = root + baseTonality.rawValue + primaryExtension.rawValue + extensionString + slashRoot
            }
            
            // replace sharp and flat symbols
            chordName = chordName.replacingOccurrences(of: "#", with: "\u{266F}", options: .literal, range: nil)
            chordName = chordName.replacingOccurrences(of: "b", with: "\u{266D}", options: .literal, range: nil)
            
            estimateComplexity()
        }
        else {
            chordName = ""
        }
        
        return chordName
    }
    
    // chord complexity estimation (not an exact science!)
    func estimateComplexity() {
        
        complexity = 0
        
        // base tonality
        if (baseTonality == .major) || (baseTonality == .minor) {
            complexity += 1
        }
        else if (baseTonality == .diminished) || (baseTonality == .augmented) {
            complexity += 2
        }
        else if (baseTonality == .sus2) || (baseTonality == .sus4) {
            complexity += 3
        }
        else if (baseTonality == .five) {
            complexity += 1
        }
        else if (baseTonality == .unknown) {
            complexity += 0
        }
        else { // no5
            complexity += 5
        }
        
        // primary extension
        if (primaryExtension == .sixNine) {
            complexity += 5
        }
        else if(primaryExtension != .none) {
            complexity += 2
        }
        
        // extensions
        if(extensions[Extension.nine.rawValue]) {
            complexity += 3
        }
        if(extensions[Extension.sharpNine.rawValue]) {
            complexity += 3
        }
        if(extensions[Extension.eleven.rawValue]) {
            complexity += 3
        }
        if(extensions[Extension.sharpEleven.rawValue]) {
            complexity += 3
        }
        if(extensions[Extension.flatThirteen.rawValue]) {
            complexity += 3
        }
        if(extensions[Extension.thirteen.rawValue]) {
            complexity += 3
        }
        if(extensions[Extension.sharpThirteen.rawValue]) {
            complexity += 3
        }
        
        if(isSlashChord) {
            complexity += 3
        }
          
    }

}
