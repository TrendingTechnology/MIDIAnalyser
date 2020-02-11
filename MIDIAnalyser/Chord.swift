//
//  Chord.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 11/02/2020.
//  Copyright © 2020 AudioKit. All rights reserved.
//

import Foundation

class ChordAnalyser {
    
    // variables
    var chordName: String = ""
    var keys: Keyboard = Keyboard()
    var accidentals: Keyboard.Accidentals = Keyboard.Accidentals.sharps
    
    let intervalNames: [String] = ["unison",
                                   "minor 2nd", "major 2nd",
                                   "minor 3rd", "major 3rd",
                                   "perfect 4th",
                                   "tritone",
                                   "perfect 5th",
                                   "minor 6th", "major 6th",
                                   "minor 7th", "major 7th",
                                   "octave"]
    
    // initialiser
    init(keyboard: Keyboard) {
        keys = keyboard
    }
    
    // utility functions
    func analyse(keyStates: [Bool], notes: [Int], nKeys: Int) {
        
        
        // figure out intervals in chord (assuming lowest note is root)
        var intervals: [Int] = Array(repeating: 0, count: notes.count)
        
        for i in 0...(notes.count - 1) {
            intervals[i] = (notes[i] - notes[0]) % 12 // mod 12 removes compound intervals
        }
        
        intervals.sort()
        intervals.removeDuplicates()
        
        
        // triads and extended chords
        if intervals.count > 2 {
            
            // analyse all possible combinations of intervals
            let nCombinations: Int = intervals.count - 1
            var possibleChords: [String] = Array(repeating: "", count: intervals.count)
            
            // analyse first permutation
            possibleChords[0] = analysePermutation(intervals: intervals, root: keys.noteNameOfKey(key: notes[0] + keys.minMIDINumber, type: accidentals))
            
            // go through permutations
            for i in 1...nCombinations {
                
                // rearrange intervals into next combination
                for j in (0...nCombinations - 1) {
                    intervals[j] = intervals[j + 1]
                }
                
                intervals[nCombinations] = 12 // last one always 12 (octave shifted up)
                
                let offset: Int = intervals[0]
                
                for j in 0...nCombinations {
                    intervals[j] -= offset;
                }
                
                // every loop, using latest interval set, analyse the chord
                possibleChords[i] = analysePermutation(intervals: intervals, root: keys.noteNameOfKey(key: notes[i] + keys.minMIDINumber, type: accidentals)) + "/" + keys.noteNameOfKey(key: notes[0] + keys.minMIDINumber, type: accidentals)
                
            }
            
            
            // choose the most likely chord name
            chordName = mostLikelyChord(possibleChords: possibleChords)
            
            
        }
        // intervals
        else if intervals.count == 2 {
            
            chordName = keys.noteNameOfKey(key: notes[0]
                        + keys.minMIDINumber, type: accidentals)
                        + ", "
                        + keys.noteNameOfKey(key: notes[1]
                        + keys.minMIDINumber, type: accidentals)
                        + ": "
                        + intervalNames[intervals[1]]
            
        }
        // single notes
        else if intervals.count == 1 {
            chordName = keys.noteNameOfKey(key: notes[0] + keys.minMIDINumber, type: accidentals) + " (note)"
        }
        // no notes
        else {
            chordName = ""
        }
        
        
    }
    
    func analysePermutation(intervals: [Int], root: String) -> String {
        
        var chord: String = ""
        var base: String = ""
        var ext: String = ""
        
        // semitones corresponding to every interval
        let min2   = 1;
        let maj2   = 2;
        let min3   = 3;
        let maj3   = 4;
        let perf4  = 5;
        let aug4   = 6;
        let dim5   = 6;
        let perf5  = 7;
        let min6   = 8;
        let maj6   = 9;
        let min7   = 10;
        let maj7   = 11;
        
        // array determining if interval exists in chord
        var intervalStates: [Bool] = Array(repeating: false, count: 12)
        
        for i in 0...(intervals.count - 1)  {
            intervalStates[intervals[i]] = true
        }
        
        // determine chord
        var hasExt: Bool = false;
        
        if(intervalStates[perf5]) {
          
          // chords with a perfect fifth
          if(intervalStates[maj3]) {
            intervalStates[maj3] = false;
            if     (intervalStates[min7]) {base = "7";     intervalStates[min7] = false;}  // set the interval states to say they are accounted for
            else if(intervalStates[maj7]) {base = "maj7";  intervalStates[maj7] = false;}
            else if(intervalStates[maj6]) {base = "6";     intervalStates[maj6] = false;   if(intervalStates[maj2]){base = "6/9"; intervalStates[maj2] = false;}}  // special case for 6/9
            else                          {base = "";}
            
          }
          else if(intervalStates[min3]) {
            intervalStates[min3] = false;
            if     (intervalStates[min7]) {base = "m7";      intervalStates[min7] = false;}
            else if(intervalStates[maj6]) {base = "m6";      intervalStates[maj6] = false;}
            else if(intervalStates[maj7]) {base = "m(maj7)"; intervalStates[maj7] = false;}
            else                          {base = "m";}
          
          }
          else if(intervalStates[maj2])  {
            intervalStates[maj2] = false;
            if     (intervalStates[min7]) {base = "7sus2";    intervalStates[min7] = false;}
            else if(intervalStates[maj7]) {base = "maj7sus2"; intervalStates[maj7] = false;}
            else if(intervalStates[maj6]) {base = "6sus2";    intervalStates[maj6] = false;}
            else                          {base = "sus2";}
            
          }
          else if(intervalStates[perf4]) {
            intervalStates[perf4] = false;
            if     (intervalStates[min7]) {base = "7sus4";    intervalStates[min7] = false;}
            else if(intervalStates[maj7]) {base = "maj7sus4"; intervalStates[maj7] = false;}
            else if(intervalStates[maj6]) {base = "6sus4";    intervalStates[maj6] = false;}
            else                          {base = "sus4";}
          }
         
          
        }
        else {
          // chords without perfect fifth
          if(intervalStates[min3] && intervalStates[dim5]) {
            intervalStates[min3] = false;
            intervalStates[dim5] = false;
            if(intervalStates[maj6]) {base = "dim7";  intervalStates[maj6] = false;}
            else                     {base = "dim";}
          
          }
          else if(intervalStates[maj3] && intervalStates[min6]) {
            base = "aug";
            intervalStates[maj3] = false;
            intervalStates[min6] = false;
          }
          else {base = "?";}  // no 5 chords here
        }
        
        if(intervalStates[min2])  {if(hasExt) {ext += ",";}; ext += "b9";  hasExt = true;}  // add comma if already extension
        if(intervalStates[maj2])  {if(hasExt) {ext += ",";}; ext += "9";   hasExt = true;}
        if(intervalStates[min3])  {if(hasExt) {ext += ",";}; ext += "#9";  hasExt = true;}
        if(intervalStates[perf4]) {if(hasExt) {ext += ",";}; ext += "11";  hasExt = true;}
        if(intervalStates[aug4])  {if(hasExt) {ext += ",";}; ext += "#11"; hasExt = true;}
        if(intervalStates[min6])  {if(hasExt) {ext += ",";}; ext += "b13"; hasExt = true;}
        if(intervalStates[maj6])  {if(hasExt) {ext += ",";}; ext += "13";  hasExt = true;}
        
        chord = root + base;
        
        if hasExt {
          if(ext.contains("b9") || ext.contains("#9") || ext.contains("#11") || ext.contains("b13") || ext.count > 3) {
            chord += "add(" + ext + ")";    // add brackets when extension has accidental or multiple extensions
          }
          else {
            chord += "add" + ext;
          }
        }
    
        return chord
    }
    
    // select the most likely chord from a set of chord names (needs improving)
    func mostLikelyChord(possibleChords: [String]) -> String {
        
        var bestGuess: String = possibleChords[0]
        
        for i in 1...(possibleChords.count - 1) {
            if possibleChords[i].count <= bestGuess.count {
                bestGuess = possibleChords[i]
            }
        }
        
        return bestGuess
    }
    
    
    
    
}

// remove duplicates from array
extension Array where Element: Hashable {
    func removingDuplicates() -> [Element] {
        var addedDict = [Element: Bool]()

        return filter {
            addedDict.updateValue(true, forKey: $0) == nil
        }
    }

    mutating func removeDuplicates() {
        self = self.removingDuplicates()
    }
}
