//
//  MIDIListener.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 03/07/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Foundation
import AudioKit


class MIDIHardwareListener: AKMIDIListener {
    
    
    // list of available inputs
    public var availableInputs: [String] = Array()
    
    
    // initialisation
    init() {
        
        // open MIDI inputs
        AudioKit.midi.openInput("(select input)")
        AudioKit.midi.addListener(self)
        inputChange(0)
        
        // record the available inputs
        availableInputs = AudioKit.midi.inputNames
        
    }
    

    // noteOn event handler
    func receivedMIDINoteOn(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel) {
        let message = MIDINoteMessage(messageType: .noteOn, noteNumber: Int(noteNumber), velocity: Int(velocity))
        MIDINotificationCenter.post(type: .noteOn, object: message)
    }
    
    // noteOff event handler
    func receivedMIDINoteOff(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel) {
        let message = MIDINoteMessage(messageType: .noteOn, noteNumber: Int(noteNumber), velocity: Int(velocity))
        MIDINotificationCenter.post(type: .noteOff, object: message)
    }
    
    // control event handler
    func receivedMIDIController(_ controller: MIDIByte, value: MIDIByte, channel: MIDIChannel) {
        
        // sustain pedal
        if controller.magnitude == MIDIControlMessage.MIDIControlMessageType.sustain.rawValue {
            let message = MIDIControlMessage(type: .sustain, value: Int(value))
            MIDINotificationCenter.post(type: .control, object: message)
        }
        
    }
    
    // input change handler
    func inputChange(_ index: Int) {
        
        // if one specific input selected, open it
        if index > 0 {
            AudioKit.midi.closeAllInputs()
            AudioKit.midi.openInput(AudioKit.midi.inputNames[index - 1])
        }
        // otherwise open all inputs
        else {
            for inputName in AudioKit.midi.inputNames {
                AudioKit.midi.openInput(inputName)
            }
        }
        
    }
    
    
}
