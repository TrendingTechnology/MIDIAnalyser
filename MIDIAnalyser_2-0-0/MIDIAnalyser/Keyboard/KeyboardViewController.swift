//
//  KeyboardViewController.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 04/07/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import Cocoa


class KeyboardViewController: NSViewController {
    
    
    // keyboard, view controllers and listener
    private var keyboard = Keyboard()
    private var keyboardView: KeyboardView!
    private var typingListener: MIDITypingListener = MIDITypingListener()
    

    // initialisation on view load
    override func viewDidLoad() {
        
        // superclass loaded
        super.viewDidLoad()
        
        // create the view
        // note that the container view is slightly smaller than this view
        // to crop the rounding of the tops of the keys
        self.keyboardView = KeyboardView(frame: self.view.frame)
        self.view = keyboardView
        
        // add observers
        MIDINotificationCenter.observe(type: .noteOn, observer: self, selector: #selector(keyUpdate))
        MIDINotificationCenter.observe(type: .noteOff, observer: self, selector: #selector(keyUpdate))
        MIDINotificationCenter.observe(type: .control, observer: self, selector: #selector(keyUpdate))
        
        // add typing listener
        self.typingListener.startListening()
        
    }
    
    override func viewDidLayout() {
        keyboardView.keyContainer()
        keyboardView.keyDimensions()
    }
    
    // key updated function
    @objc func keyUpdate(_ notification: Notification) {
        
        // mappings for keyIndex to white keys index (could auto generate?)
        let whiteKeyDictionary: [Int : Int] = [
           0 : 0,
           2 : 1,
           3 : 2,
           5 : 3,
           7 : 4,
           8 : 5,
           10 : 6,
           12 : 7,
           14 : 8,
           15 : 9,
           17 : 10,
           19 : 11,
           20 : 12,
           22 : 13,
           24 : 14,
           26 : 15,
           27 : 16,
           29 : 17,
           31 : 18,
           32 : 19,
           34 : 20,
           36 : 21,
           38 : 22,
           39 : 23,
           41 : 24,
           43 : 25,
           44 : 26,
           46 : 27,
           48 : 28,
           50 : 29,
           51 : 30,
           53 : 31,
           55 : 32,
           56 : 33,
           58 : 34,
           60 : 35,
           62 : 36,
           63 : 37,
           65 : 38,
           67 : 39,
           68 : 40,
           70 : 41,
           72 : 42,
           74 : 43,
           75 : 44,
           77 : 45,
           79 : 46,
           80 : 47,
           82 : 48,
           84 : 49,
           86 : 50,
           87 : 51
        ]
        
        // mappings for keyIndex to black keys index (could auto generate?)
        let blackKeyDictionary: [Int : Int] = [
            1 : 0,
            4 : 1,
            6 : 2,
            9 : 3,
            11 : 4,
            13 : 5,
            16 : 6,
            18 : 7,
            21 : 8,
            23 : 9,
            25 : 10,
            28 : 11,
            30 : 12,
            33 : 13,
            35 : 14,
            37 : 15,
            40 : 16,
            42 : 17,
            45 : 18,
            47 : 19,
            49 : 20,
            52 : 21,
            54 : 22,
            57 : 23,
            59 : 24,
            61 : 25,
            64 : 26,
            66 : 27,
            69 : 28,
            71 : 29,
            73 : 30,
            76 : 31,
            78 : 32,
            81 : 33,
            83 : 34,
            85 : 35
        ]
        
        // which type of message received
        switch notification.name.rawValue {
        
        // case for noteOn messages
        case MIDINotificationCenter.MIDINotificationType.noteOn.rawValue:
            
            // try to cast the message as a MIDINotesMessage
            if let message = notification.object as? MIDINoteMessage {
                
                // figure out which key in the keys array it is
                let keyIndex = Keyboard.keyIndexOfMIDINumber(message.noteNumber)
                
                // if its a white key
                if Keyboard.isWhiteKeyIndex(keyIndex) {
                    
                    // get the corresponding index for the white keys array
                    if let whiteKeyIndex = whiteKeyDictionary[keyIndex] {
                        // change the colour of the key when pressed
                        DispatchQueue.main.async {
                            self.keyboardView.whiteKeys[whiteKeyIndex].fillColor = self.keyboardView.whiteKeys[whiteKeyIndex].pressedColor
                        }
                    }
                
                }
                // if its a black key
                else {
                    // get the corresponding index for the black keys array
                    if let blackKeyIndex = blackKeyDictionary[keyIndex] {
                        // change the colour of the key when pressed
                        DispatchQueue.main.async {
                            self.keyboardView.blackKeys[blackKeyIndex].fillColor = self.keyboardView.blackKeys[blackKeyIndex].pressedColor
                        }
                    }
                }

                
            }
            
        // case for noteOff messages
        case MIDINotificationCenter.MIDINotificationType.noteOff.rawValue:
        
            // try to cast the message as a MIDINotesMessage
            if let message = notification.object as? MIDINoteMessage {
                
                // figure out which key in the keys array it is
                let keyIndex = Keyboard.keyIndexOfMIDINumber(message.noteNumber)
                
                // if its a white key
                if Keyboard.isWhiteKeyIndex(keyIndex) {
                    
                    // get the corresponding index for the white keys array
                    if let whiteKeyIndex = whiteKeyDictionary[keyIndex] {
                        // reset the colour of the key when released
                        DispatchQueue.main.async {
                            self.keyboardView.whiteKeys[whiteKeyIndex].fillColor = self.keyboardView.whiteKeys[whiteKeyIndex].defaultColor
                        }
                    }
                    
                }
                // if its a black key
                else {
                    
                    // get the corresponding index for the black keys array
                    if let blackKeyIndex = blackKeyDictionary[keyIndex] {
                        // reset the colour of the key when released
                        DispatchQueue.main.async {
                            self.keyboardView.blackKeys[blackKeyIndex].fillColor = self.keyboardView.blackKeys[blackKeyIndex].defaultColor
                        }
                    }
                }
            }
            
        // default case, other notifications or objects
        default:
            break
            
        }

    }
    
}
