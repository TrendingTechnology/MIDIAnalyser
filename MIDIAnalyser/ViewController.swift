//
//  ViewController.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 11/02/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

/*
    NSTextField: https://forums.raywenderlich.com/t/nstextfield-whats-up-with-that/60577/2
 
 
 
 */

import AudioKit
import AppKit
import Cocoa

class ViewController: NSViewController, AKMIDIListener {
    
    // UI connections
    @IBOutlet private var sourcePopUpButton: NSPopUpButton!
    @IBOutlet weak var chordLabel: NSTextField!
    @IBOutlet weak var accidentalsSelector: NSSegmentedControl!
    @IBOutlet weak var possibleChordsLabel: NSTextField!
    
    // midi
    var midi = AudioKit.midi
    var keys: Keyboard = Keyboard.init()
    var analyser: ChordAnalyser = ChordAnalyser(keyboard: Keyboard())

    
    // handle view loaded
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MIDI initialisation
        midi.openInput(name: "MIDI Input")
        midi.addListener(self)

        // UI initialisation
        sourcePopUpButton.removeAllItems()
        sourcePopUpButton.addItem(withTitle: "(Default MIDI Input)")
        sourcePopUpButton.addItems(withTitles: midi.inputNames)
        chordLabel.stringValue = "-"
        possibleChordsLabel.stringValue = ""
        
        // analyser
        analyser = ChordAnalyser.init(keyboard: keys)
        
    }
    
    
    // change of MIDI source
    @IBAction func sourceChanged(_ sender: NSPopUpButton) {
        if sender.indexOfSelectedItem > 0 {
            midi.closeAllInputs()
            midi.openInput(name: midi.inputNames[sender.indexOfSelectedItem - 1])
        }
    }

    
    // MIDI event handlers
    func receivedMIDINoteOn(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel, portID: MIDIUniqueID? = nil, offset: MIDITimeStamp = 0) {
        
        // update the keyboard class
        keys.updateKeys(key: Int(noteNumber), state: true)
        updateAccidentals()
        
        // analyse and update display
        analyser.analyse(keyStates: keys.keyStates, notes: keys.notes, nKeys: keys.nKeys!)
        analyser.chordName = formatChordLabel(label: analyser.chordName)
        updateChordLabel("\(analyser.chordName)")
        
        // possible chords
        var multiLineChordLabel =   ""
        analyser.possibleChords.sort(by: descending)
        
        if(analyser.possibleChords.count != 0) {
            
            for i in 0...(analyser.possibleChords.count - 1) {
                multiLineChordLabel += "\(analyser.possibleChords[i])\n"
            }
            
        }
        updatePossibleChordsLabel(multiLineChordLabel)
    }

    
    func receivedMIDINoteOff(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel, portID: MIDIUniqueID? = nil, offset: MIDITimeStamp = 0) {
        
        // update the keyboard class
        keys.updateKeys(key: Int(noteNumber), state: false)
        updateAccidentals()
        
        // analyse and update display
        if(keys.nKeysPressed != 0) {
            analyser.analyse(keyStates: keys.keyStates, notes: keys.notes, nKeys: keys.nKeys!)
        }
        else if keys.nKeysPressed == 0 {
            analyser.chordName = "-"
        }
        analyser.chordName = formatChordLabel(label: analyser.chordName)
        updateChordLabel("\(analyser.chordName)")
    }

    
    func receivedMIDIController(_ controller: MIDIByte, value: MIDIByte, channel: MIDIChannel, portID: MIDIUniqueID? = nil, offset: MIDITimeStamp = 0) {
    }
    func receivedMIDIPitchWheel(_ pitchWheelValue: MIDIWord, channel: MIDIChannel, portID: MIDIUniqueID? = nil, offset: MIDITimeStamp = 0) {
    }
    func receivedMIDIAftertouch(noteNumber: MIDINoteNumber, pressure: MIDIByte, channel: MIDIChannel, portID: MIDIUniqueID? = nil, offset: MIDITimeStamp = 0) {
    }
    func receivedMIDIAftertouch(_ pressure: MIDIByte, channel: MIDIChannel, portID: MIDIUniqueID? = nil, offset: MIDITimeStamp = 0) {
    }
    func receivedMIDIPitchWheel(_ pitchWheelValue: MIDIByte, channel: MIDIChannel, portID: MIDIUniqueID? = nil, offset: MIDITimeStamp = 0) {
    }
    func receivedMIDIProgramChange(_ program: MIDIByte, channel: MIDIChannel, portID: MIDIUniqueID? = nil, offset: MIDITimeStamp = 0) {
    }
    func receivedMIDISystemCommand(_ data: [MIDIByte], portID: MIDIUniqueID? = nil, offset: MIDITimeStamp = 0) {
    }

    // format chord label
    func formatChordLabel(label: String) -> String {
        var newLabel: String = ""
        newLabel = label
        newLabel = newLabel.replacingOccurrences(of: "b", with: "\u{266D}", options: .literal, range: nil)
        newLabel = newLabel.replacingOccurrences(of: "#", with: "\u{266F}", options: .literal, range: nil)
        newLabel = newLabel.replacingOccurrences(of: "/", with: " / ", options: .literal, range: nil)
        newLabel = newLabel.replacingOccurrences(of: "6 / 9", with: "6/9", options: .literal, range: nil) // hack to deformat spaces from prev line in 6/9 chord
        return newLabel
    }
    
    // update chord label
    func updateChordLabel(_ label: String) {
        DispatchQueue.main.async(execute: {
            self.chordLabel.stringValue = "\(label)"
        })
    }
    
    // update possible chords label
    func updatePossibleChordsLabel(_ label: String) {
        DispatchQueue.main.async(execute: {
            self.possibleChordsLabel.stringValue = "\(label)"
        })
    }
    
    // sort by descending
    func descending(value1: String, value2: String) -> Bool {
        return value1.count < value2.count;
    }
    
    // update accidentals
    func updateAccidentals() {
        DispatchQueue.main.async(execute: {
            switch self.accidentalsSelector.selectedSegment {
            case 0:
                self.analyser.accidentals = Keyboard.Accidentals.sharps
            case 1:
                self.analyser.accidentals = Keyboard.Accidentals.flats
            default:
                self.analyser.accidentals = self.analyser.accidentals
            }
        })
    }

    
    // default (probably don't remove)
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
}
