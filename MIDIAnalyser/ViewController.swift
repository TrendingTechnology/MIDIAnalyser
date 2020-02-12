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
        sourcePopUpButton.addItem(withTitle: "(Select MIDI Input)")
        sourcePopUpButton.addItems(withTitles: midi.inputNames)
        chordLabel.stringValue = "-"
    
        print(midi.inputNames)
        
        
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
        updateChordLabel("\(analyser.chordName)")
        
    }

    func receivedMIDINoteOff(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel, portID: MIDIUniqueID? = nil, offset: MIDITimeStamp = 0) {
        
        // update the keyboard class
        keys.updateKeys(key: Int(noteNumber), state: false)
        updateAccidentals()
        
        // analyse and update display
        if(keys.nKeysPressed != 0) {
            analyser.analyse(keyStates: keys.keyStates, notes: keys.notes, nKeys: keys.nKeys!)
            updateChordLabel("\(analyser.chordName)")
        }
        updateChordLabel("-")
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

    
    // update chord label
    func updateChordLabel(_ label: String) {
        DispatchQueue.main.async(execute: {
            self.chordLabel.stringValue = "\(label)"
        })
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
