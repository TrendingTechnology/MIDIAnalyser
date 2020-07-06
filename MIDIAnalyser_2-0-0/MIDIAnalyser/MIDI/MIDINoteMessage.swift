//
//  MIDINoteMessage.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 03/07/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Foundation


class MIDINoteMessage: MIDIMessage {
    
    // note data
    var noteNumber: Int
    var velocity: Int
    
    // initialisation
    init(messageType: MIDINotificationCenter.MIDINotificationType, noteNumber: Int, velocity: Int) {
        self.noteNumber = noteNumber
        self.velocity = velocity
        super.init(messageType: messageType)
    }
    
}
