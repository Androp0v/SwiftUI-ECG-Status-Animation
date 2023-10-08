//
//  WaveformProvider.swift
//  SwiftUI ECG Status Animation
//
//  Created by Raúl Montón Pinillos on 8/10/23.
//

import SwiftUI

enum Waveform {
    case ecg
    case torsades
    case dead
}

class WaveformProvider: ObservableObject {
    
    let windowDuration: TimeInterval
    
    @MainActor @Published private(set) var lastWaveform: Waveform = .ecg
    @MainActor @Published private(set) var currentWaveform: Waveform = .ecg
    @MainActor @Published private(set) var nextWaveform: Waveform = .ecg
    
    private var beatStartTime: TimeInterval = Date.now.timeIntervalSinceReferenceDate
    private var currentConfig = ECGWaveformConfiguration.random
    private var lastConfig = ECGWaveformConfiguration.random
    
    enum Beat {
        case current
        case last
    }
    
    init(windowDuration: TimeInterval) {
        self.windowDuration = windowDuration
    }
    
    @MainActor func transition(to waveform: Waveform) {
        withAnimation {
            nextWaveform = waveform
        }
    }
    
    @MainActor func ecg(date: Date, beat: Beat = .current) -> Double {
        let time = fractionComplete(date: date)
        return ecg(date: date, time: time, beat: beat)
    }
    
    @MainActor func ecg(date: Date, time: TimeInterval, beat: Beat = .current) -> Double {
        
        updateCurrentLast(for: date)
        
        let config: ECGWaveformConfiguration
        let waveform: Waveform
        switch beat {
        case .current:
            config = currentConfig
            waveform = currentWaveform
        case .last:
            config = lastConfig
            waveform = lastWaveform
        }
        
        switch waveform {
        case .ecg:
            return ecg(time: time, config: config)
        case .torsades:
            return torsades(time: time, config: config)
        case .dead:
            return 0.0
        }
    }
    
    @MainActor @discardableResult func fractionComplete(date: Date) -> Double {
        let elapsedTime = date.timeIntervalSinceReferenceDate - beatStartTime
        updateCurrentLast(for: date)
        return elapsedTime.truncatingRemainder(dividingBy: windowDuration) / windowDuration
    }
    
    @MainActor private func updateCurrentLast(for date: Date) {
        let elapsedTime = date.timeIntervalSinceReferenceDate - beatStartTime
        
        if elapsedTime > windowDuration {
            lastConfig = currentConfig
            currentConfig = ECGWaveformConfiguration.random
            
            beatStartTime = date.timeIntervalSinceReferenceDate
            
            withAnimation {
                lastWaveform = currentWaveform
                currentWaveform = nextWaveform
            }
        }
    }
    
    // MARK: - Waveforms
    
    func ecg(time: TimeInterval, config: ECGWaveformConfiguration) -> Double {
        let pStartTime = config.startTime
        let pEndTime = config.startTime + 0.1
        
        let qStartTime = pEndTime + config.pQTime
        let qEndTime = qStartTime + 0.05
        
        let rUpStartTime = qEndTime
        let rUpEndTime = rUpStartTime + config.rUpTime
        
        let rDownStartTime = rUpEndTime
        let rDownEndTime = rDownStartTime + config.rDownTime
        
        let sStartTime = rDownEndTime
        let sEndTime = sStartTime + 0.05
        
        let tStartTime = sEndTime + config.sTTime
        let tEndTime = tStartTime + 0.2
                                
        if time >= pStartTime && time < pEndTime {
            // P wave
            let pWaveTime = time - config.startTime
            return config.pWaveScaleFactor * exp(-pow((pWaveTime - 0.05) / 0.02, 2))
        } else if time >= qStartTime && time < qEndTime {
            // Q
            let qSpikeTime = time - qStartTime
            return -config.qScaleFactor * qSpikeTime / 0.05
        } else if time >= rUpStartTime && time < rUpEndTime {
            // R up
            let qrsTime = time - rUpStartTime
            return ((config.rScaleFactor + config.qScaleFactor) * qrsTime / config.rUpTime) - config.qScaleFactor
        } else if time >= rDownStartTime && time < rDownEndTime {
            // R down
            let qrsTime = time - rDownStartTime
            return config.rScaleFactor - ((config.rScaleFactor + config.sScaleFactor) * qrsTime / config.rDownTime)
        } else if time >= sStartTime && time < sEndTime {
            // S
            let sSpikeTime = time - sStartTime
            return config.sScaleFactor * sSpikeTime / 0.05 - config.sScaleFactor
        } else if time >= tStartTime && time < tEndTime {
            // T wave
            let tWaveTime = time - tStartTime
            return config.tWaveScaleFactor * exp(-pow((tWaveTime - 0.1) / 0.05, 2))
        }
        return 0.0
    }
    
    func dead() -> Double {
        return 0.0
    }
    
    func torsades(time: TimeInterval, config: ECGWaveformConfiguration) -> Double {
        let lowFrequency = sin(config.lowFrequencyParameter * (time + config.torsadesOffset))
        let midFrequency = sin(config.midFrequencyParameter * (time + config.torsadesOffset))
        let highFrequency = sin(config.highFrequencyParameter * (time + config.torsadesOffset))
        return 0.3 + 0.5 * lowFrequency * midFrequency * highFrequency
    }
}
