//
//  AKMusicTrack+Events.swift
//  AudioKit
//
//  Created by Jeff Cooper on 10/10/18.
//  Copyright © 2018 AudioKit. All rights reserved.
//

import Foundation

extension AKMusicTrack {

    open var eventData: [AppleMIDIEvent]? {
        return getRawEventData()
    }

    open var noteData: [AppleMIDIEvent]? {
        return getRawEventData(ofType: kMusicEventType_MIDINoteMessage)
    }

    open var programChangeEvents: [MIDIProgramChangeEvent] {
        var pgmEvents = [MIDIProgramChangeEvent]()
        if let events = eventData {
            for event in events {
                if event.type == kMusicEventType_MIDIChannelMessage {
                    let data = UnsafePointer<MIDIChannelMessage>(event.data?.assumingMemoryBound(to: MIDIChannelMessage.self))
                    guard let data1 = data?.pointee.data1,
                        let statusData: MIDIByte = data?.pointee.status else {
                            break
                    }
                    if let status = statusData.status,
                        let channel = statusData.channel {
                        if status == .programChange {
                            let pgmEvent = MIDIProgramChangeEvent(time: event.time, channel: channel, number: data1)
                            pgmEvents.append(pgmEvent)
                        }
                    }
                }
            }
        }
        return pgmEvents
    }

    open func debug() {
        guard let events = eventData else {
            return
        }
        for event in events {
            switch event.type {
            case kMusicEventType_MIDINoteMessage:
                let data = UnsafePointer<MIDINoteMessage>(event.data?.assumingMemoryBound(to: MIDINoteMessage.self))
                guard let channel = data?.pointee.channel,
                    let note = data?.pointee.note,
                    let velocity = data?.pointee.velocity,
                    let dur = data?.pointee.duration else {
                        AKLog("Problem with raw midi note message")
                        return
                }
                print("MIDI Note @: \(event.time) - note: \(note) - velocity: \(velocity) - duration: \(dur) - channel: \(channel)")
            case kMusicEventType_Meta:
                let data = UnsafePointer<MIDIMetaEvent>(event.data?.assumingMemoryBound(to: MIDIMetaEvent.self))
                guard let midiData = data?.pointee.data,
                    let length = data?.pointee.dataLength,
                    let type = data?.pointee.metaEventType else {
                        AKLog("Problem with raw midi meta message")
                        return
                }
                print("MIDI Meta @ \(event.time) - size: \(length) - type: \(type) - data: \(midiData)")
            case kMusicEventType_MIDIChannelMessage:
                let data = UnsafePointer<MIDIChannelMessage>(event.data?.assumingMemoryBound(to: MIDIChannelMessage.self))
                guard let data1 = data?.pointee.data1,
                    let data2 = data?.pointee.data2,
                    let statusData = data?.pointee.status else {
                        AKLog("Problem with raw midi channel message")
                        return
                }
                if let status = statusData.status,
                    let channel = statusData.channel {
                    switch status {
                    case .programChange:
                        print("MIDI Program Change @ \(event.time) - program: \(data1) - channel: \(channel)")
                    default:
                        print("MIDI Channel Message @ \(event.time) - data1: \(data1) - data2: \(data2) - status: \(status)")
                    }
                }
            default:
                print("MIDI Event @ \(event.time)")
            }
        }
    }

    private func getRawEventData(ofType type: MusicEventType? = nil) -> [AppleMIDIEvent]? {
        var events: [AppleMIDIEvent]?
        guard let track = internalMusicTrack else {
            print("debug failed - track doesn't exist")
            return events
        }

        events = [AppleMIDIEvent]()

        var eventTime = MusicTimeStamp(0)
        var eventType = MusicEventType()
        var eventData: UnsafeRawPointer?
        var eventDataSize: UInt32 = 0
        var hasNextEvent: DarwinBoolean = false

        var iterator: MusicEventIterator!
        NewMusicEventIterator(track, &iterator)
        MusicEventIteratorHasCurrentEvent(iterator, &hasNextEvent)

        while hasNextEvent.boolValue {
            MusicEventIteratorGetEventInfo(iterator, &eventTime, &eventType, &eventData, &eventDataSize)
            if type == nil || type == eventType,
                let data = eventData {
                events?.append(AppleMIDIEvent(time: eventTime, type: eventType, data: data, dataSize: eventDataSize))
            }
            MusicEventIteratorNextEvent(iterator)
            MusicEventIteratorHasCurrentEvent(iterator, &hasNextEvent)
        }
        DisposeMusicEventIterator(iterator)
        return events
    }

}

public struct AppleMIDIEvent {
    var time: MusicTimeStamp
    var type: MusicEventType
    var data: UnsafeRawPointer?
    var dataSize: UInt32
}

public struct MIDIProgramChangeEvent {
    var time: MusicTimeStamp
    var channel: MIDIChannel
    var number: MIDIByte
}
