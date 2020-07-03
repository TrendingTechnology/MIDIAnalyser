//
//  MIDIListener.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 03/07/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Foundation
import AudioKit

class MIDIListener : AKMIDIListener {
    
    
    public var availableInputs: [String] = Array()
    
    
    init() {
        
        AudioKit.midi.openInput("(select input)")
        AudioKit.midi.addListener(self)
        inputChange(0)
        
        availableInputs = AudioKit.midi.inputNames
        
    }
    

    func receivedMIDINoteOn(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel) {
        
        print("noteOn")
        
    }
    
    func receivedMIDINoteOff(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel) {
        
        print("noteOff")
        
    }
    
    func receivedMIDIController(_ controller: MIDIByte, value: MIDIByte, channel: MIDIChannel) {
        
        print("controller")
        
    }
    
    func inputChange(_ index: Int) {
        
        // if one specific input opened, select it
        if index > 0 {
            AudioKit.midi.closeAllInputs()
            AudioKit.midi.openInput(AudioKit.midi.inputNames[index - 1])
        }
        // otherwise take MIDI data from all inputs
        else {
            for inputName in AudioKit.midi.inputNames {
                AudioKit.midi.openInput(inputName)
            }
        }
        
    }
    
    
}
