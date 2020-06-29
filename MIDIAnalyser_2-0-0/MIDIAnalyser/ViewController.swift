//
//  ViewController.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 05/04/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Cocoa
import AudioKit

class ViewController: NSViewController, AKMIDIListener {
   
    // GUI
    @IBOutlet var chordNameLabel: NSTextField!
    
    // MIDI handling
    var MIDI = AudioKit.midi
    var keys: Keyboard = Keyboard.init()
    var analyser: ChordAnalyser = ChordAnalyser.init()
    

    // initialisation
    override func viewDidLoad() {
        
        // view loaded
        super.viewDidLoad()
        chordNameLabel.stringValue = "-"
        
        // MIDI initialisation
        MIDI.openInput(name: "MIDI Input")
        MIDI.addListener(self)

    }
    
    
    // something default
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    
    // MIDI event handlers

    func receivedMIDINoteOn(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel, portID: MIDIUniqueID? = nil, offset: MIDITimeStamp = 0) {
        
        // update the keyboard state
        keys.setKeyState(MIDINumber: Int(noteNumber), state: true)
        analyser.analyse(keyStates: keys.keyStates)
        updateChordLabel(analyser.chordName)
        
    }

    
    func receivedMIDINoteOff(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel, portID: MIDIUniqueID? = nil, offset: MIDITimeStamp = 0) {
       
        // update the keyboard state
        keys.setKeyState(MIDINumber: Int(noteNumber), state: false)
        analyser.analyse(keyStates: keys.keyStates)
        updateChordLabel(analyser.chordName)
        
    }

    /* other functions to be implemented:
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
    }*/
    
    func updateChordLabel(_ label: String) {
        DispatchQueue.main.async(execute: {
            self.chordNameLabel.stringValue = "\(label)"
        })
    }

    

}

