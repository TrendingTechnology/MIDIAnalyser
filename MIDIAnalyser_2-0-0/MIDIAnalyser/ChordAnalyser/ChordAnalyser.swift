//
//  ChordAnalyser.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 05/04/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//


import Foundation


class ChordAnalyser {
    
    
    // analyser variables
    var chordName: String = ""
    var possibleChordNames: [String] = Array(repeating: "", count: 2)
    var chord: Chord = Chord("")
    var possibleChords: [Chord] = []
    var accidentals: Key.NoteNameFormat = Key.NoteNameFormat.mixed
    
    // analyser constants
    let intervalNames: [String] = ["unison",
                                   "minor 2nd", "major 2nd",
                                   "minor 3rd", "major 3rd",
                                   "perfect 4th",
                                   "tritone",
                                   "perfect 5th",
                                   "minor 6th", "major 6th",
                                   "minor 7th", "major 7th",
                                   "octave"]
    
    // initialisation
    init() {
        
        // observe chord note messages coming from the keyboard
        NotificationCenter.default.addObserver(self, selector: #selector(analyse), name: NSNotification.Name(rawValue: ChordNotesMessage.ChordNotesMessageName), object: nil)
        GrandStaffNotificationCenter.observe(type: .keySignature, observer: self, selector: #selector(updateAccidentals))
    }
    
    // update accidentals from grand staff
    @objc func updateAccidentals(_ notification: Notification) {
        
        if let keySignature = notification.object as? GrandStaffKeySignature {
            
            if keySignature.isSharpsKey {
                accidentals = .sharps
            }
            else if keySignature === GrandStaffKeySignature.noKey {
                accidentals = .mixed
            }
            else {
                accidentals = .flats
            }
        }
        
    }
    
    
    // main analysis function
    @objc func analyse(_ notification: Notification) {  // (_ keysPressed: [Int])
        
        // deconstruct notification
        var keysPressed: [Int] = Array()
        
        if let message = notification.object as? ChordNotesMessage {
            keysPressed = message.notes
        }
  
        // work out key states
        var keyStates: [Bool] = Array(repeating: false, count: Keyboard.nKeys)
        
        for pressedKey in keysPressed {
            keyStates[Keyboard.keyIndexOfMIDINumber(pressedKey)] = true
        }
        
        // generate basic note input data
        let nKeysPressed: Int = countKeysPressed(keyStates)
        let notes: [Int] = notesInChord(keyStates: keyStates, nKeysPressed: nKeysPressed)
        let noteNames: [String] = noteNamesInChord(notes)
        
        // work out unique notes
        var uniqueNoteNames: [String] = noteNames
        uniqueNoteNames.removeDuplicates()
        let nUniqueNotes: Int = uniqueNoteNames.count
        
        // single notes
        if(nUniqueNotes == 1) {
            chordName = uniqueNoteNames[0] + " (note)"
            
        }
            
        // intervals
        else if(nUniqueNotes == 2) {
            // TODO: interval names
            chordName = "interval (to do)"
            
            if determineIntervals(notes).contains(7) {
                chord = Chord(uniqueNoteNames[0])
                chord.setBaseTonality(.five)
                
            }
            else {
                chord = Chord("")
            }
            
            var chords: [Chord] = Array()
            chords.append(chord)
            
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: ChordMessage.ChordMessageName), object: ChordMessage(chords))
            
            
        }
            
            
        // chords
        else if(nUniqueNotes >= 3) {

            
            // generate interval data from notes
            let intervals: [Int] = determineIntervals(notes)
            let intervalSets: [[Int]] = generateIntervalSets(intervals)
            
            // iterate through interval sets and determine possible chord names
            possibleChords = Array(repeating: Chord(""), count: intervalSets.count)
            
            possibleChords[0] = analysePermutation(intervals: intervalSets[0], root: uniqueNoteNames[0])
            possibleChords[0].estimateComplexity()
            print(possibleChords[0].complexity, "\t", possibleChords[0].name())
            
            for i in 1...intervalSets.count - 1  {
                possibleChords[i] = analysePermutation(intervals: intervalSets[i], root: uniqueNoteNames[i])
                possibleChords[i].setSlash(noteNames[0])
                possibleChords[i].estimateComplexity()
                print(possibleChords[i].complexity, "\t", possibleChords[i].name())
            }
            
            print("")
            
            // determine most likely chord name
            chord = mostLikelyChord(possibleChords)
            chordName = chord.name()
            
            // record other possibilities
            possibleChordNames = Array(repeating: "", count: possibleChords.count)
            
            for (index, chord) in possibleChords.enumerated() {
                 possibleChordNames[index] = chord.name()
            }
            
            // reorder possible chords by complexity
            possibleChords.sort(by: {$0.complexity < $1.complexity})
            
            // post the message of possible chords
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: ChordMessage.ChordMessageName), object: ChordMessage(possibleChords))
            
        }
        else {
            chordName = "-"
            var chords: [Chord] = Array()
            chords.append(Chord(""))
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: ChordMessage.ChordMessageName), object: ChordMessage(chords))
        }
        
        
    }
    
    
    // analyse one chord from its intervals
    private func analysePermutation(intervals: [Int], root: String) -> Chord {
        
        // create chord
        let chord: Chord = Chord(root)
        
        // define interval names in terms of semitones
        let minorSecond = 1
        let majorSecond = 2
        let minorThird = 3
        let majorThird = 4
        let perfectFourth = 5
        let flatFifth = 6
        let perfectFifth = 7
        let minorSixth = 8
        let majorSixth = 9
        let minorSeventh = 10
        let majorSeventh = 11
        
        
        // decide which intervals are in the chord
        var intervalStates: [Bool] = Array(repeating: false, count: 12)
        
        for i in 0...12 {
            if(intervals.contains(i)) {
                intervalStates[i] = true
            }
        }
        
        intervalStates[0] = false // ignore unison zero distance interval
        
        
        // first determine base tonality (major, minor, diminished, augmented, sus2, sus4, no5)
        
        if(intervalStates[perfectFifth]) {
            
            intervalStates[perfectFifth] = false
            
            if(intervalStates[majorThird]) {
                chord.setBaseTonality(.major)
                intervalStates[majorThird] = false
            }
            else if(intervalStates[minorThird]) {
                chord.setBaseTonality(.minor)
                intervalStates[minorThird] = false
            }
            else if(intervalStates[majorSecond]) {
                chord.setBaseTonality(.sus2)
                intervalStates[majorSecond] = false
            }
            else if(intervalStates[perfectFourth]) {
                chord.setBaseTonality(.sus4)
                intervalStates[perfectFourth] = false
            }
            else {
                chord.setBaseTonality(.five)
            }
        }
        else if(intervalStates[flatFifth] && intervalStates[minorThird]) {
            chord.setBaseTonality(.diminished)
            intervalStates[flatFifth] = false
            intervalStates[minorThird] = false
        }
        else if(intervalStates[minorSixth] && intervalStates[majorThird]) {
            chord.setBaseTonality(.augmented)
            intervalStates[minorSixth] = false
            intervalStates[majorThird] = false
        }
        else {
            
            // stuff with no 5
            if(intervalStates[majorThird]) {
                chord.setBaseTonality(.majorNoFive)
                intervalStates[majorThird] = false
            }
            else if(intervalStates[minorThird]) {
                chord.setBaseTonality(.minorNoFive)
                intervalStates[minorThird] = false
            }
            else if(intervalStates[majorSecond]) {
                chord.setBaseTonality(.sus2NoFive)
                intervalStates[majorSecond] = false
            }
            else if(intervalStates[perfectFourth]) {
                chord.setBaseTonality(.sus4NoFive)
                intervalStates[perfectFourth] = false
            }
            else {
                chord.setBaseTonality(.unknown)
            }
            
        }
  
        
        // check for primary extensions
        
        if(intervalStates[majorSeventh]) {
            chord.setPrimaryExtension(.majorSeventh)
            intervalStates[majorSeventh] = false
        }
        else if(intervalStates[minorSeventh]) {
            chord.setPrimaryExtension(.minorSeventh)
            intervalStates[minorSeventh] = false
        }
        else if(intervalStates[majorSixth] && intervalStates[majorSecond] && (chord.baseTonality != .five)) {
            chord.setPrimaryExtension(.sixNine)
            intervalStates[majorSixth] = false
            intervalStates[majorSecond] = false
        }
        else if(intervalStates[majorSixth] && (chord.baseTonality != .five)) {
            chord.setPrimaryExtension(.sixth)
            intervalStates[majorSixth] = false
        }
        
        // add extensions
        if(intervalStates[minorSecond])     {chord.addExtension(.flatNine);         intervalStates[minorSecond] = false}
        if(intervalStates[majorSecond])     {chord.addExtension(.nine);             intervalStates[majorSecond] = false}
        if(intervalStates[minorThird])      {chord.addExtension(.sharpNine);        intervalStates[minorThird] = false}
        if(intervalStates[perfectFourth])   {chord.addExtension(.eleven);           intervalStates[perfectFourth] = false}
        if(intervalStates[flatFifth])       {chord.addExtension(.sharpEleven);      intervalStates[flatFifth] = false}
        if(intervalStates[minorSixth])      {chord.addExtension(.flatThirteen);     intervalStates[minorSixth] = false}
        if(intervalStates[majorSixth])      {chord.addExtension(.thirteen);         intervalStates[majorSixth] = false}
        if(intervalStates[minorSeventh])    {chord.addExtension(.sharpThirteen);    intervalStates[minorSeventh] = false}
        
        // check for any intervals unaccounted for
        for interval in intervalStates {
            if interval {
                print("analysePermutation(): interval not accounted for in name")
            }
        }
        
        return chord
    }
    
    // pick the most likely chord
    private func mostLikelyChord(_ possibleChords: [Chord]) -> Chord {
        
        var mostLikelyIndex = 0
        
        for i in 0...(possibleChords.count - 1) {
            
            if(possibleChords[i].complexity < possibleChords[mostLikelyIndex].complexity) {
                mostLikelyIndex = i
            }
            else if(possibleChords[i].complexity == possibleChords[mostLikelyIndex].complexity) {
                if(possibleChords[i].name().count < possibleChords[mostLikelyIndex].name().count) {
                    mostLikelyIndex = i
                }
            }
            
        }
        
        return possibleChords[mostLikelyIndex]
    }
    
    // work out how many keys pressed
    private func countKeysPressed(_ keyStates: [Bool]) -> Int {
        
        // count number of keys pressed
        var n = 0
        
        for state in keyStates {
            if state {
                n += 1
            }
        }
        
        return n
    }
    
    // list unique notes
    private func notesInChord(keyStates: [Bool], nKeysPressed: Int) -> [Int] {
        
        var notes: [Int] = Array(repeating: 0, count: nKeysPressed)
        
        var i: Int = 0
        var j: Int = 0
        
        for state in keyStates {
            
            if state {
                notes[j] = i + Keyboard.minMIDINumber
                j += 1
            }
            
            i += 1
            
        }
        
        // make sure that the notes are all in the same octave
        // this ensures the interval sets match the note names
        if notes.count != 0 {
            
            let lowestNote: Int = notes[0]
            
            for i in 0...(notes.count-1) {
                notes[i] -= lowestNote
                notes[i] = notes[i] % 12
                notes[i] += lowestNote
            }
            
            notes.sort()
        }

        
        return notes
        
    }
    
    // list names of notes in chord
    private func noteNamesInChord(_ notes: [Int]) -> [String] {
        
        var noteNames: [String] = Array(repeating: "", count: notes.count)
        
        var i: Int = 0
        
        for note in notes {
            noteNames[i] = Key.noteName(format: accidentals, MIDINumber: Keyboard.keyIndexOfMIDINumber(note))
            i += 1
        }
        
        return noteNames
    }
    
    // generate interval sets
    private func determineIntervals(_ notes: [Int]) -> [Int] {
        
        // figure out intervals in chord (assuming lowest note is root)
        var intervals: [Int] = Array(repeating: 0, count: notes.count)
        
        for i in 0...(notes.count - 1) {
            intervals[i] = (notes[i] - notes[0]) % 12 // mod 12 removes compound intervals
        }
        
        intervals.sort()
        intervals.removeDuplicates()
        
        return intervals
        
    }
    
    private func generateIntervalSets(_ intervals: [Int]) -> [[Int]] {
        
        var intervalSets: [[Int]] = Array(repeating: Array(repeating: 0, count: intervals.count), count: intervals.count)
        intervalSets[0] = intervals
        
        // generate each possible combination of intervals that exist in chord
        for i in 1...intervals.count - 1 {
            
            for j in 0...intervals.count - 2 {
                intervalSets[i][j] = intervalSets[i - 1][j + 1]
            }
            
            intervalSets[i][intervals.count - 1] = 12 // last one always 12 (8ve shifted up)
            
            let offset: Int = intervalSets[i][0]
            
            for j in 0...intervals.count - 1 {
                intervalSets[i][j] -= offset
            }
            
        }
        
        return intervalSets
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



