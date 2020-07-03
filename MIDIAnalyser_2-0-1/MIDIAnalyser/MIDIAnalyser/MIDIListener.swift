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
    
    
}
