//
//  MIDIMessage.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 03/07/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Foundation


class MIDIMessage {
    
    // possible messaage types
    var messageType: MIDINotificationCenter.MIDINotificationType
    
    // initialisation
    init(messageType: MIDINotificationCenter.MIDINotificationType) {
        self.messageType = messageType
    }
    
}

