//
//  AKPhaseDistortionOscillatorAudioUnit.swift
//  AudioKit
//
//  Created by Aurelius Prochazka, revision history on Github.
//  Copyright © 2018 AudioKit. All rights reserved.
//

import AVFoundation

public class AKPhaseDistortionOscillatorAudioUnit: AKGeneratorAudioUnitBase {

    func setParameter(_ address: AKPhaseDistortionOscillatorParameter, value: Double) {
        setParameterWithAddress(AUParameterAddress(address.rawValue), value: Float(value))
    }

    func setParameterImmediately(_ address: AKPhaseDistortionOscillatorParameter, value: Double) {
        setParameterImmediatelyWithAddress(AUParameterAddress(address.rawValue), value: Float(value))
    }

    var frequency: Double = AKPhaseDistortionOscillator.defaultFrequency {
        didSet { setParameter(.frequency, value: frequency) }
    }

    var amplitude: Double = AKPhaseDistortionOscillator.defaultAmplitude {
        didSet { setParameter(.amplitude, value: amplitude) }
    }

    var phaseDistortion: Double = AKPhaseDistortionOscillator.defaultPhaseDistortion {
        didSet { setParameter(.phaseDistortion, value: phaseDistortion) }
    }

    var detuningOffset: Double = AKPhaseDistortionOscillator.defaultDetuningOffset {
        didSet { setParameter(.detuningOffset, value: detuningOffset) }
    }

    var detuningMultiplier: Double = AKPhaseDistortionOscillator.defaultDetuningMultiplier {
        didSet { setParameter(.detuningMultiplier, value: detuningMultiplier) }
    }

    var rampDuration: Double = 0.0 {
        didSet { setParameter(.rampDuration, value: rampDuration) }
    }

    public override func initDSP(withSampleRate sampleRate: Double,
                                 channelCount count: AVAudioChannelCount) -> AKDSPRef {
        return createPhaseDistortionOscillatorDSP(Int32(count), sampleRate)
    }

    public override init(componentDescription: AudioComponentDescription,
                  options: AudioComponentInstantiationOptions = []) throws {
        try super.init(componentDescription: componentDescription, options: options)

        let flags: AudioUnitParameterOptions = [.flag_IsReadable, .flag_IsWritable, .flag_CanRamp]

        let frequency = AUParameterTree.createParameter(
            withIdentifier: "frequency",
            name: "Frequency (Hz)",
            address: AKPhaseDistortionOscillatorParameter.frequency.rawValue,
            min: Float(AKPhaseDistortionOscillator.frequencyRange.lowerBound),
            max: Float(AKPhaseDistortionOscillator.frequencyRange.upperBound),
            unit: .hertz,
            unitName: nil,
            flags: flags,
            valueStrings: nil,
            dependentParameters: nil
        )
        let amplitude = AUParameterTree.createParameter(
            withIdentifier: "amplitude",
            name: "Amplitude",
            address: AKPhaseDistortionOscillatorParameter.amplitude.rawValue,
            min: Float(AKPhaseDistortionOscillator.amplitudeRange.lowerBound),
            max: Float(AKPhaseDistortionOscillator.amplitudeRange.upperBound),
            unit: .generic,
            unitName: nil,
            flags: flags,
            valueStrings: nil,
            dependentParameters: nil
        )
        let phaseDistortion = AUParameterTree.createParameter(
            withIdentifier: "phaseDistortion",
            name: "Amount of distortion, within the range [-1, 1]. 0 is no distortion.",
            address: AKPhaseDistortionOscillatorParameter.phaseDistortion.rawValue,
            min: Float(AKPhaseDistortionOscillator.phaseDistortionRange.lowerBound),
            max: Float(AKPhaseDistortionOscillator.phaseDistortionRange.upperBound),
            unit: .generic,
            unitName: nil,
            flags: flags,
            valueStrings: nil,
            dependentParameters: nil
        )
        let detuningOffset = AUParameterTree.createParameter(
            withIdentifier: "detuningOffset",
            name: "Frequency offset (Hz)",
            address: AKPhaseDistortionOscillatorParameter.detuningOffset.rawValue,
            min: Float(AKPhaseDistortionOscillator.detuningOffsetRange.lowerBound),
            max: Float(AKPhaseDistortionOscillator.detuningOffsetRange.upperBound),
            unit: .hertz,
            unitName: nil,
            flags: flags,
            valueStrings: nil,
            dependentParameters: nil
        )
        let detuningMultiplier = AUParameterTree.createParameter(
            withIdentifier: "detuningMultiplier",
            name: "Frequency detuning multiplier",
            address: AKPhaseDistortionOscillatorParameter.detuningMultiplier.rawValue,
            min: Float(AKPhaseDistortionOscillator.detuningMultiplierRange.lowerBound),
            max: Float(AKPhaseDistortionOscillator.detuningMultiplierRange.upperBound),
            unit: .generic,
            unitName: nil,
            flags: flags,
            valueStrings: nil,
            dependentParameters: nil
        )
        
        setParameterTree(AUParameterTree.createTree(withChildren: [frequency, amplitude, phaseDistortion, detuningOffset, detuningMultiplier]))
        frequency.value = Float(AKPhaseDistortionOscillator.defaultFrequency)
        amplitude.value = Float(AKPhaseDistortionOscillator.defaultAmplitude)
        phaseDistortion.value = Float(AKPhaseDistortionOscillator.defaultPhaseDistortion)
        detuningOffset.value = Float(AKPhaseDistortionOscillator.defaultDetuningOffset)
        detuningMultiplier.value = Float(AKPhaseDistortionOscillator.defaultDetuningMultiplier)
    }

    public override var canProcessInPlace: Bool { return true }

}
