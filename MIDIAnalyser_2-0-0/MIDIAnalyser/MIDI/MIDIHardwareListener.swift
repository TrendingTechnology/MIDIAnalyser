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
    
        
    // initialisation
    init() {
        
        // open MIDI inputs
        AudioKit.midi.openInput("(select input)")
        AudioKit.midi.addListener(self)
        
        // open the user preferred input
        if let preferredInputDevice = Preferences.load(key: .InputDevice) as? String {
            if AudioKit.midi.inputNames.contains(preferredInputDevice) {
                AudioKit.midi.openInput(preferredInputDevice)
            }
            else {
                MIDIHardwareListener.inputChange("All inputs")
            }
        }
        else {
            MIDIHardwareListener.inputChange("All inputs")
        }
        
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
    static func inputChange(_ input: String) {
        
        // if one specific input selected, open it
        if input != "All inputs" {
            AudioKit.midi.closeAllInputs()
            AudioKit.midi.openInput(input)
        }
        // otherwise open all inputs
        else {
            for inputName in AudioKit.midi.inputNames {
                AudioKit.midi.openInput(inputName)
            }
        }
        
    }
    
    
    // list all available inputs
    static func listInputs() -> [String] {
        var inputs: [String] = AudioKit.midi.inputNames
        inputs.insert("All inputs", at: 0)
        return inputs
    }
    
    
}
