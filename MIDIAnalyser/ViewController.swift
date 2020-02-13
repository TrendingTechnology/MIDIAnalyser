//
//  ViewController.swift
//  MIDIAnalyser
//
//  Created by Tim Brewis on 11/02/2020.
//  Copyright © 2020 Tim Brewis. All rights reserved.
//

import AudioKit
import AppKit
import Cocoa

class ViewController: NSViewController, NSWindowDelegate, AKMIDIListener {
    
    // UI connections
    @IBOutlet private var sourcePopUpButton: NSPopUpButton!
    @IBOutlet weak var chordLabel: NSTextField!
    @IBOutlet weak var accidentalsSelector: NSSegmentedControl!
    @IBOutlet weak var possibleChordsLabel: NSTextField!
    @IBOutlet weak var keyboardBox: NSBox!
    @IBOutlet var showNo5Button: NSButton!
    
    // midi
    var midi = AudioKit.midi
    var keys: Keyboard = Keyboard.init()
    var analyser: ChordAnalyser = ChordAnalyser(keyboard: Keyboard())
    
    var whiteKeys: [NSButton] = []
    var whiteKeyWidth:Double = 0
    var whiteKeyHeight:Double = 0
    
    var blackKeys: [NSButton] = []
    var blackKeyWidth:Double = 0
    var blackKeyHeight:Double = 0
    
    var showNo5: Bool = false;
    
    var keyPressedColor: NSColor = NSColor(red: 3/255, green: 252/255, blue: 177/255, alpha: 1)

    
    // initialisation for view
    override func viewDidLoad() {
        
        // view loaded
        super.viewDidLoad()
        
        // MIDI initialisation
        midi.openInput(name: "MIDI Input")
        midi.addListener(self)

        // UI initialisation
        sourcePopUpButton.removeAllItems()
        sourcePopUpButton.addItem(withTitle: "(Default MIDI Input)")
        sourcePopUpButton.addItems(withTitles: midi.inputNames)
        chordLabel.stringValue = "-"
        possibleChordsLabel.stringValue = ""
        
        showNo5Button.target = self
        showNo5Button.action = #selector(updateNo5)

        
        // initialise NSButton key arrays
        whiteKeys = Array(repeating: NSButton(), count: keys.nWhiteKeys)
        whiteKeyWidth = Float(keyboardBox.frame.size.width) / keys.nWhiteKeys
        whiteKeyHeight = Double(keyboardBox.frame.size.height)
        
        blackKeys = Array(repeating: NSButton(), count: keys.nBlackKeys)
        blackKeyWidth = 0.7 * whiteKeyWidth
        blackKeyHeight = 0.6 * whiteKeyHeight
        
        for i in 0...(whiteKeys.count - 1) {
            whiteKeys[i] = NSButton(frame: NSRect(x: Double(keyboardBox.frame.origin.x) + i * whiteKeyWidth, y: Double(keyboardBox.frame.origin.y), width: Double(whiteKeyWidth - 2), height: whiteKeyHeight));
            whiteKeys[i].target = self
            whiteKeys[i].action = #selector(buttonTest(_:))
            whiteKeys[i].title = ""
            whiteKeys[i].image = NSImage.swatchWithColor(color: NSColor.white, size: NSMakeSize(CGFloat(whiteKeyWidth), CGFloat(whiteKeyHeight)))
            whiteKeys[i].isBordered = false
            self.view.addSubview(whiteKeys[i])
        }
        
        let blackKeyOffsets = [0,  1,  1,  2,  2,  2,
                                   3,  3,  4,  4,  4,
                                   5,  5,  6,  6,  6,
                                   7,  7,  8,  8,  8,
                                   9,  9, 10, 10, 10,
                                  11, 11, 12, 12, 12,
                                  13, 13, 14, 14, 14,
                                  15, 15, 16, 16, 16]
        
        for i in 0...(blackKeys.count - 1) {
            blackKeys[i] = NSButton(frame: NSRect(x: Double(keyboardBox.frame.origin.x) + (whiteKeyWidth - Double(blackKeyWidth / 2)) + (i + blackKeyOffsets[i]) * whiteKeyWidth, y: Double(keyboardBox.frame.origin.y) + Double(keyboardBox.frame.size.height) - blackKeyHeight, width: Double(blackKeyWidth * 0.9), height: blackKeyHeight));
            blackKeys[i].target = self
            blackKeys[i].action = #selector(buttonTest(_:))
            blackKeys[i].title = ""
            blackKeys[i].image = NSImage.swatchWithColor(color: NSColor.black, size: NSMakeSize(CGFloat(blackKeyWidth), CGFloat(blackKeyHeight)))
            blackKeys[i].isBordered = false
            self.view.addSubview(blackKeys[i])
        }
        
        
        // analyser
        analyser = ChordAnalyser.init(keyboard: keys)
        
        
    }
    
    override func viewDidAppear() {
        view.window?.delegate = self
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
        if(keys.nKeysPressed > 2) {
            analyser.chordName = formatChordLabel(label: analyser.chordName)
            updateChordLabel("\(analyser.chordName)")
        }

        
        // possible chords
        var multiLineChordLabel =   ""
        analyser.possibleChords.sort(by: descending)
        
        if(analyser.possibleChords.count != 0) {
            
            for i in 0...(analyser.possibleChords.count - 1) {
                multiLineChordLabel += "\(analyser.possibleChords[i])\n"
            }
            
        }
        updatePossibleChordsLabel(multiLineChordLabel)
        
        // UI keyboard
        keyStateChange(Int(noteNumber), true)
        
    }

    
    func receivedMIDINoteOff(noteNumber: MIDINoteNumber, velocity: MIDIVelocity, channel: MIDIChannel, portID: MIDIUniqueID? = nil, offset: MIDITimeStamp = 0) {
        
        // update the keyboard class
        keys.updateKeys(key: Int(noteNumber), state: false)
        updateAccidentals()
        
        // analyse and update display
        if(keys.nKeysPressed != 0) {
            analyser.analyse(keyStates: keys.keyStates, notes: keys.notes, nKeys: keys.nKeys!)
        }
        else if keys.nKeysPressed == 0 {
            analyser.chordName = "-"
        }
        analyser.chordName = formatChordLabel(label: analyser.chordName)
        updateChordLabel("\(analyser.chordName)")
        
        // UI keyboard
        keyStateChange(Int(noteNumber), false)
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

    // format chord label
    func formatChordLabel(label: String) -> String {
        var newLabel: String = ""
        newLabel = label
        newLabel = newLabel.replacingOccurrences(of: "b", with: "\u{266D}", options: .literal, range: nil)
        newLabel = newLabel.replacingOccurrences(of: "#", with: "\u{266F}", options: .literal, range: nil)
        newLabel = newLabel.replacingOccurrences(of: "add", with: " add", options: .literal, range: nil)
        newLabel = newLabel.replacingOccurrences(of: "/", with: " / ", options: .literal, range: nil)
        newLabel = newLabel.replacingOccurrences(of: "6 / 9", with: "6/9", options: .literal, range: nil) // hack to deformat spaces from prev line in 6/9 chord
        if(!showNo5) {
            newLabel = newLabel.replacingOccurrences(of: "(no5)", with: "", options: .literal, range: nil)
        }
        
        return newLabel
    }
    
    // update chord label
    func updateChordLabel(_ label: String) {
        DispatchQueue.main.async(execute: {
            self.chordLabel.stringValue = "\(label)"
        })
    }
    
    // update possible chords label
    func updatePossibleChordsLabel(_ label: String) {
        DispatchQueue.main.async(execute: {
            self.possibleChordsLabel.stringValue = "\(label)"
        })
    }
    
    // update keys
    func keyStateChange(_ noteNumber: Int, _ state: Bool) {
        DispatchQueue.main.async(execute: {
            
            // convert MIDI number to black or white key number
                                            //   | = white key
                                            //   |       |   |       |       |   |       |   Ab
            let correspondingKeyNumber: [Int] = [0,  0,  1,  2,  1,  3,  2,  4,  5,  3,  6,  4,    // A0 - Ab1
                                                 7,  5,  8,  9,  6, 10,  7, 11, 12,  8, 13,  9,    // A1 - Ab2
                                                14, 10, 15, 16, 11, 17, 12, 18, 19, 13, 20, 14,    // A2 - Ab3
                                                21, 15, 22, 23, 16, 24, 17, 25, 26, 18, 27, 19,    // A3 - Ab4
                                                28, 20, 29, 30, 21, 31, 22, 32, 33, 23, 34, 24,    // A4 - Ab5
                                                35, 25, 36, 37, 26, 38, 27, 39, 40, 28, 41, 29,    // A5 - Ab6
                                                42, 30, 43, 44, 31, 45, 32, 46, 47, 33, 48, 34,    // A6 - Ab7
                                                49, 35, 50, 51, 36, 52, 37, 53, 54, 38, 55, 39]    // A7 - Ab8
            
            // update keys
            if noteNumber >= self.keys.minMIDINumber && noteNumber < self.keys.maxMIDINumber {
                if state {
                    if(Keyboard.isWhiteKey(key: Int(noteNumber) - self.keys.minMIDINumber)) {
                        self.whiteKeys[correspondingKeyNumber[Int(noteNumber - self.keys.minMIDINumber)]].image = NSImage.swatchWithColor(color: self.keyPressedColor, size: NSMakeSize(CGFloat(self.whiteKeyWidth), CGFloat(self.whiteKeyHeight)))
                    }
                    else {
                        self.blackKeys[correspondingKeyNumber[Int(noteNumber - self.keys.minMIDINumber)]].image = NSImage.swatchWithColor(color: self.keyPressedColor, size: NSMakeSize(CGFloat(self.blackKeyWidth), CGFloat(self.blackKeyHeight)))
                    }
                }
                else  {
                    if(Keyboard.isWhiteKey(key: Int(noteNumber) - self.keys.minMIDINumber)) {
                        self.whiteKeys[correspondingKeyNumber[Int(noteNumber - self.keys.minMIDINumber)]].image = NSImage.swatchWithColor(color: NSColor.white, size: NSMakeSize(CGFloat(self.whiteKeyWidth), CGFloat(self.whiteKeyHeight)))
                    }
                    else {
                        self.blackKeys[correspondingKeyNumber[Int(noteNumber - self.keys.minMIDINumber)]].image = NSImage.swatchWithColor(color: NSColor.black, size: NSMakeSize(CGFloat(self.blackKeyWidth), CGFloat(self.blackKeyHeight)))
                    }
                }
            }
            
        })
    }
    
    func keyPositionChange() {
        DispatchQueue.main.async(execute: {
            
            var x: Double = 0
            var y: Double = 0
            for i in 0...(self.whiteKeys.count - 1) {
                x = Double(self.keyboardBox.frame.origin.x) + i * self.whiteKeyWidth
                y = Double(self.keyboardBox.frame.origin.y)
                self.whiteKeys[i].setFrameOrigin(NSPoint(x: x, y: y))
                //self.view.addSubview(whiteKeys[i])
            }
            
            x = 0
            y = 0
            let blackKeyOffsets = [0,  1,  1,  2,  2,  2,
                                       3,  3,  4,  4,  4,
                                       5,  5,  6,  6,  6,
                                       7,  7,  8,  8,  8,
                                       9,  9, 10, 10, 10,
                                      11, 11, 12, 12, 12,
                                      13, 13, 14, 14, 14,
                                      15, 15, 16, 16, 16]
            
            for i in 0...(self.blackKeys.count - 1) {
                let offset: Double = (i + blackKeyOffsets[i]) * self.whiteKeyWidth
                x = Double(self.keyboardBox.frame.origin.x) + (self.whiteKeyWidth - Double(self.blackKeyWidth / 2)) + offset
                y = Double(self.keyboardBox.frame.origin.y) + Double(self.keyboardBox.frame.size.height) - self.blackKeyHeight
                self.blackKeys[i].setFrameOrigin(NSPoint(x: x, y: y))
                //self.view.addSubview(blackKeys[i])
            }
            
        })
    }
    
    // sort by descending
    func descending(value1: String, value2: String) -> Bool {
        return value1.count < value2.count;
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

    
    // key clicked
    @objc func buttonTest(_ sender: NSButton) {
        //print("Test button")
    }
    
    // no5 button clicked
    @objc func updateNo5(_ sender: NSButton) {
        showNo5 = !showNo5
    }

    
    

    
    // default (probably don't remove)
    override var representedObject: Any? {
        didSet {
            // Update the view, if already loaded.
        }
    }
    
    // handle window resize events
    func windowDidResize(_ notification: Notification) {
        keyPositionChange()
    }
}

extension NSImage {
class func swatchWithColor(color: NSColor, size: NSSize) -> NSImage {
    let image = NSImage(size: size)
    image.lockFocus()
    color.drawSwatch(in: NSMakeRect(0, 0, size.width, size.height))
    image.unlockFocus()
    return image
   }
}

