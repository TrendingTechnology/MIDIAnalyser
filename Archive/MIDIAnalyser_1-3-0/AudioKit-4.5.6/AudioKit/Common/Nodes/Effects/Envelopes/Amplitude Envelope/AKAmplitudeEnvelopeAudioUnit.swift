//
//  AKAmplitudeEnvelopeAudioUnit.swift
//  AudioKit
//
//  Created by Aurelius Prochazka, revision history on Github.
//  Copyright © 2018 AudioKit. All rights reserved.
//

import AVFoundation

public class AKAmplitudeEnvelopeAudioUnit: AKAudioUnitBase {

    func setParameter(_ address: AKAmplitudeEnvelopeParameter, value: Double) {
        setParameterWithAddress(AUParameterAddress(address.rawValue), value: Float(value))
    }

    func setParameterImmediately(_ address: AKAmplitudeEnvelopeParameter, value: Double) {
        setParameterImmediatelyWithAddress(AUParameterAddress(address.rawValue), value: Float(value))
    }

    var attackDuration: Double = AKAmplitudeEnvelope.defaultAttackDuration {
        didSet { setParameter(.attackDuration, value: attackDuration) }
    }

    var decayDuration: Double = AKAmplitudeEnvelope.defaultDecayDuration {
        didSet { setParameter(.decayDuration, value: decayDuration) }
    }

    var sustainLevel: Double = AKAmplitudeEnvelope.defaultSustainLevel {
        didSet { setParameter(.sustainLevel, value: sustainLevel) }
    }

    var releaseDuration: Double = AKAmplitudeEnvelope.defaultReleaseDuration {
        didSet { setParameter(.releaseDuration, value: releaseDuration) }
    }

    var rampDuration: Double = 0.0 {
        didSet { setParameter(.rampDuration, value: rampDuration) }
    }

    public override func initDSP(withSampleRate sampleRate: Double,
                                 channelCount count: AVAudioChannelCount) -> AKDSPRef {
        return createAmplitudeEnvelopeDSP(Int32(count), sampleRate)
    }

    public override init(componentDescription: AudioComponentDescription,
                  options: AudioComponentInstantiationOptions = []) throws {
        try super.init(componentDescription: componentDescription, options: options)

        let flags: AudioUnitParameterOptions = [.flag_IsReadable, .flag_IsWritable, .flag_CanRamp]

        let attackDuration = AUParameterTree.createParameter(
            withIdentifier: "attackDuration",
            name: "Attack time",
            address: AKAmplitudeEnvelopeParameter.attackDuration.rawValue,
            min: Float(AKAmplitudeEnvelope.attackDurationRange.lowerBound),
            max: Float(AKAmplitudeEnvelope.attackDurationRange.upperBound),
            unit: .seconds,
            unitName: nil,
            flags: flags,
            valueStrings: nil,
            dependentParameters: nil
        )
        let decayDuration = AUParameterTree.createParameter(
            withIdentifier: "decayDuration",
            name: "Decay time",
            address: AKAmplitudeEnvelopeParameter.decayDuration.rawValue,
            min: Float(AKAmplitudeEnvelope.decayDurationRange.lowerBound),
            max: Float(AKAmplitudeEnvelope.decayDurationRange.upperBound),
            unit: .seconds,
            unitName: nil,
            flags: flags,
            valueStrings: nil,
            dependentParameters: nil
        )
        let sustainLevel = AUParameterTree.createParameter(
            withIdentifier: "sustainLevel",
            name: "Sustain Level",
            address: AKAmplitudeEnvelopeParameter.sustainLevel.rawValue,
            min: Float(AKAmplitudeEnvelope.sustainLevelRange.lowerBound),
            max: Float(AKAmplitudeEnvelope.sustainLevelRange.upperBound),
            unit: .generic,
            unitName: nil,
            flags: flags,
            valueStrings: nil,
            dependentParameters: nil
        )
        let releaseDuration = AUParameterTree.createParameter(
            withIdentifier: "releaseDuration",
            name: "Release time",
            address: AKAmplitudeEnvelopeParameter.releaseDuration.rawValue,
            min: Float(AKAmplitudeEnvelope.releaseDurationRange.lowerBound),
            max: Float(AKAmplitudeEnvelope.releaseDurationRange.upperBound),
            unit: .seconds,
            unitName: nil,
            flags: flags,
            valueStrings: nil,
            dependentParameters: nil
        )
        
        setParameterTree(AUParameterTree.createTree(withChildren: [attackDuration, decayDuration, sustainLevel, releaseDuration]))
        attackDuration.value = Float(AKAmplitudeEnvelope.defaultAttackDuration)
        decayDuration.value = Float(AKAmplitudeEnvelope.defaultDecayDuration)
        sustainLevel.value = Float(AKAmplitudeEnvelope.defaultSustainLevel)
        releaseDuration.value = Float(AKAmplitudeEnvelope.defaultReleaseDuration)
    }

    public override var canProcessInPlace: Bool { return true }

}
