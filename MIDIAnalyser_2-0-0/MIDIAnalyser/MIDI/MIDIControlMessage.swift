//
//  MIDIControlMessage.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 03/07/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Foundation


class MIDIControlMessage : MIDIMessage {
    
    // control events
    enum MIDIControlMessageType: Int {
        case sustain = 64
    }
    
    // control data
    var controlMessageType: MIDIControlMessageType
    var value: Int
    
    // initialisation
    init(type: MIDIControlMessageType, value: Int) {
        self.controlMessageType = type
        self.value = value
        super.init(messageType: MIDINotificationCenter.MIDINotificationType.control)
    }
}
